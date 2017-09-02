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
            
            let crack = Crack()
            let crack2 = Crack()
            let c = SKSpriteNode()
            
            let addCrack = SKAction.run {
                self.addChild(crack)
                
                crack.zPosition = 1
                crack.name = "crack"
                crack.position.x = 160
                crack.position.y = 160
                
                crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
                
                self.addChild(crack2)
                
                crack2.zPosition = 1
                crack2.name = "crack"
                crack2.position.x = 170
                crack2.position.y = 140
                
                crack2.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
            }
            
            let addCement = SKAction.run {
                self.addChild(c)
                
                c.name = "cementArea"
                c.zPosition = 1
                c.color = UIColor.red
                c.alpha = 0.5
                c.size.height = 80
                c.size.width = 80
                c.position.x = 160
                c.position.y = 160
            }
            
            let remove = SKAction.run {
                crack.removeFromParent()
                crack2.removeFromParent()
                c.removeFromParent()
            }
            
            run( SKAction.repeatForever(SKAction.sequence([addCrack, SKAction.wait(forDuration: 0.5), addCement, SKAction.wait(forDuration: 0.5), remove, SKAction.wait(forDuration: 0.5)])))
            
        }else if currentTool == "glue"{
            let crack = Crack()
            
            let addCrack = SKAction.run {
                self.addChild(crack)
                
                crack.zPosition = 1
                crack.name = "crack"
                crack.position.x = 160
                crack.position.y = 160
                
                crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
            }
            
            let remove = SKAction.run {
                crack.removeFromParent()
            }
            
            run(SKAction.repeatForever(SKAction.sequence([addCrack, SKAction.wait(forDuration: 1), remove, SKAction.wait(forDuration: 0.5)])))
            
        }else if currentTool == "wood"{
            let crack = Crack()
            
            let addCrack = SKAction.run {
                self.addChild(crack)
                
                crack.zPosition = 1
                crack.name = "crack"
                crack.position.x = 160
                crack.position.y = 160
                
                crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
            }
            
            let remove = SKAction.run {
                crack.removeFromParent()
            }
            
            run(SKAction.repeatForever(SKAction.sequence([addCrack, SKAction.wait(forDuration: 1), remove, SKAction.wait(forDuration: 0.5)])))
        }else if currentTool == "tape"{
            second.texture = SKTexture(imageNamed: "areaRemoval")
            
            let crack = Crack()
            let crack2 = Crack()
            let c = SKSpriteNode()
            
            let addCrack = SKAction.run {
                self.addChild(crack)
                
                crack.zPosition = 1
                crack.name = "crack"
                crack.position.x = 160
                crack.position.y = 160
                
                crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
                
                self.addChild(crack2)
                
                crack2.zPosition = 1
                crack2.name = "crack"
                crack2.position.x = 200
                crack2.position.y = 165
                
                crack2.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
            }
            
            let addCement = SKAction.run {
                self.addChild(c)
                
                c.name = "cementArea"
                c.zPosition = 1
                c.color = UIColor.red
                c.alpha = 0.5
                c.size.height = 30
                c.size.width = 320
                c.position.x = 160
                c.position.y = 160
            }
            
            let remove = SKAction.run {
                crack.removeFromParent()
                crack2.removeFromParent()
                c.removeFromParent()
            }
            
            run(SKAction.repeatForever(SKAction.sequence([addCrack, SKAction.wait(forDuration: 0.5), addCement, SKAction.wait(forDuration: 0.5), remove, SKAction.wait(forDuration: 0.5)])))
            
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
            
            let texture = SKTexture(imageNamed: "entireBuilding")
            let w = SKSpriteNode(texture: texture)
            addChild(w)
            
            w.xScale = 0.5
            w.yScale = 0.5
            w.position.x = 160
            w.position.y = 200
            
        }else if currentTool == "portal"{
            first.texture = SKTexture(imageNamed: "stopBricks")
            second.texture = SKTexture(imageNamed: "5seconds")
            
            second.xScale = 1.2
            
            let portalHole = Portal()
            addChild(portalHole)
            
            portalHole.name = "portalHole"
            portalHole.color = UIColor.black
            portalHole.alpha = 0.8
            portalHole.size.height = 5
            portalHole.size.width = 90
            portalHole.position.x = 160
            portalHole.position.y = 120
            
            let texture = SKTexture(imageNamed: "singleBrick")
            let brick = SKSpriteNode(texture: texture)
            var e = false
            
            let drop = SKAction.run {
                self.addChild(brick)
                
                var rand = arc4random_uniform(2)
                
                if e{
                    rand = arc4random_uniform(4)
                    
                    brick.texture = SKTexture(imageNamed: "tool\(rand)")
                    
                    e = false
                }else{
                    brick.texture = SKTexture(imageNamed: "singleBrick")
                    
                    e = true
                }
                
                brick.name = "singleBrick"
                brick.position.x = 160
                brick.position.y = 220
                brick.zPosition = 2
                brick.xScale = 0.15
                brick.yScale = 0.15
                
                rand = arc4random_uniform(180)
                brick.zRotation = CGFloat(rand)
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.affectedByGravity = true
            }
            
            let remove = SKAction.run {
                brick.removeFromParent()
            }
            
            run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), drop, SKAction.wait(forDuration:0.35), remove, SKAction.wait(forDuration: 0.5)])))
            
        }else if currentTool == "health"{
            first.texture = SKTexture(imageNamed: "healsCustomers")
            second.isHidden = true
            
            let man = Man()
            addChild(man)
            
            man.position.x = 160
            man.position.y = 180
            
            texture = SKTexture(imageNamed: "faceWithNeck")
            let face = SKSpriteNode(texture: texture)
            man.addChild(face)
            face.zPosition = 1
            face.position.x = 2
            face.position.y = 94
            
            face.run( SKAction.repeatForever(SKAction.sequence([SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.9, duration: 1), SKAction.wait(forDuration: 0.1), SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 1), SKAction.wait(forDuration: 0.1)])))
            
        }else if currentTool == "ice"{
            first.texture = SKTexture(imageNamed: "tempStop")
            second.texture = SKTexture(imageNamed: "5seconds")
            
            first.yScale = 0.8
            second.yScale = 0.8
            
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
                return
            }
            
            guard let scene = SKScene(fileNamed: "toolsMenu") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
            
        }
    }
}
