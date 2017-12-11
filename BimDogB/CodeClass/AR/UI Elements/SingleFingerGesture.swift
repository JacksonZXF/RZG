/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages single finger gesture interactions with the AR scene.
*/

import ARKit
import SceneKit

class SingleFingerGesture: Gesture {
    
    // MARK: - Properties
    
    var initialTouchLocation = CGPoint()
    var latestTouchLocation = CGPoint()
    
    var firstTouchedObject: VirtualObject?

    let translationThreshold: CGFloat = 30
    var translationThresholdPassed = false
    var hasMovedObject = false
    
    var dragOffset = CGPoint()
    
    // MARK: - Initialization
    
    override init(_ touches: Set<UITouch>, _ sceneView: ARSCNView, _ lastUsedObject: VirtualObject?, _ objectManager: VirtualObjectManager) {
        
        super.init(touches, sceneView, lastUsedObject, objectManager)
        
        let touch = currentTouches.first!
        
        initialTouchLocation = touch.location(in: sceneView)
        
        latestTouchLocation = initialTouchLocation
        
        firstTouchedObject = virtualObject(at: initialTouchLocation)
        
        guard let virtualObject = firstTouchedObject else {
            
            //当选中目标节点的时候, 窗口弹出单个物品操作控件
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidChooseNode"), object: nil)
            
            return
        }
        
        //当选中目标节点的时候, 窗口弹出单个物品操作控件
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidChooseNode"), object: virtualObject)
        
        
        let splitedArray : [String] = virtualObject.definition.Size.components(separatedBy: "*")
        
        let l : String = (splitedArray[0] as String)
    
        let w : String = (splitedArray[1] as String)
        
        let h : String = (splitedArray[2] as String)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentNodeSize"), object: String.init(format: "规格 (cm): %.1f * %.1f * %.1f", arguments: [virtualObject.scale.x *
            Float(l)!, virtualObject.scale.y * Float(w)!, virtualObject.scale.z * Float(h)!]));
        
    }
    
    // MARK: - Gesture Handling
    
    override func updateGesture() {
        
        super.updateGesture()
        
        guard let virtualObject = firstTouchedObject else {
            
            return
        }
        

        latestTouchLocation = currentTouches.first!.location(in: sceneView)
        
        if !translationThresholdPassed {
            
            let initialLocationToCurrentLocation = latestTouchLocation - initialTouchLocation
            let distanceFromStartLocation = initialLocationToCurrentLocation.length()
            
            if distanceFromStartLocation >= translationThreshold {
                translationThresholdPassed = true
                
                let currentObjectLocation = CGPoint(sceneView.projectPoint(virtualObject.position))
                dragOffset = latestTouchLocation - currentObjectLocation
                
            }
        
        } else {
            
    
        }
        
        // A single finger drag will occur if the drag started on the object and the threshold has been passed.
        if translationThresholdPassed {
            
            let offsetPos = latestTouchLocation - dragOffset
            objectManager.translate(virtualObject, in: sceneView, basedOn: offsetPos, instantly: false, infinitePlane: true)
            hasMovedObject = true
            lastUsedObject = virtualObject
        }
    }
    
    func finishGesture() {
        // Single finger touch allows teleporting the object or interacting with it.
        
        // Do not do anything if this gesture is being finished because
        // another finger has started touching the screen.
        if currentTouches.count > 1 {
            return
        }
        
        // Do not do anything either if the touch has dragged the object around.
        if hasMovedObject {
            return
        }
        
        if lastUsedObject != nil {
            // If this gesture hasn't moved the object then perform a hit test against
            // the geometry to check if the user has tapped the object itself.
            // - Note: If the object covers a significant
            // percentage of the screen then we should interpret the tap as repositioning
            // the object.
            let isObjectHit = virtualObject(at: latestTouchLocation) != nil
            
            if !isObjectHit {
                // Teleport the object to whereever the user touched the screen - as long as the
                // drag threshold has not been reached.
                if !translationThresholdPassed {
//                    objectManager.translate(lastUsedObject!, in: sceneView, basedOn: latestTouchLocation, instantly: true, infinitePlane: false)
                }
            }
        }
    }
    
}
