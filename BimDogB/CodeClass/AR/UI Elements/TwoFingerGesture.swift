/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages two finger gesture interactions with the AR scene.
*/

import ARKit
import SceneKit

/// - Tag: TwoFingerGesture
class TwoFingerGesture: Gesture {
    
    // MARK: - Properties
    
    var firstTouch = UITouch()
    var secondTouch = UITouch()
    
    let translationThreshold: CGFloat = 40
    let translationThresholdHarder: CGFloat = 70
    var translationThresholdPassed = false
    var allowTranslation = false
    var dragOffset = CGPoint()
    var initialMidPoint = CGPoint(x: 0, y: 0)
    
    let rotationThreshold: Float = .pi / 15 // (12°)
    let rotationThresholdHarder: Float = .pi / 10 // (18°)
    var rotationThresholdPassed = false
    var allowRotation = false
    var initialFingerAngle: Float = 0
    var initialObjectAngle: Float = 0
    var firstTouchedObject: VirtualObject?
    
    let scaleThreshold: CGFloat = 50
    let scaleThresholdHarder: CGFloat = 90
    var scaleThresholdPassed = false
    var allowScaling = true
    var initialDistanceBetweenFingers: CGFloat = 0
    var baseDistanceBetweenFingers: CGFloat = 0
    var objectBaseScale: Float = 1.0
    
    // MARK: - Initialization
    
    override init(_ touches: Set<UITouch>, _ sceneView: ARSCNView, _ lastUsedObject: VirtualObject?, _ objectManager: VirtualObjectManager) {
        super.init(touches, sceneView, lastUsedObject, objectManager)
        let touches = Array(touches)
        firstTouch = touches[0]
        secondTouch = touches[1]
        
        let firstTouchPoint = firstTouch.location(in: sceneView)
        let secondTouchPoint = secondTouch.location(in: sceneView)
        initialMidPoint = firstTouchPoint.midpoint(secondTouchPoint)
        
        // Compute the two other corners of the rectangle defined by the two fingers
        let thirdCorner = CGPoint(x: firstTouchPoint.x, y: secondTouchPoint.y)
        let fourthCorner = CGPoint(x: secondTouchPoint.x, y: firstTouchPoint.y)
        
        // Compute all midpoints between the corners and center of the rectangle.
        let midPoints = [
            thirdCorner.midpoint(firstTouchPoint),
            thirdCorner.midpoint(secondTouchPoint),
            fourthCorner.midpoint(firstTouchPoint),
            fourthCorner.midpoint(secondTouchPoint),
            initialMidPoint.midpoint(firstTouchPoint),
            initialMidPoint.midpoint(secondTouchPoint),
            initialMidPoint.midpoint(thirdCorner),
            initialMidPoint.midpoint(fourthCorner)
        ]
        
        // Check if any of the two fingers or their midpoint is touching the object.
        // Based on that, translation, rotation and scale will be enabled or disabled.
        let allPoints = [firstTouchPoint, secondTouchPoint, thirdCorner, fourthCorner, initialMidPoint] + midPoints
        firstTouchedObject = allPoints.lazy.flatMap { point in
            return self.virtualObject(at: point)
        }.first
        if let virtualObject = firstTouchedObject {
            objectBaseScale = virtualObject.scale.x
            
            allowTranslation = true
            allowRotation = true
            
            initialDistanceBetweenFingers = (firstTouchPoint - secondTouchPoint).length()
            
            initialFingerAngle = atan2(Float(initialMidPoint.x), Float(initialMidPoint.y))
            initialObjectAngle = virtualObject.eulerAngles.y
        } else {
            allowTranslation = false
            allowRotation = false
        }
    }
    
    // MARK: - Gesture Handling
    
    override func updateGesture() {
        super.updateGesture()
        
        guard let virtualObject = firstTouchedObject else {
            return
        }
        
        // Two finger touch enables combined translation, rotation and scale.
        
        // First: Update the touches.
        let touches = Array(currentTouches)
        let newTouch1 = touches[0]
        let newTouch2 = touches[1]
        
        if newTouch1 == firstTouch {
            firstTouch = newTouch1
            secondTouch = newTouch2
        } else {
            firstTouch = newTouch2
            secondTouch = newTouch1
        }
        
        let loc1 = firstTouch.location(in: sceneView)
        let loc2 = secondTouch.location(in: sceneView)
        
        if allowTranslation {
            // 1. Translation using the midpoint between the two fingers.
//            updateTranslation(of: virtualObject, midpoint: loc1.midpoint(loc2))
        }
		
		let spanBetweenTouches = loc1 - loc2
        
        if allowRotation {
            // 2. Rotation based on the relative rotation of the fingers on a unit circle.
//            updateRotation(of: virtualObject, span: spanBetweenTouches)
//            circle.
            //改成两指旋转
            updateRotation(virtualObject : virtualObject ,eulerAngles_Y: Float(loc1.midpoint(loc2).x))
            
            
        }
        
	
		if allowScaling {
			// 3. Scaling based on the relative position of the fingers on a unit circles.
			updateScaling(of: virtualObject, span: spanBetweenTouches)
		}
		
	}
    
