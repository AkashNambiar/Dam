//
//  MainMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

//http://dabuttonfactory.com/#t=Play&f=Vollkorn-Bold&ts=75&tc=9fc5e8&tshs=1&tshc=000&hp=20&vp=8&c=5&bgt=pyramid&bgc=252f38&ebgc=073763&it=png

//http://dabuttonfactory.com/#t=GAME+OVER&f=Vollkorn-Bold&ts=100&tc=eaea28&tshs=1&tshc=f00&hp=20&vp=8&c=5&bgt=pyramid&bgc=600&ebgc=c00&it=png


import SpriteKit

class MainMenu: SKScene {
    
    var playButton: MSButtonNode!
    var instructionsButton: MSButtonNode!
    
    override func didMove(to view: SKView) {
        
        playButton = childNode(withName: "//playButton") as! MSButtonNode
        instructionsButton = childNode(withName: "//instructionsButton") as! MSButtonNode
        
        playButton.selectedHandler = {
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
        
        instructionsButton.selectedHandler = {
            guard let skView = self.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = GameScene(fileNamed: "instructionsMenu") else {
                return
            }
            scene.scaleMode = .aspectFit
            
            skView.presentScene(scene)
        }
    }
}
