/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UI Actions for the main view controller.
*/

import UIKit
import SceneKit

extension ARScanningViewController: UIPopoverPresentationControllerDelegate, ModelSelectionDelegate {

    enum SegueIdentifier: String {
        case showSettings
        case showObjects
    }

    // MARK: - Interface Actions

    @IBAction func chooseObject(_ button: UIButton) {
        // Abort if we are about to load another object to avoid concurrent modifications of the scene.
        if isLoadingObject { return }

        textManager.cancelScheduledMessage(forType: .contentPlacement)
        
        performSegue(withIdentifier: SegueIdentifier.showObjects.rawValue, sender: button)
    }

    /// - Tag: restartExperience
    @IBAction func restartExperience(_ sender: Any) {
        guard restartExperienceButtonIsEnabled, !isLoadingObject else { return }

        DispatchQueue.main.async {
            self.restartExperienceButtonIsEnabled = false

            self.textManager.cancelAllScheduledMessages()
            self.textManager.dismissPresentedAlert()
            self.textManager.showMessage("开启新的AR扫描")

            self.virtualObjectManager.removeAllVirtualObjects()
         
            self.focusSquare?.isHidden = true

            self.resetTracking()

            // Show the focus square after a short delay to ensure all plane anchors have been deleted.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.setupFocusSquare()
            })

            // Disable Restart button for a while in order to give the session enough time to restart.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.restartExperienceButtonIsEnabled = true
            })
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // All popover segues should be popovers even on iPhone.
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceRect = button.bounds
        }

     

        guard let identifier = segue.identifier, let segueIdentifer = SegueIdentifier(rawValue: identifier) else { return }
        if segueIdentifer == .showObjects, let objectsViewController = segue.destination as? VirtualObjectSelectionViewController {
//            objectsViewController.delegate = self
        }
    }

    func didSelectModel(model: Model) {
        print("MODEL SELECTED: \(model.uploadId!)")

        guard let cameraTransform = session.currentFrame?.camera.transform else { return }

		removeSCNAudioPlayers()
		
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
		
		let objectPath = path + "/" + model.uploadId! + "/model.scnassets/model.dae"
		let objectUrl = URL(fileURLWithPath: objectPath)
		let object = VirtualObject(url: objectUrl)
		let position = focusSquare?.lastPosition ?? float3(0)
		
		// Play Audio
		let audioPath =  path + "/" + model.uploadId! + "/audio.mp3"
		let audioUrl = model.audioUrl != nil ? URL(fileURLWithPath: audioPath) : nil
		object.audioURL = audioUrl
		
		virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform)
		if object.parent == nil {
			serialQueue.async {
				self.sceneView.scene.rootNode.addChildNode(object)
			}
		}
    }
	
	func removeSCNAudioPlayers() {
		for node in self.sceneView.scene.rootNode.childNodes {
			node.removeAllAudioPlayers()
		}
	}
}
