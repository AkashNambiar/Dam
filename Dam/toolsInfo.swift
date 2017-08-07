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
    
    var first: SKSpriteNode!
    var second: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        let currentTool = toolsMenu.getTool
        
        toolName = childNode(withName: "toolName") as! SKLabelNode
        backButton = childNode(withName: "//backButton") as! MSButtonNode
        
        first = childNode(withName: "first") as! SKSpriteNode
        second = childNode(withName: "second") as! SKSpriteNode
        
        toolName.text = currentTool
        
        var texture = SKTexture(imageNamed: currentTool)
        let node = SKSpriteNode(texture: texture)
        
        addChild(node)
        node.size.height = 80
        node.size.width = 80
        node.position.x = 160
        node.position.y = 450
        node.zPosition = 1
        
        if currentTool == "cement"{
            second.texture = SKTexture(imageNamed: "areaRemoval")
        }else if currentTool == "glue"{
            
        }else if currentTool == "wood"{
            
        }else if currentTool == "tape"{
            second.texture = SKTexture(imageNamed: "areaRemoval")
        }else if currentTool == "lock"{
            first.texture = SKTexture(imageNamed: "closeWindow")
            second.isHidden = true
            
            texture = SKTexture(imageNamed: "w")
            let window = SKSpriteNode(texture: texture)
            addChild(window)
            
            window.size.height = 90
            window.size.width = 90
            window.position.x = 160
            window.position.y = 185
            
            let action = SKAction.run{
                let w = Window()
                self.addChild(w)
                
                w.position = window.position
                w.size = window.size
                w.zPosition = 1
                
                texture = SKTexture(imageNamed: "windowMan")
                let man = SKSpriteNode(texture: texture)
                self.addChild(man)
                
                man.zPosition = 2
                man.position.x = 160
                man.position.y = 180
                man.xScale = 0.4
                man.yScale = 0.4

                man.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run{
                    man.removeFromParent()
                    w.removeFromParent()
                    }])
                   )
            }
            
            run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2), action])))
            
        }else if currentTool == "wall"{
            second.texture = SKTexture(imageNamed: "areaRemoval")
        }else if currentTool == "portal"{
            first.texture = SKTexture(imageNamed: "stopBricks")
            second.texture = SKTexture(imageNamed: "5seconds")
        }else if currentTool == "health"{
            first.texture = SKTexture(imageNamed: "healsCustomers")
            second.isHidden = true
            
            let man = Man()
            addChild(man)
            
            man.position.x = 160
            man.position.y = 165
            
            texture = SKTexture(imageNamed: "faceWithNeck")
            let face = SKSpriteNode(texture: texture)
            man.addChild(face)
            face.zPosition = 1
            face.position.x = 2
            face.position.y = 84
            
            face.run( SKAction.repeatForever(SKAction.sequence([SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.9, duration: 1), SKAction.wait(forDuration: 0.1), SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 1), SKAction.wait(forDuration: 0.1)])))
            
        }else if currentTool == "ice"{
            first.texture = SKTexture(imageNamed: "tempStop")
            second.texture = SKTexture(imageNamed: "5seconds")
            
            let crack = Crack()
            addChild(crack)
            
            crack.position.x = 160
            crack.position.y = 170
            crack.zPosition = 1
            crack.xScale = 2
            crack.yScale = 2
            
            let s = SKAction.sequence([SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0), SKAction.wait(forDuration: 1), SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0), SKAction.wait(forDuration: 2)])
            
            crack.run(SKAction.repeatForever(SKAction.sequence([s])))
            
        }else if currentTool == "police"{
            
        }
        
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
