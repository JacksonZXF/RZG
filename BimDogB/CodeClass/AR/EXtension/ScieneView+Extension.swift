import ARKit
import Foundation
import SceneKit

extension ARSCNView {
	func setUp(viewController: ARScanningViewController, session: ARSession) {
        //代理指向
		delegate = viewController
		self.session = session
        //抗锯齿模式(飘柔你懂得)
		antialiasingMode = .multisampling4X

        //自动刷新光源
		automaticallyUpdatesLighting = true
            
        autoenablesDefaultLighting = true
    
//       预设 FPS值
		preferredFramesPerSecond = 60
        
        //内容比例
		contentScaleFactor = 1
        
        //环境光 亮度
		
        
        //设置camra
		if let camera = pointOfView?.camera {
			camera.wantsHDR = true
			camera.wantsExposureAdaptation = true
			camera.exposureOffset = -1
			camera.minimumExposure = -1
		}
	}
//获取环境光资源
	func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
		if scene.lightingEnvironment.contents == nil {
			if let environmentMap = UIImage(named: "Models.scnassets/22.hdr") {
				scene.lightingEnvironment.contents = environmentMap
			}
            
		}
        //亮度
		
	}
}
