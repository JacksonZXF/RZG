/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Main view controller for the AR experience.
 */

import ARKit
import SceneKit
import UIKit
import Toaster
import SnapKit
import RxCocoa

class ARScanningViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, HomeModelProtocol , UICollectionViewDelegateFlowLayout{
    var feedItems: NSArray = NSArray()
    var selectedLocation : LocationModel = LocationModel()
    var didSelctNode : VirtualObject? = nil;
    
    //节点操作控件
    

    @IBOutlet weak var nodeDelBtn: UIButton!
    
    @IBOutlet weak var nodeSizeLab: UILabel!
    
    @IBAction func deleSigleNode(_ sender: UIButton) {
        
        
//        print("del", self.didSelctNode!)
        
        for subNode in self.sceneView.scene.rootNode.childNodes {
            
            if subNode == self.didSelctNode {
                
                subNode.removeFromParentNode();
                
                self.didSelctNode = nil;
                
                self.hidControlBtnTool(show: true);
                
                break
            }
            
        }
        
    }
    
    
    @IBOutlet weak var nodeInfoBtn: UIButton!
    
    @IBAction func lookNodeInfo(_ sender: UIButton) {
        
        print("look", self.didSelctNode as Any)
        
        let pop = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemInfPopViewController")
        pop.modalPresentationStyle = .popover
        pop.popoverPresentationController?.delegate = self
        pop.popoverPresentationController?.sourceView = sender
        pop.popoverPresentationController?.sourceRect = sender.bounds;
        pop.preferredContentSize = CGSize.init(width: 334 , height: 109);
        self.present(pop, animated: true) {
            
        };
        
        
        
    }
    

    
    func hidControlBtnTool(show : Bool) {
        
        self.nodeSizeLab.isHidden = show;
        self.heightSlider.isHidden = show;
        self.nodeDelBtn.isHidden = show;
        self.nodeInfoBtn.isHidden = show;
        
    }
    
    public func showNodeControllView(nodeObj : VirtualObject) {
        
        self.didSelctNode = nodeObj;
        
        self.heightSlider.value = nodeObj.worldPosition.y * 20;

        print(self.heightSlider.value);
        
        self.hidControlBtnTool(show: false);
        
        //设置动画效果，动画时间长度 1 秒。
        UIView.animate(withDuration: 1, delay:0.01, options:[.curveEaseInOut],
                       animations: {
                        ()-> Void in
                        
        },
                       completion:{
                        (finished:Bool) -> Void in
                        
                        UIView.animate(withDuration: 1, animations:{
                            ()-> Void in
                            
                        })
                        
        })
        
 
        
    }
    
    var listType = "单品";
    
    //浏览模式切换
    @IBOutlet weak var lookTypeBtn: UIButton!
    
    @IBAction func changeLookType(_ sender: Any) {
        
        if self.lookType == 1 {
            
            self.lookType = 2;
            
            self.lookTypeBtn.setImage(UIImage.init(named: "切换浏览模式2"), for: UIControlState.normal);
            
        } else {
            
            self.lookType = 1;
            
            self.lookTypeBtn.setImage(UIImage.init(named: "切换浏览模式1"), for: UIControlState.normal);
        }
        
        
        
        self.rightMenuCollection.reloadData();
        
    }
    //查看单品
    @IBOutlet weak var itemKindBtn: UIButton!
    
    @IBAction func changeToLevel1(_ sender: Any) {
        
        self.level = 1;
        
        listType = "单品";

        lookType = 1;
        
        self.lookTypeBtn.isHidden = true;
        
        itemsDownloaded(items:  ["All","柜子","沙发", "茶几", "床", "桌子", "灯具", "窗帘", "架子", "其他"])
        
        self.rightMenuCollection.reloadData();

        self.rightMenuCollection.reloadData();
    }
    
    //查看套装
    @IBOutlet weak var mineBtn: UIButton!
    
    @IBAction func lookMine(_ sender: Any) {
        
        self.level = 1;
        
        listType = "组合";
        
        lookType = 1;
        
        self.lookTypeBtn.isHidden = true;
        

        
        self.rightMenuCollection.reloadData();
        
    }
    
    
    
    @IBOutlet weak var popView: UIButton!
    
