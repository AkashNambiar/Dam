//
//  MainMenu.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//



import SpriteKit
import AVFoundation

var soundIsPlaying = false

class MainMenu: SKScene {
    
    static var musicPlayer: AVAudioPlayer!
    
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
                return
            }
        
            guard let scene = SKScene(fileNamed: "buildingsMenu") else {
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
    
        
        for i in 1 ... 6{
            let window = childNode(withName: "w\(i)")
            
            openWindowX.append((window?.position.x)!)
            openWindowY.append((window?.position.y)!)
        }
        
        /*if !soundIsPlaying{
            MainMenu.musicPlayer.run(SKAction.repeatForever(SKAction.playSoundFileNamed("SummerSunday", waitForCompletion: true)))
            soundIsPlaying = true
        }*/
        
        
        if !soundIsPlaying{
            let path = Bundle.main.path(forResource: "SummerSunday.wav", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                MainMenu.musicPlayer = sound
                sound.play()
                MainMenu.musicPlayer.numberOfLoops = -1
                soundIsPlaying = true
            } catch {
                // couldn't load file :(
            }
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
