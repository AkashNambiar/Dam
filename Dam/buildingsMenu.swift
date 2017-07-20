//
//  buildingMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/19/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit
    
class buildingMenu: SKScene{
    
    var building1: MSButtonNode!
    var building2: MSButtonNode!
    
    override func didMove(to view: SKView) {
        building1 = childNode(withName: "//building1") as! MSButtonNode
        building2 = childNode(withName: "//building2") as! MSButtonNode
        
        building1.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "buildingScene2") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
        
        building2.selectedHandler = {
            
        }
    }
}