    @IBAction func PopView(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true);
        
    }
    
    
    @IBOutlet weak var snapBtn: UIButton!
    
    @IBAction func takeSnapShot(_ sender: Any) {
        
        
        //建立的SystemSoundID对象
        var soundID:SystemSoundID = 0
        //获取声音地址
        let path = Bundle.main.path(forResource: "kaca", ofType: "mp3")
        //地址转换
        let baseURL = NSURL(fileURLWithPath: path!)
        //赋值
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        //播放声音
        AudioServicesPlaySystemSound(soundID)
        
            self.focusSquare?.isHidden = true
            
            self.focusSquare?.removeFromParentNode()
            
            self.rightMenuView.isHidden = true;

            //截屏
            let image = self.sceneView.snapshot()

            self.snapVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SnapViewController") as! SnapViewController
            
            self.snapVc.image = image;
        
            self.view.addSubview(self.snapVc.view);
            
    
        self.showAlertWithSelection("提示", message: "保存相片至相册", ok: {
            
            UIImageWriteToSavedPhotosAlbum(image,self,nil, nil)
            
            Toast.init(text: "场景已经保存到本地相册").show();
            
            self.snapVc.view.removeFromSuperview();
            
        }) {
            
            self.snapVc.view.removeFromSuperview();
        }
        
        
        
        
    }
    
    var snapVc : SnapViewController!;


    
    @IBOutlet weak var lightSlider: UISlider!
    
    @IBAction func changeLight(_ sender: Any) {
        
        self.sceneView.scene.lightingEnvironment.intensity = CGFloat(lightSlider.value);
        
    }
    
    //高度调节
    @IBOutlet weak var heightSlider: UISlider!
    
    
    @IBAction func changeHeight(_ sender: UISlider) {
        
        print(sender.value)
        
        self.didSelctNode?.worldPosition.y = sender.value / 20;
        
         print(self.didSelctNode?.worldPosition.y)
        
    }
    
    
    
    @IBOutlet weak var rightMenuView: UIView!
    
    @IBOutlet weak var showRightBtn: UIButton!
    
    var lookType : Int = 1;//浏览模式
    
    @IBAction func showRightMenu(_ sender: Any) {
        
        
        self.hidControlBtnTool(show: true);
        
        self.didSelctNode = nil;
        
        
        if self.sceneView.session.currentFrame?.camera.trackingState.presentationString != "平面检测正常" && self.hasPlane == false {  self.showAlert("温馨提示", message: "请确认平面位置后, 放置物品", ok: {
            
            
            
        })
            
            return
        }
        
        
            
            if self.rightMenuView.isHidden == true {
                
                
                self.rightMenuView.isHidden = false;
                
            } else {
                
                self.rightMenuView.isHidden = true;
                
            }
        
        
        
        
    }
    
    var level : Int = 1;

    
    var hasPlane : Bool =  false;
    
    
    
    @IBOutlet weak var rightMenuCollection: UICollectionView!
    // some properties used to control the app and store appropriate values
    
    

    
    
    func itemsDownloaded(items: NSArray) {
        
        feedItems = items
        
        self.rightMenuCollection.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of feed items
        return feedItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.level == 1 {
            
            if listType == "单品" {
                
                
                let cell : RightMenuListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightMenuListCollectionViewCell", for: indexPath) as! RightMenuListCollectionViewCell;
                
                cell.img.image = UIImage.init(named:  feedItems.object(at: indexPath.item) as! String)
                
                return cell;
                
            } else {
                
                let cell : RightCombinationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightCombinationCollectionViewCell", for: indexPath) as! RightCombinationCollectionViewCell;
                
                return cell;
                
                
            }
            
        
            
        } else {
            
            
                
                
                if lookType == 1 {
                    
             
                    
                    let cell : RightMenuList2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightMenuList2CollectionViewCell", for: indexPath) as! RightMenuList2CollectionViewCell;
                    
                    let definition : VirtualObjectDefinition  = feedItems[indexPath.item] as! VirtualObjectDefinition

                    cell.img.image = UIImage.init(named: definition.FaceImage) ;
                    
                    cell.model = definition;
                    
                    return cell;
                    
                } else {
                    
                    let cell : RightCombination2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RightCombination2CollectionViewCell", for: indexPath) as! RightCombination2CollectionViewCell;
                    
                     let definition : VirtualObjectDefinition  = feedItems[indexPath.item] as! VirtualObjectDefinition
                    cell.img.image = UIImage.init(named: definition.FaceImage);
                    
                    
                    
                    return cell;
                 
                    
                }
 
        
            

            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if listType == "单品" {
            
            if level == 1 {
                
                return CGSize.init(width: 80 * Const().BLWidth, height: 80 * Const().BLWidth)
                
            } else {
                
                if lookType == 1 {
                    
                  
                     return CGSize.init(width: 334 * Const().BLWidth, height: 109 * Const().BLWidth)
                } else {
                    
                       return CGSize.init(width: 107 * Const().BLWidth, height: 107 * Const().BLWidth)
                    
                }
                
               
            }
            
            
        }else {
            
            if level == 1 {
                
                return CGSize.init(width: 334 * Const().BLWidth, height: 225 * Const().BLWidth)
                
            } else {
                
                if lookType == 1 {
                    
               
                         return CGSize.init(width: 334 * Const().BLWidth, height: 109 * Const().BLWidth)
                } else {
                         return CGSize.init(width: 107 * Const().BLWidth, height: 107 * Const().BLWidth)
               
                }
            }
            
        }
        
        
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
   
        
        if self.level == 1 {
            
            if indexPath.item == 0 {
        
                itemsDownloaded(items: VirtualObjectManager.availableObjects as NSArray);
                
                self.rightMenuCollection.reloadData();
                
                self.level = 2;
                
                self.lookTypeBtn.isHidden = false;
                
            } else {
                
                itemsDownloaded(items: virtualObjectManager.fliderWithItemType(str: feedItems.object(at: indexPath.item) as! String, arr: VirtualObjectManager.availableObjects) as NSArray as NSArray)
                
                self.rightMenuCollection.reloadData();
                
                self.level = 2;
                
                self.lookTypeBtn.isHidden = false;
                
            }
         
            
            
        } else {
            

            
            
            guard let cameraTransform = session.currentFrame?.camera.transform else {
                return
            }
            
            
            
            self.rightMenuView.isHidden = true;
            
            let definition : VirtualObjectDefinition  = feedItems[indexPath.item] as! VirtualObjectDefinition;
            
            let object = VirtualObject(definition: definition)
            
            let position = focusSquare?.lastPosition ?? float3(0)
            
            virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform)
            
            if object.parent == nil {
                
                serialQueue.async {
                    
                    object.scale = SCNVector3Make(0.000001, 0.000001, 0.000001);
                    
                    
                    self.sceneView.scene.rootNode.addChildNode(object)
                    
              
                    let ac : SCNAction = SCNAction.scale(to: 1.0, duration: 3);
                    
                    object.runAction(ac);
                }
            }
            
        }
        
        
    }
    
    
    
    
    // MARK: - ARKit Config Properties
    
    var screenCenter: CGPoint?
    
    let session = ARSession()
    let standardConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    // MARK: - Virtual Object Manipulation Properties
    
    var dragOnInfinitePlanesEnabled = false
    var virtualObjectManager: VirtualObjectManager!
    
    var isLoadingObject: Bool = false {
        didSet {
            DispatchQueue.main.async {
                
                self.addObjectButton.isEnabled = !self.isLoadingObject
                self.restartExperienceButton.isEnabled = !self.isLoadingObject
            }
        }
    }
    
    // MARK: - Other Properties
    
    var textManager: TextManager!
    var restartExperienceButtonIsEnabled = true
    
    // MARK: - UI Elements
    
    var spinner: UIActivityIndicatorView?
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var restartExperienceButton: UIButton!
    
    //清空所有Node
    @IBAction func clearAllNode(_ sender: Any) {
        
        
        if self.sceneView.scene.rootNode.childNodes.count < 2 {
            Toast.init(text: "亲~~其实没什么可以清除的😓").show();
            
        } else {
            self.showAlertWithSelection("温馨提示", message: "该操作会清空当前场景中所有的虚拟物体并重新检测地面, 确定这样吗?", ok: {
                
                self.rightMenuView.isHidden = true;
                
                self.session.pause()
                
                for node in  self.sceneView.scene.rootNode.childNodes {
                    
                    node.removeFromParentNode()
                    
                }
                
                //Mark -- 重置平面检测
                self.resetTracking()
                
                self.setupScene()
                
                self.setupFocusSquare()
                
            }) {
                
                
                
            }
            
            
            
        }
        
        
        
        
    }
    
    // MARK: - Queues
    
    let serialQueue = DispatchQueue(label: "com.apple.arkitexample.serialSceneKitQueue")
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightMenuCollection.delegate = self;
        
        self.rightMenuCollection.dataSource = self;
        
        itemsDownloaded(items: ["All","柜子","沙发", "茶几", "床", "桌子", "灯具", "窗帘", "架子", "其他"])
        
        self.rightMenuCollection.reloadData()
        
        self.rightMenuView.layer.cornerRadius = 8;
        
        self.rightMenuView.layer.masksToBounds = false;
        
        
        
        self.itemKindBtn.imageView?.contentMode = .scaleAspectFit
        
        
        self.mineBtn.imageView?.contentMode = .scaleAspectFit
        
        Setting.registerDefaults()
        setupUIControls()
        setupScene()
        resetTracking()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ARScanningViewController.getDidChoosedNode(notification:)), name: NSNotification.Name(rawValue: "DidChooseNode"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ARScanningViewController.changeNodeSize(notification:)), name: NSNotification.Name(rawValue: "currentNodeSize"), object: nil)
        
        
        
        
        //旋转高度滑竿
        heightSlider.transform = CGAffineTransform.init(rotationAngle: -1.57079633);
        
        
        nodeSizeLab.layer.borderColor = UIColor.lightGray.cgColor;
        
        nodeSizeLab.layer.borderWidth = 1;

        
        

        
    }
    
    
    @objc func changeNodeSize(notification:NSNotification) {
        
        if notification.object != nil {
            
            
            self.nodeSizeLab.text = notification.object as? String
            
            self.hidControlBtnTool(show: false);
            
        } else {
            
            
            
            self.didSelctNode = nil;
            
        }
        
        
    }
    
    
    @objc func getDidChoosedNode(notification:NSNotification) {
        
        if notification.object != nil {
            
            
            
            self.showNodeControllView(nodeObj: notification.object as! VirtualObject);
            
            
        } else {
            
            
            self.hidControlBtnTool(show: true);
            
            self.didSelctNode = nil;
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
        
        if ARWorldTrackingConfiguration.isSupported {
            // Start the ARSession.
            resetTracking()
        } else {
            // This device does not support 6DOF world tracking.
            let sessionErrorMsg = "这个App需要AR硬件支持。您需要一个A9处理器或新的iOS设备上可用。" +
            "再见, 来不及握手."
            displayErrorMessage(title: "不受支持的平台", message: sessionErrorMsg, allowRestart: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause();
        
        
        self.didSelctNode = nil;
    }
    
    // MARK: - Setup
    
    func setupScene() {
        // Synchronize updates via the `serialQueue`.
        virtualObjectManager = VirtualObjectManager(updateQueue: serialQueue)
        virtualObjectManager.delegate = self as? VirtualObjectManagerDelegate
        
        // set up scene view
        sceneView.setup()
        
        sceneView.delegate = self
        
        sceneView.session = session
        // sceneView.showsStatistics = true
        
        
        sceneView.scene.enableEnvironmentMapWithIntensity(15, queue: serialQueue)
        
        self.sceneView.scene.lightingEnvironment.intensity = 1;
        
        setupFocusSquare()
        
        DispatchQueue.main.async {
            
            self.screenCenter = self.sceneView.bounds.mid
            
        }
    }
    
    func setupUIControls() {
        textManager = TextManager(viewController: self)
        
        // Set appearance of message output panel
        messagePanel.layer.cornerRadius = 3.0
        messagePanel.clipsToBounds = true
        messagePanel.isHidden = true
        messageLabel.text = ""
        
        // Set activity indicator
 
        //        self.view.addSubview(activityIndicator)
        //        activityIndicator.center = self.view.center
    }
    
    
    
    // MARK: - Gesture Recognizers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        virtualObjectManager.reactToTouchesBegan(touches, with: event, in: self.sceneView)
        
        self.rightMenuView.isHidden = true;
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        virtualObjectManager.reactToTouchesMoved(touches, with: event)
        
        self.rightMenuView.isHidden = true;
        
        
        for touch: AnyObject in touches {
            let t:UITouch = touch as! UITouch
            print(t.location(in: self.view))
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if virtualObjectManager.virtualObjects.isEmpty {
            
            return
        }
        
        self.rightMenuView.isHidden = true;
//        self.hidControlBtnTool(show: self.rightMenuView.isHidden);
        
        virtualObjectManager.reactToTouchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        virtualObjectManager.reactToTouchesCancelled(touches, with: event)
        
        self.rightMenuView.isHidden = true;
        
//        self.hidControlBtnTool(show: self.rightMenuView.isHidden);
    }
    
    // MARK: - Planes
    
    var planes = [ARPlaneAnchor: Plane]()
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        
        let plane = Plane(anchor)
        planes[anchor] = plane
        node.addChildNode(plane)
        self.hasPlane = true;
        textManager.cancelScheduledMessage(forType: .planeEstimation)
        textManager.showMessage("发现平面")
        if virtualObjectManager.virtualObjects.isEmpty {
            textManager.scheduleMessage("点击右下菜单键, 放置物品", inSeconds: 7.5, messageType: .contentPlacement)
        }
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func removePlane(anchor: ARPlaneAnchor) {
        if let plane = planes.removeValue(forKey: anchor) {
            plane.removeFromParentNode()
        }
    }
    
    internal func resetTracking() {
        
        session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
        
        textManager.scheduleMessage("请您尝试寻找更适合的地面",
                                    inSeconds: 7.5,
                                    messageType: .planeEstimation)
        
        
    }
    
    // MARK: - Focus Square
    
    var focusSquare: FocusSquare?
    
    func setupFocusSquare() {
        
        serialQueue.async {
            
            self.focusSquare?.isHidden = true
            self.focusSquare?.removeFromParentNode()
            self.focusSquare = FocusSquare()
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
            
        }
        
        textManager.scheduleMessage("请您试着左右缓慢移动摄像头", inSeconds: 5.0, messageType: .focusSquare)
        
        
    }
    
    func updateFocusSquare() {
        
        guard let screenCenter = screenCenter else { return }
        
        DispatchQueue.main.async {
            var objectVisible = false
            for object in self.virtualObjectManager.virtualObjects {
                if self.sceneView.isNode(object, insideFrustumOf: self.sceneView.pointOfView!) {
                    objectVisible = true
                    break
                }
            }
            
            if objectVisible {
                
                self.focusSquare?.hide()
                
            } else {
                
                self.focusSquare?.unhide()
                
            }
            
            let (worldPos, planeAnchor, _) = self.virtualObjectManager.worldPositionFromScreenPosition(screenCenter,
                                                                                                       in: self.sceneView,
                                                                                                       objectPos: self.focusSquare?.simdPosition)
            if let worldPos = worldPos {
                
                self.serialQueue.async {
                    
                    self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
                    
                    
                }
                self.textManager.cancelScheduledMessage(forType: .focusSquare)
            }
        }
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String, allowRestart: Bool = false) {
        // Blur the background.
        textManager.blurBackground()
        
        if allowRestart {
            // Present an alert informing about the error that has occurred.
            let restartAction = UIAlertAction(title: "Reset", style: .default) { _ in
                self.textManager.unblurBackground()
                self.restartExperience(self)
            }
            
            textManager.showAlert(title: title, message: message, actions: [restartAction])
        } else {
            
            let backAction = UIAlertAction(title: "知道了", style: .default) { _ in
                self.navigationController?.popViewController(animated: true);
                
            }
            textManager.showAlert(title: title, message: message, actions: [backAction])
        }
    }
}

// Alert
extension ARScanningViewController {
    
    public func showAlertWithTitle(_ title: String!, message: String, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
    public func showAlertWithSelection(_ title: String, message: String?, ok: @escaping () -> Void, cancel: @escaping () -> Void){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {
            (action: UIAlertAction) -> Void in
            ok()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            cancel()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(_ title: String, message: String, ok: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) {
            (action: UIAlertAction) -> Void in
            ok?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}



