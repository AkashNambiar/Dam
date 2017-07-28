//
//  toolsInfo.swift
//  Dam
//
//  Created by Akash Nambiar on 7/26/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class toolsInfo: SKScene {
    
    var toolName: SKLabelNode!
    var backButton: MSButtonNode!

    override func didMove(to view: SKView) {
        
        toolName = childNode(withName: "toolName") as! SKLabelNode
        backButton = childNode(withName: "//backButton") as! MSButtonNode
        
        toolName.text = toolsMenu.getTool
        
        let texture = SKTexture(imageNamed: toolsMenu.getTool)
        let node = SKSpriteNode(texture: texture)
        
        addChild(node)
        node.size.height = 80
        node.size.width = 80
        node.position.x = 160
        node.position.y = 450
        node.zPosition = 1
        
        backButton.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "toolsMenu") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)

        }
    }
}
