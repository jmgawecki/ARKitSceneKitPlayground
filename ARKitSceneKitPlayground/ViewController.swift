//
//  ViewController.swift
//  ARKitSceneKitPlayground
//
//  Created by Jakub Gawecki on 02/07/2021.
//

import UIKit
import SceneKit
import ARKit


class RandomColourWrapper {
   let colors: [UIColor] = [.cyan, .blue, .brown, .red, .green, .gray, .yellow, .magenta, .orange, .purple, .white]
   
   func randomColour() -> UIColor {
      return colors[Int.random(in: 0...10)] }
}

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
   
   @IBOutlet var sceneView: ARSCNView!
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
      
      sceneView.session.run(configurationWithPlaneDetection())
      sceneView.delegate = self
      
      sceneView.session.delegate = self
      UIApplication.shared.isIdleTimerDisabled = true
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      sceneView.session.pause()
   }
   
   
   private func configurationWithPlaneDetection() -> ARWorldTrackingConfiguration {
      let configuration             = ARWorldTrackingConfiguration()
      configuration.planeDetection  = [.vertical, .horizontal]
      return configuration
   }
   
   // MARK: - ARSCN
   
   
   func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
      guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
      
      let plane = Plane(anchor: planeAnchor, in: sceneView)
      
      node.addChildNode(plane)
   }
   
   
   func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      guard let planeAnchor   = anchor as? ARPlaneAnchor,
            let plane         = node.childNodes.first as? Plane
      else { return }
      
      if let planeGeometry = plane.meshNode.geometry as? ARSCNPlaneGeometry {
         planeGeometry.firstMaterial?.diffuse.contents = plane.randomColourWrapper.randomColour
         planeGeometry.update(from: planeAnchor.geometry)
      }
      
      if let extentPlane = plane.extentNode.geometry as? SCNPlane {
         extentPlane.firstMaterial?.diffuse.contents = plane.randomColourWrapper.randomColour
         extentPlane.width             = CGFloat(planeAnchor.extent.x)
         extentPlane.height            = CGFloat(planeAnchor.extent.z)
         plane.extentNode.simdPosition = planeAnchor.center
      }
   }
   
   
}
// MARK: - ARSessionDelegate


func session(_ session: ARSession, didFailWithError error: Error) {
   // Present an error message to the user
   
}

func sessionWasInterrupted(_ session: ARSession) {
   // Inform the user that the session has been interrupted, for example, by presenting an overlay
   
}

func sessionInterruptionEnded(_ session: ARSession) {
   // Reset tracking and/or remove existing anchors if consistent tracking is required
   
}

