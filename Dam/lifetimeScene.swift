//
//  lifetimeScene.swift
//  Dam
//
//  Created by Akash Nambiar on 7/27/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class lifetimeScene: SKScene {
    
    var backButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        backButton = childNode(withName: "backButton") as! MSButtonNode
        
        backButton.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "buildingsMenu") else {
                return
            }
            
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
    }
}