    func updateRotation(virtualObject: VirtualObject , eulerAngles_Y: Float) {
        
        let  a = CGFloat( eulerAngles_Y) - initialMidPoint.x
        
        print(a / 100, initialObjectAngle)
        
        virtualObject.eulerAngles.y = Float ( initialObjectAngle) + Float((a / 100));

        lastUsedObject = virtualObject;
    }
    
    func updateTranslation(of virtualObject: VirtualObject, midpoint: CGPoint) {
        if !translationThresholdPassed {
            
            let initialLocationToCurrentLocation = midpoint - initialMidPoint
            let distanceFromStartLocation = initialLocationToCurrentLocation.length()
            
            // Check if the translate gesture has crossed the threshold.
            // If the user is already rotating and or scaling we use a bigger threshold.
            
            var threshold = translationThreshold
            if rotationThresholdPassed || scaleThresholdPassed {
                threshold = translationThresholdHarder
            }
            
            if distanceFromStartLocation >= threshold {
                translationThresholdPassed = true
                let currentObjectLocation = CGPoint(sceneView.projectPoint(virtualObject.position))
                dragOffset = midpoint - currentObjectLocation
            }
        }
        
        if translationThresholdPassed {
            let offsetPos = midpoint - dragOffset
            objectManager.translate(virtualObject, in: sceneView, basedOn: offsetPos, instantly: false, infinitePlane: true)
            lastUsedObject = virtualObject
        }
    }
    
//    func updateRotation(of virtualObject: VirtualObject, span: CGPoint) {
//
//        let midpointToFirstTouch = span / 2
//        let currentAngle = atan2(Float(midpointToFirstTouch.x), Float(midpointToFirstTouch.y))
//
//        let currentAngleToInitialFingerAngle = initialFingerAngle - currentAngle
//
//        if !rotationThresholdPassed {
//            var threshold = rotationThreshold
//
//            if translationThresholdPassed || scaleThresholdPassed {
//                threshold = rotationThresholdHarder
//            }
//
//            if abs(currentAngleToInitialFingerAngle) > threshold {
//
//                rotationThresholdPassed = true
//
//                // Change the initial object angle to prevent a sudden jump after crossing the threshold.
//                if currentAngleToInitialFingerAngle > 0 {
//                    initialObjectAngle += threshold
//                } else {
//                    initialObjectAngle -= threshold
//                }
//            }
//        }
//
//        if rotationThresholdPassed {
//            // Note:
//            // For looking down on the object (99% of all use cases), we need to subtract the angle.
//            // To make rotation also work correctly when looking from below the object one would have to
//            // flip the sign of the angle depending on whether the object is above or below the camera...
//            virtualObject.eulerAngles.y = initialObjectAngle - currentAngleToInitialFingerAngle
//            lastUsedObject = virtualObject
//        }
//    }
    
    func updateScaling(of virtualObject: VirtualObject, span: CGPoint) {
        let distanceBetweenFingers = span.length()
        
        if !scaleThresholdPassed {
            
            let fingerSpread = abs(distanceBetweenFingers - initialDistanceBetweenFingers)
            
            var threshold = scaleThreshold
            
            if translationThresholdPassed || rotationThresholdPassed {
                threshold = scaleThresholdHarder
            }
            
            if fingerSpread > threshold {
                scaleThresholdPassed = true
                baseDistanceBetweenFingers = distanceBetweenFingers
            }
        }
        
        if scaleThresholdPassed {
            
            if baseDistanceBetweenFingers != 0 {
                
                let relativeScale = distanceBetweenFingers / baseDistanceBetweenFingers
                
                let newScale = objectBaseScale * Float(relativeScale)
                
                // Uncomment the block below to "snap" the 3D model to 100%.
                /*
                 if newScale >= 0.96 && newScale <= 1.04 {
                 newScale = 1.0 // Snap scale to 100% when getting close.
                 }*/
                
                
                
//                if newScale >= 0.05 && newScale <= 2.0 {
                
   
                    
                    
                    virtualObject.scale = SCNVector3Uniform(newScale)
                    //virtualObject.scale = SCNVector3Make(newScale, newScale, newScale)
                    
                    
                    let splitedArray : [String] = virtualObject.definition.Size.components(separatedBy: "*")
                    
                    let l : String = (splitedArray[0] as String)
                    
                    let w : String = (splitedArray[1] as String)
                    
                    let h : String = (splitedArray[2] as String)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentNodeSize"), object: String.init(format: "Size (mm): %.1f * %.1f * %.1f", arguments: [virtualObject.scale.x *
                        Float(l)!, virtualObject.scale.y * Float(w)!, virtualObject.scale.z * Float(h)!]));
                    
                    
                    if let nodeWhichReactsToScale = virtualObject.reactsToScale() {
                        
                        nodeWhichReactsToScale.reactToScale()
                        
                    }
                    
//                }
                
          
            }
        }
    }
    
    func finishGesture() {
        // Nothing to do here for two finger gestures.
    }
}

