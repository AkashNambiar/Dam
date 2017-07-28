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
    var building3: MSButtonNode!
    var totalMoney: SKLabelNode!
    var shop: MSButtonNode!
    var menuButton: MSButtonNode!
//    static var money: Int = 0
    static var numberWindows = 6
    static var oldManMoving = false
    
    override func didMove(to view: SKView) {
        
        building1 = childNode(withName: "//building1") as! MSButtonNode
        building2 = childNode(withName: "//building2") as! MSButtonNode
        building3 = childNode(withName: "//building3") as! MSButtonNode
        shop = childNode(withName: "//shop") as! MSButtonNode
        menuButton = childNode(withName: "//menuButton") as! MSButtonNode
        totalMoney = childNode(withName: "totalMoney") as! SKLabelNode
        
        building1.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "buildingScene") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
            
            buildingMenu.numberWindows = 6
        }
        
        building2.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "buildingScene2") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)

            buildingMenu.numberWindows = 6
        }
        
        building3.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "buildingScene3") else {
                return
            }
            buildingMenu.numberWindows = 4
            buildingMenu.oldManMoving = true
            
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
            
            print(buildingMenu.numberWindows)
        }

        
        shop.selectedHandler = {
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
        
        menuButton.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "lifetimeScene") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
        
        let userDefaults = UserDefaults.standard
        totalMoney.text = "TOTAL MONEY: \(userDefaults.integer(forKey: "money"))"
        userDefaults.synchronize()
    }
}
