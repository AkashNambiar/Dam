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
    
    var areaRemoval: SKSpriteNode!
    var crackRemoval: SKSpriteNode!
    var windowCloser: SKSpriteNode!
    var text1: SKLabelNode!
    var text2: SKLabelNode!
    var text3: SKLabelNode!
    var coolTime: SKLabelNode!

    override func didMove(to view: SKView) {
        
        let currentTool = toolsMenu.getTool
        
        toolName = childNode(withName: "toolName") as! SKLabelNode
        backButton = childNode(withName: "//backButton") as! MSButtonNode
        
        areaRemoval = childNode(withName: "areaRemoval") as! SKSpriteNode
        crackRemoval = childNode(withName: "crackRemoval") as! SKSpriteNode
        windowCloser = childNode(withName: "windowCloser") as! SKSpriteNode
        text1 = childNode(withName: "text1") as! SKLabelNode
        text2 = childNode(withName: "text2") as! SKLabelNode
        text3 = childNode(withName: "text3") as! SKLabelNode
        coolTime = childNode(withName: "coolTime") as! SKLabelNode
        
        toolName.text = currentTool
        
        let texture = SKTexture(imageNamed: currentTool)
        let node = SKSpriteNode(texture: texture)
        
        addChild(node)
        node.size.height = 80
        node.size.width = 80
        node.position.x = 160
        node.position.y = 450
        node.zPosition = 1
        
        if currentTool == "cement"{
            areaRemoval.color = UIColor.green
            crackRemoval.color = UIColor.green
        }else if currentTool == "glue"{
            crackRemoval.color = UIColor.green
        }else if currentTool == "wood"{
            crackRemoval.color = UIColor.green
        }else if currentTool == "tape"{
            areaRemoval.color = UIColor.green
            crackRemoval.color = UIColor.green
        }else if currentTool == "lock"{
            windowCloser.color = UIColor.green
        }else if currentTool == "wall"{
            areaRemoval.color = UIColor.green
            crackRemoval.color = UIColor.green
        }else if currentTool == "portal"{
            text1.text = "Falling Items Removal"
            text1.fontSize = 26
            text1.position.x += 10
            text2.text = "Lasting Effect"
            text3.text = "Heal People"
            areaRemoval.color = UIColor.green
            crackRemoval.color = UIColor.green
        }else if currentTool == "health"{
            text1.text = "Falling Items Removal"
            text1.fontSize = 28
            text1.position.x += 10
            text2.text = "Lasting Effect"
            text3.text = "Heal People"
            windowCloser.color = UIColor.green
        }else if currentTool == "ice"{
            text1.text = "Falling Items Removal"
            text1.fontSize = 28
            text1.position.x += 10
            text2.text = "Lasting Effect"
            text3.text = "Heal People"
            crackRemoval.color = UIColor.green
        }else if currentTool == "police"{
            text1.text = "Stops Robbers"
            text2.text = "Lasting Effect"
            text3.text = "Heal People"
            areaRemoval.color = UIColor.green

            crackRemoval.color = UIColor.green
        }
        
        let index = toolsMenu.unlockedToolsName.index(of: currentTool)
        let time = toolsMenu.coolingTimes[index!]
        coolTime.text = "Cool Down Time: \(time)"
        
        backButton.selectedHandler = { [weak self] in
            guard let skView = self?.view as SKView! else{
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
