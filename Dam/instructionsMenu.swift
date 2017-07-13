//
//  instructionsMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/12/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class instructionsMenu: SKScene{
    
    var returnButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        returnButton = childNode(withName: "//returnButton") as! MSButtonNode
        
        returnButton.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "MainMenu") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
    }
}
