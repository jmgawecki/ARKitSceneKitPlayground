//
//  Plane.swift
//  ARKitSceneKitPlayground
//
//  Created by Jakub Gawecki on 02/07/2021.
//

import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {
   
   let meshNode: SCNNode
   let extentNode: SCNNode
   var classificationNode: SCNNode?
   let randomColourWrapper = RandomColourWrapper()
   
   init(anchor: ARPlaneAnchor, in sceneView: ARSCNView) {
      // Mesh node creation
      guard let meshGeometry     = ARSCNPlaneGeometry(device: sceneView.device!)
      else { fatalError() }
      
      meshGeometry.update(from: anchor.geometry)
      meshGeometry.firstMaterial?.diffuse.contents = randomColourWrapper.randomColour().withAlphaComponent(0.7)
      
      meshNode                   = SCNNode(geometry: meshGeometry)
      
      
      // Extent node creation
      let extentPlane            = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
      extentNode                 = SCNNode(geometry: extentPlane)
      extentNode.simdPosition    = anchor.center
      extentNode.eulerAngles.x   = -.pi / 2
      
      super.init()
      drawBorder(for: extentPlane)
      
      addChildNode(meshNode)
      addChildNode(extentNode)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   
   private func drawBorder(for plane: SCNPlane) {
      plane.firstMaterial?.diffuse.contents = randomColourWrapper.randomColour
      
      // SceneKit shader modifier, Metal based
      guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "art.scnassets")
      else { fatalError() }
      
      do {
         let shader = try String(contentsOfFile: path, encoding: .utf8)
         plane.firstMaterial?.shaderModifiers = [.surface: shader]
      } catch {
         fatalError()
      }
   }
}
