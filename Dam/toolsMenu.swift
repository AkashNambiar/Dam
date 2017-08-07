//
//  toolsMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/25/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

//Right side only moves insde

import SpriteKit

var lastPosition: CGFloat = 0

class toolsMenu: SKScene {
    
    var backButton: MSButtonNode!
    var cancelButton: MSButtonNode!
    var confirmButton: MSButtonNode!
    var popUp = SKSpriteNode()
    var priceToBuy: SKLabelNode!
    var warningLabel: SKLabelNode!
    var totalMoney: SKLabelNode!
    
    static let unlockedToolsName: [String] = ["wood", "glue", "tape", "cement", "lock", "portal" , "ice", "health", "wall", "police"]
    static let coolingTimes: [TimeInterval] = [1.5,1.5,2,2,1,2,1.5,2,4,1]
    static var unlocked: [Bool] = [true, true, false, false, true, false, false, false, false, false]
    var toolPrice: [Int] = [0,0,500,1000,0,4000,2000, 5000, 10000,6300]
    
    var canSwipe = true
    var poppingUp = false
    let swipeMove: CGFloat = 140
    
    static var getTool = "tool"
    
    override func didMove(to view: SKView) {
        
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedTools") as? [Bool] ?? []
        
        if firstTime.count == 0{
            print("firstTime")
            userDefaults.set(toolsMenu.unlocked, forKey: "unlockedTools")
            userDefaults.synchronize()
        }
        
        backButton = childNode(withName: "//backButton") as! MSButtonNode
        cancelButton = childNode(withName: "cancelButton") as! MSButtonNode
        confirmButton = childNode(withName: "confirmButton") as! MSButtonNode
        priceToBuy = childNode(withName: "priceLabel") as! SKLabelNode
        warningLabel = childNode(withName: "warningLabel") as! SKLabelNode
        totalMoney = childNode(withName: "totalMoney") as! SKLabelNode
        
        priceToBuy.isHidden = true
        confirmButton.isHidden = true
        cancelButton.isHidden = true
        warningLabel.isHidden = true
        
        backButton.selectedHandler = { [weak self] in
            if !(self?.poppingUp)!{
                guard let skView = self?.view as SKView! else{
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
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        updateTools(opacity: 0.5, b: false)
        
        totalMoney.text = "\(userDefaults.integer(forKey: "money"))"
        userDefaults.synchronize()
        
        let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
        
        if lastPosition != 0{
            swipe.position.y = lastPosition
        }
        
    }
    
    func updateTools(opacity: CGFloat, b: Bool) {
        let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
        print(swipe)
        
        let userDefaults = UserDefaults.standard
        var unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        
        for i in 0 ... unlockedTools.count - 1{
            
            let name = toolsMenu.unlockedToolsName[i]
            let node = swipe.childNode(withName: "\(name)")
            let lock = node?.childNode(withName: "\(name)Lock")
           
            if unlockedTools[i] == b{
                let node = swipe.childNode(withName: "\(name)")
                node?.alpha = opacity
            }

            if unlockedTools[i]{
                lock?.isHidden = true
            }else{
                lock?.isHidden = false
            }
        }
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if poppingUp {return}
        
        if canSwipe{
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
                let timeSwipe: TimeInterval = 0.1
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.down:
                    if 210 + swipeMove > swipe.position.y{
                        swipe.run(SKAction.moveBy(x: 0, y: 210 - swipe.position.y, duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: 0, y: -swipeMove, duration: timeSwipe))
                    }
                    
                case UISwipeGestureRecognizerDirection.up:
                    if 360 - swipeMove < swipe.position.y{
                        swipe.run(SKAction.moveBy(x: 0, y: 360 - swipe.position.y, duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: 0, y: swipeMove, duration: timeSwipe))
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
     
     for touch in touches {
     let location = touch.location(in: self)
     let previousLocation = touch.previousLocation(in: self)
     
     let deltaY = previousLocation.y - location.y
     
     swipe.position.y += deltaY
     }
     }*/
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if poppingUp {return}
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        let nodeName = nodeAtPoint.name
        
        if (nodeName?.hasSuffix("Info"))!{
            if (nodeName?.hasPrefix("wood"))!{
                toolsMenu.getTool = "wood"
            }else if (nodeName?.hasPrefix("glue"))!{
                toolsMenu.getTool = "glue"
            }else if (nodeName?.hasPrefix("cement"))!{
                toolsMenu.getTool = "cement"
            }else if (nodeName?.hasPrefix("ice"))!{
                toolsMenu.getTool = "ice"
            }else if (nodeName?.hasPrefix("tape"))!{
                toolsMenu.getTool = "tape"
            }else if (nodeName?.hasPrefix("lock"))!{
                toolsMenu.getTool = "lock"
            }else if (nodeName?.hasPrefix("portal"))!{
                toolsMenu.getTool = "portal"
            }else if (nodeName?.hasPrefix("health"))!{
                toolsMenu.getTool = "health"
            }else if (nodeName?.hasPrefix("wall"))!{
                toolsMenu.getTool = "wall"
            }else if (nodeName?.hasPrefix("police"))!{
                toolsMenu.getTool = "police"
            }
            
            let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
            lastPosition = swipe.position.y
            
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = SKScene(fileNamed: "toolsInfo") else {
                return
            }
            
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
        
        if toolsMenu.unlockedToolsName.contains(nodeName!) {
            
            let index = toolsMenu.unlockedToolsName.index(of: nodeName!)
            
            let userDefaults = UserDefaults.standard
            var unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
            
            if unlockedTools[index!] == false{
                
                let price = toolPrice[index!]
                
                priceToBuy.isHidden = false
                cancelButton.isHidden = false
                confirmButton.isHidden = false
                
                priceToBuy.text = "Buy For \(price)"
                
                let texture = SKTexture(imageNamed: "popUp")
                popUp = SKSpriteNode(texture: texture)
                
                addChild(popUp)
                
                popUp.name = "popUp"
                popUp.size.width = 275
                popUp.size.height = 150
                popUp.position.x = 160
                popUp.position.y = 300
                popUp.zPosition = 9
                
                canSwipe = false
                poppingUp = true
                
                if price > userDefaults.integer(forKey: "money"){
                    warningLabel.isHidden = false
                    confirmButton.isHidden = true
                }
                
                cancelButton.selectedHandler = {
                    self.popUp.removeFromParent()
                    self.cancelButton.isHidden = true
                    self.confirmButton.isHidden = true
                    self.priceToBuy.isHidden = true
                    self.warningLabel.isHidden = true
                    self.canSwipe = true
                    self.poppingUp = false
                }
                
                confirmButton.selectedHandler = {
                    self.popUp.removeFromParent()
                    self.cancelButton.isHidden = true
                    self.confirmButton.isHidden = true
                    self.priceToBuy.isHidden = true
                    self.warningLabel.isHidden = true
                    self.canSwipe = true
                    self.poppingUp = false
                    
                    userDefaults.set(userDefaults.integer(forKey: "money") - price, forKey: "money")
                    userDefaults.synchronize()
                    
                    self.toolPrice[index!] = 0
                    unlockedTools[index!] = true
                    
                    userDefaults.set(unlockedTools, forKey: "unlockedTools")
                    
                    self.totalMoney.text = "\(userDefaults.integer(forKey: "money"))"
                    
                    userDefaults.synchronize()
                    
                    self.updateTools(opacity: 1, b: true)
                }
                
            }
        }
    }
}
