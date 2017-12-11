//
//  DownloadManager.swift
//  DaisyNet
//
//  Created by mengqingzheng on 2017/10/12.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - downloadManager
class DownloadManager {
    static let `default` = DownloadManager()
    /// 下载任务管理
    fileprivate var downloadTasks = [String: DownloadTaskManager]()
    
    func download(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        ->DownloadTaskManager
    {
        let key = cacheKey(url, parameters)
        let taskManager = DownloadTaskManager(url, parameters: parameters)
        taskManager.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        self.downloadTasks[key] = taskManager
        taskManager.cancelCompletion = {
            self.downloadTasks.removeValue(forKey: key)
        }
        return taskManager
    }
    /// 暂停下载
    func cancel(_ url: String, parameters: Parameters?) {
        let key = cacheKey(url, parameters)
        let task = downloadTasks[key]
        task?.downloadRequest?.cancel()
        task?.cancelCompletion = {
            self.downloadTasks.removeValue(forKey: key)
        }
    }
    /// 删除单个下载
    func delete(_ url: String, parameters: Parameters?, completion: @escaping (Bool)->()) {
        let key = cacheKey(url, parameters)
        if let task = downloadTasks[key] {
            task.downloadRequest?.cancel()
            task.cancelCompletion = {
                self.downloadTasks.removeValue(forKey: key)
                CacheManager.default.removeObjectCache(key, completion: completion)
            }
        } else {
            if let path = getFilePath(key)
            { /// 下载完成了
                do {
                    let arr = path.components(separatedBy: "/")
                    let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                    let fileURL = cachesURL.appendingPathComponent(arr.last!)
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    DaisyLog(error)
                }
            }
            CacheManager.default.removeObjectCache(key, completion: completion)
        }
    }
    /// 下载完成路径
    func downloadFilePath(_ url: String, parameters: Parameters?) -> URL? {
        let key = cacheKey(url, parameters)
        if let path = getFilePath(key),
            let pathUrl = URL(string: path) {
            return pathUrl
        }
        return nil
    }
    /// 下载百分比
    func downloadPercent(_ url: String, parameters: Parameters?) -> Double {
        let key = cacheKey(url, parameters)
        let percent = getProgress(key)
        return percent
    }
    /// 下载状态
    func downloadStatus(_ url: String, parameters: Parameters?) -> DownloadStatus {
        let key = cacheKey(url, parameters)
        let task = downloadTasks[key]
        if downloadPercent(url, parameters: parameters) == 1 { return .complete }
        return task?.downloadStatus ?? .suspend
    }
    /// 下载进度
    @discardableResult
    func downloadProgress(_ url: String, parameters: Parameters?, progress: @escaping ((Double)->())) -> DownloadTaskManager? {
        let key = cacheKey(url, parameters)
        if let task = downloadTasks[key], downloadPercent(url, parameters: parameters) < 1 {
            task.downloadProgress(progress: { pro in
                progress(pro)
            })
            return task
        } else {
            let pro = downloadPercent(url, parameters: parameters)
            progress(pro)
            return nil
        }
    }
}

// MARK: - 下载状态
public enum DownloadStatus {
    case downloading
    case suspend
    case complete
}

// MARK: - taskManager
public class DownloadTaskManager {
    fileprivate var downloadRequest: DownloadRequest?
    fileprivate var downloadStatus: DownloadStatus = .suspend
    fileprivate var cancelCompletion: (()->())?
    fileprivate var cccompletion: (()->())?
    var cacheDictionary = [String: Data]()
    private var key: String
    
    init(_ url: String,
         parameters: Parameters? = nil) {
        key = cacheKey(url, parameters)
    }
    @discardableResult
    fileprivate func download(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DownloadTaskManager
    {
        let destination = downloadDestination()
        let resumeData = getResumeData(key)
        if let resumeData = resumeData {
            downloadRequest = manager.download(resumingWith: resumeData, to: destination)
        } else {
            downloadRequest = manager.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers, to: destination)
        }
        downloadStatus = .downloading
        return self
    }
    
    lazy var manager: SessionManager = {
//        let configuration = URLSessionConfiguration.background(withIdentifier: "com.\(key).app.background")
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration)
    }()
    /// 下载进度
    @discardableResult
    public func downloadProgress(progress: @escaping ((Double) -> Void)) -> DownloadTaskManager {
        downloadRequest?.downloadProgress(closure: { (pro) in
            self.saveProgress(pro.fractionCompleted)
            progress(pro.fractionCompleted)
        })
        return self
    }
    /// 响应
    public func response(completion: @escaping (Alamofire.Result<String>)->()) {
        downloadRequest?.responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                self.downloadStatus = .complete
                let str = response.destinationURL?.absoluteString
                if self.cancelCompletion != nil { self.cancelCompletion!() }
                completion(Alamofire.Result.success(str!))
            case .failure(let error):
                self.downloadStatus = .suspend
                self.saveResumeData(response.resumeData)
                if self.cancelCompletion != nil { self.cancelCompletion!() }
                completion(Alamofire.Result.failure(error))
            }
        })
    }
    /// 下载文件位置
    private func downloadDestination() -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = cachesURL.appendingPathComponent(response.suggestedFilename ?? "")
            self.saveFilePath(fileURL.absoluteString)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
    func saveProgress(_ progress: Double) {
        if let progressData = "\(progress)".data(using: .utf8) {
            cacheDictionary["progress"] = progressData
            CacheManager.default.setObject(cacheDictionary, forKey: key)
        }
    }
    
    func saveResumeData(_ data: Data?) {
        cacheDictionary["resumeData"] = data
        CacheManager.default.setObject(cacheDictionary, forKey: key)
    }
    
    func saveFilePath(_ filePath: String?) {
        if let filePathData = filePath?.data(using: .utf8) {
            cacheDictionary["filePath"] = filePathData
            CacheManager.default.setObject(cacheDictionary, forKey: key)
        }
    }
}



func getResumeData(_ url: String) -> Data? {
    let dic = getDictionary(url)
    if let data = dic["resumeData"] {
        return data
    }
    return nil
}

func getProgress(_ url: String) -> Double {
    let dic = getDictionary(url)
    if let progressData = dic["progress"],
        let progressString = String(data: progressData, encoding: .utf8),
        let progress = Double(progressString) {
        return progress
    }
    return 0
}

func getFilePath(_ url: String) -> String? {
    let dic = getDictionary(url)
    if let filePathData = dic["filePath"],
        let filePath = String(data: filePathData, encoding: .utf8) {
        return filePath
    }
    return nil
}

func getDictionary(_ url: String) -> Dictionary<String, Data> {
    if let dic = CacheManager.default.objectSync(ofType: Dictionary<String, Data>.self, forKey: url) {
        return dic
    }
    return [:]
}

