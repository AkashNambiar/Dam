//
//  buildingMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/19/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//
//Mone Referseh

import SpriteKit

class buildingMenu: SKScene{
    
    var totalMoney: SKLabelNode!
    var shop: MSButtonNode!
    var backButton: MSButtonNode!
    var fowardButton: MSButtonNode!
    var backwardButton: MSButtonNode!
    
    static var numberWindows = 6
    static var numberNoCracks = 0
    static var oldManMoving = false
    static var buildingName = "newBuildingScene"
    
    var buildingPrice: [Int] = [0,2000]
    var buildingsUnlcoked: [Bool] = [true, false]
    
    var buildingNames = ["newBuildingScene", "newBuildingScene2"]
    var numWindows = [6, 7]
    var numNoCracks = [0, 1]
    
    var cancelButton: MSButtonNode!
    var confirmButton: MSButtonNode!
    var popUp = SKSpriteNode()
    var priceToBuy: SKLabelNode!
    var warningLabel: SKLabelNode!
    
    var poppingUp = false
    var canSwipe = true
    let swipeMove: CGFloat = 175
    
    override func didMove(to view: SKView) {
        
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedBuildings") as? [Bool] ?? []
        
        if firstTime.count == 0{
            userDefaults.set(buildingsUnlcoked, forKey: "unlockedBuildings")
            userDefaults.synchronize()
        }
        
        updateBuildings()
        
        cancelButton = childNode(withName: "cancelButton") as! MSButtonNode
        confirmButton = childNode(withName: "confirmButton") as! MSButtonNode
        fowardButton = childNode(withName: "fowardButton") as! MSButtonNode
        backwardButton = childNode(withName: "backwardButton") as! MSButtonNode
        priceToBuy = childNode(withName: "priceLabel") as! SKLabelNode
        warningLabel = childNode(withName: "warningLabel") as! SKLabelNode
        
        priceToBuy.isHidden = true
        confirmButton.isHidden = true
        cancelButton.isHidden = true
        warningLabel.isHidden = true
        
        shop = childNode(withName: "//shop") as! MSButtonNode
        totalMoney = childNode(withName: "totalMoney") as! SKLabelNode
        backButton = childNode(withName: "backButton") as! MSButtonNode
        
        shop.selectedHandler = { [weak self] in
            if !(self?.poppingUp)!{
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
        
        backButton.selectedHandler = { [weak self] in
            if !(self?.poppingUp)!{
                guard let skView = self?.view as SKView! else{
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
       
        /*
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        */
        
        totalMoney.text = "\(userDefaults.integer(forKey: "money"))"
        userDefaults.synchronize()
        
        backwardButton.isHidden = true
        
        fowardButton.selectedHandler = {
            self.backwardButton.isHidden = true
            self.fowardButton.isHidden = true
            
            let swipe: SKSpriteNode = self.childNode(withName: "swipeScreen") as! SKSpriteNode

            swipe.run(SKAction.sequence([SKAction.moveTo(x: 0, duration: 0.5), SKAction.run {
                self.backwardButton.isHidden = false
                self.fowardButton.isHidden = true
                }]))
        }
        
        backwardButton.selectedHandler = {
            self.backwardButton.isHidden = true
            self.fowardButton.isHidden = true
            
            let swipe: SKSpriteNode = self.childNode(withName: "swipeScreen") as! SKSpriteNode
            
            swipe.run(SKAction.sequence([SKAction.moveTo(x: 320, duration: 0.5), SKAction.run {
                self.backwardButton.isHidden = true
                self.fowardButton.isHidden = false
                }]))

        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if poppingUp {return}
        
        if canSwipe{
            
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
                let timeSwipe: TimeInterval = 0.1
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    
                    if 320 < swipe.position.x + swipeMove {
                        swipe.run(SKAction.moveBy(x: 320 - swipe.position.x, y: 0, duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: swipeMove, y: 0, duration: timeSwipe))
                    }
                    
                case UISwipeGestureRecognizerDirection.left:
                    
                    if swipeMove > swipe.position.x{
                        swipe.run(SKAction.moveBy(x: -swipe.position.x,y: 0,duration: timeSwipe))
                    }else{
                        swipe.run(SKAction.moveBy(x: -swipeMove, y: 0, duration: timeSwipe))
                    }
                    
                default:
                    break
                }
                
            }
        }
        
    }
    
    func updateBuildings(){
        let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
        
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedBuildings") as! [Bool]
        let count = userDefaults.array(forKey: "unlockedBuildings")?.count
        
        for i in 1 ... count!{
            let node = swipe.childNode(withName: "building\(i)")
            
            if firstTime[i-1] == false{
                node?.alpha = 0.6
            }else{
                node?.alpha = 1
            }
        }
        
        userDefaults.synchronize()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let nodeAtPoint = atPoint(location)
        
        let swipe: SKSpriteNode = childNode(withName: "swipeScreen") as! SKSpriteNode
        
        let userDefaults = UserDefaults.standard
        var firstTime: [Bool] = userDefaults.array(forKey: "unlockedBuildings") as! [Bool]
        let count = userDefaults.array(forKey: "unlockedBuildings")?.count
        
        for i in 1 ... count!{
            let node = swipe.childNode(withName: "building\(i)")
            
            if nodeAtPoint == node{
                if !(self.poppingUp){
                    if firstTime[i-1] == false {
                        let price = buildingPrice[i-1]
                        
                        poppingUp = true
                        canSwipe = false
                        
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
                            self.poppingUp = false
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
                            
                            self.buildingPrice[i-1] = 0
                            firstTime[i-1] = true
                            
                            self.totalMoney.text = "\(userDefaults.integer(forKey: "money"))"
                            userDefaults.set(firstTime, forKey: "unlockedBuildings")
                            userDefaults.synchronize()
                            
                            self.updateBuildings()
                            
                            self.poppingUp = false
                        }
                        
                    }else{
                        guard let skView = self.view as SKView! else{ return }
                        
                        guard let scene = GameScene(fileNamed: buildingNames[i-1]) else {
                            return
                        }
                        scene.scaleMode = .aspectFit
                        
                        skView.presentScene(scene)
                        
                        buildingMenu.numberWindows = numWindows[i-1]
                        buildingMenu.numberNoCracks = numNoCracks[i-1]
                        buildingMenu.buildingName = buildingNames[i-1]
                    }
                }
            }
        }
        
    }
}
