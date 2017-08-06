//
//  MainMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

//http://dabuttonfactory.com/#t=Play&f=Vollkorn-Bold&ts=75&tc=9fc5e8&tshs=1&tshc=000&hp=20&vp=8&c=5&bgt=pyramid&bgc=252f38&ebgc=073763&it=png

//http://dabuttonfactory.com/#t=GAME+OVER&f=Vollkorn-Bold&ts=100&tc=eaea28&tshs=1&tshc=f00&hp=20&vp=8&c=5&bgt=pyramid&bgc=600&ebgc=c00&it=png

//MEMORY LEAK TO BUILDING MENU


import SpriteKit

var soundIsPlaying = false

class MainMenu: SKScene {
    
    var playButton: MSButtonNode!
    
    var openWindowX: [CGFloat] = []
    var openWindowY: [CGFloat] = []
    var previousWindowOpened = 0
    var windows: [Window] = []
    var windowsPosition: [Int] = []
    
    override func didMove(to view: SKView) {
        
        playButton = childNode(withName: "//playButton") as! MSButtonNode
        
        playButton.selectedHandler = { [weak self] in
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
    
        let man = Man()
        
        addChild(man)
        
        man.position.x = 30
        man.position.y = 35
        man.zPosition = 3
        
        let texture = SKTexture(imageNamed: "faceWithNeck")
        let face = SKSpriteNode(texture: texture)
        man.addChild(face)
        face.name = "face"
        face.position.x = 2
        face.position.y = 84
        
        man.xScale = 0.25
        man.yScale = 0.3
        
        man.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveTo(x: 290, duration: 10), SKAction.moveTo(x: 30, duration: 10)])))
    
        
        for i in 1 ... buildingMenu.numberWindows{
            let window = childNode(withName: "w\(i)")
            
            openWindowX.append((window?.position.x)!)
            openWindowY.append((window?.position.y)!)
        }
        
        if !soundIsPlaying{
            self.run(SKAction.playSoundFileNamed("SummerSunday", waitForCompletion: false))
            soundIsPlaying = true
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.openWindow()}, SKAction.wait(forDuration: 3)])))
    }
    
    
    
    func openWindow() {
        var num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows - buildingMenu.numberNoCracks)))
        
        while windowsPosition.contains(num) || num == previousWindowOpened{
            num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows - buildingMenu.numberNoCracks)))
        }
        
        let window = Window()
        addChild(window)
        
        let texture = SKTexture(imageNamed: "windowMan")
        let man = SKSpriteNode(texture: texture)
        addChild(man)
        
        window.zPosition = 2
        window.size.width = 50
        window.size.height = 50
        
        man.zPosition = 3
        man.xScale = 0.2
        man.yScale = 0.2
        
        window.position.x = openWindowX[num]
        window.position.y = openWindowY[num]
        man.position.x = openWindowX[num]
        man.position.y = openWindowY[num] - 5
        
        man.run((SKAction.sequence([SKAction.wait(forDuration: 3),
                                                          SKAction.run {
                                                            man.removeFromParent()
                                                            window.removeFromParent()
                                                            
                                                            let index = self.windows.index(of: window)
                                                            self.windows.remove(at: index!)
                                                            self.windowsPosition.remove(at: index!)
                                                            
                                                            
            }])))
        
        windows.append(window)
        windowsPosition.append(num)
        previousWindowOpened = num
    }

}
