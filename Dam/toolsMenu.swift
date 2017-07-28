//
//  toolsMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/25/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class toolsMenu: SKScene {
    
    var backButton: MSButtonNode!
    var cancelButton: MSButtonNode!
    var confirmButton: MSButtonNode!
    let popUp = SKSpriteNode()
    var priceToBuy: SKLabelNode!
    var warningLabel: SKLabelNode!
    
    let unlockedToolsName: [String] = ["wood", "glue", "tape", "cement", "lock", "portal" , "ice", "health", "wall"]
    static var unlocked: [Bool] = [true, true, true, false, true, false, false, false, false]
    var emptyArray: [Bool] = []
    var toolPrice: [Int] = [0,0,0,1000,0,4000,2000, 5000, 10000]
    
    var canSwipe = true
    let swipeMove: CGFloat = 60
    
    static var getTool = "tool"
    
    override func didMove(to view: SKView) {
        
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedTools") as? [Bool] ?? emptyArray
        
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
        
        priceToBuy.isHidden = true
        confirmButton.isHidden = true
        cancelButton.isHidden = true
        warningLabel.isHidden = true
        
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
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        updateTools(opacity: 0.4, b: false)
        
    }
    
    func updateTools(opacity: CGFloat, b: Bool) {
        let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
        
        let userDefaults = UserDefaults.standard
        var unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        
        for i in 0 ... unlockedTools.count - 1{
            if unlockedTools[i] == b{
                let name = unlockedToolsName[i]
                
                var node = swipe.childNode(withName: "\(name)")
                node?.alpha = opacity
                
                node = swipe.childNode(withName: "\(name)Info")
                node?.alpha = opacity
                
                node = swipe.childNode(withName: "\(name)Pic")
                node?.alpha = opacity
                
                let label = swipe.childNode(withName: "\(name)Name")
                label?.alpha = opacity
            }
        }
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if canSwipe{
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
                let timeSwipe: TimeInterval = 0.1
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.down:
                    if 170 - swipeMove < swipe.position.y{
                        swipe.run(SKAction.moveBy(x: 0, y: 170 - swipe.position.y, duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: 0, y: -swipeMove, duration: timeSwipe))
                    }
                    
                case UISwipeGestureRecognizerDirection.up:
                    if 400 - swipeMove < swipe.position.y{
                        swipe.run(SKAction.moveBy(x: 0, y: 400 - swipe.position.y, duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: 0, y: swipeMove, duration: timeSwipe))
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            }
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
        
        if unlockedToolsName.contains(nodeName!) {
            
            let index = unlockedToolsName.index(of: nodeName!)
            
            let userDefaults = UserDefaults.standard
            var unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
            
            if unlockedTools[index!] == false{
                
                let price = toolPrice[index!]
                
                priceToBuy.isHidden = false
                cancelButton.isHidden = false
                confirmButton.isHidden = false
                
                priceToBuy.text = "Buy For \(price)"
                
                addChild(popUp)
                
                popUp.name = "popUp"
                popUp.size.width = 275
                popUp.size.height = 150
                popUp.position.x = 160
                popUp.position.y = 300
                popUp.zPosition = 9
                popUp.color = UIColor.green
                
                canSwipe = false
                
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
                }
                
                confirmButton.selectedHandler = {
                    self.popUp.removeFromParent()
                    self.cancelButton.isHidden = true
                    self.confirmButton.isHidden = true
                    self.priceToBuy.isHidden = true
                    self.warningLabel.isHidden = true
                    self.canSwipe = true
                    
                    userDefaults.set(userDefaults.integer(forKey: "money") - price, forKey: "money")
                    userDefaults.synchronize()
                    
                    self.toolPrice[index!] = 0
                    unlockedTools[index!] = true
                    
                    userDefaults.set(unlockedTools, forKey: "unlockedTools")
                    userDefaults.synchronize()
                    
                    self.updateTools(opacity: 1, b: true)
                }
                
            }
        }
    }
}
