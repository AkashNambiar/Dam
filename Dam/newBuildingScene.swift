//
//  GameScene.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//
//https://opengameart.org/content/64x-textures-an-overlays
//

import SpriteKit
import Foundation
import Fabric
import Crashlytics
import AVFoundation

class newBuildingScene: SKScene, SKPhysicsContactDelegate {
    
    enum tools {
        case glue, cement, tape, wood, lock, portal, wall, ice, health, police
    }
    
    enum playingState{
        case playing, notPlaying, tutorial
    }
    
    var currentTool: SKLabelNode!
    var b1: SKSpriteNode!
    var b2: SKSpriteNode!
    var retryButton: MSButtonNode!
    var homeButton: MSButtonNode!
    var goHome: MSButtonNode!
    var pauseButton: MSButtonNode!
    var playNow: MSButtonNode!
    
    var currentState: playingState = .playing
    
    var toolList: [tools] = []
    var toolPics: [SKSpriteNode] = []
    var previousTool: Int = 100
    var specialTool: tools!
    
    var openWindowX: [CGFloat] = []
    var openWindowY: [CGFloat] = []
    var manPositionX: [CGFloat] = [30, 70, 110, 210, 250, 290]
    var manPositionY: CGFloat = 35
    var leftMan: CGPoint = CGPoint(x: 210, y: 35)
    var rightMan: CGPoint = CGPoint(x: 110, y: 35)
    
    var frequency = 120
    var peopleLeft = 0
    var offTheWall: CGFloat = 2.5
    var freezeTime: TimeInterval = 5
    
    var nodeAboveTouch: CGFloat = 0
    var halfCementSize: CGFloat = 0
    var halfTapeSize: CGFloat = 0
    var halfPortalHeight: CGFloat = 0
    var halfPortalWidth: CGFloat = 0
    var gameTop: CGFloat = 510
    var gameBottom: CGFloat = 150
    var gameRight: CGFloat = 320
    var gameLeft: CGFloat = 0
    
    let newWallArea: SKSpriteNode = SKSpriteNode()
    let cementArea: SKSpriteNode = SKSpriteNode()
    let tapeArea: SKSpriteNode = SKSpriteNode()
    let portalHole: Portal = Portal()
    var portalIndex = 0
    var portals: [Portal] = []
    var newWall = false
    var cement = false
    var tape = false
    var portal = false
    
    var scoreChanged = true
    var manMovingInside = false
    
    var tutorial1 = false
    var tutorial2 = false
    var tutorial3 = false
    var tutorial4 = false
    var tutorial5 = true
    var tutorial6 = false
    var tutorial7 = false
    
    var t1 = false
    var t2 = false
    var t3 = false
    var t4 = false
    var tt4 = false
    var ttt4 = false
    var t5 = false
    var t6 = true
    var t7 = false
    
    var tapCrack = SKSpriteNode()
    var arrow1 = SKSpriteNode()
    var arrow2 = SKSpriteNode()
    var tapSwitch = SKSpriteNode()
    var fallingBrick = SKSpriteNode()
    var remove5 = SKSpriteNode()
    var however = SKSpriteNode()
    var hit5 = SKSpriteNode()
    var leave = SKSpriteNode()
    var lockLabel = SKSpriteNode()
    
    var timesHitToLeave: CGFloat = 3
    var numCracksToMove = 5
    
    var firstCrackStart = NSDate()
    var crackStart = NSDate()
    var crackInterval: TimeInterval = 4
    var oldManMoveStart = NSDate()
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    var previousNode: SKSpriteNode = SKSpriteNode()
    var prevoiusWindowOpened: Int = 0
    
    var cracks: [Crack] = []
    
    let coolDownLabel: SKLabelNode = SKLabelNode(fontNamed: "Georgia")
    let warningLabel = SKLabelNode(fontNamed: "Georgia")
    let tutorialLabel = SKLabelNode(fontNamed: "Georgia")
    let tutorialLabel2 = SKLabelNode(fontNamed: "Georgia")
    var coolingDown = false
    var ifPressedTwice = false
    var warningLabelShowing = false
    
    var windowContains = false
    var windows: [Window] = []
    var windowsPosition: [Int] = []
    
    var emptyArray: [Bool] = []
    var colors: [UIColor] = [UIColor.blue, UIColor.green, UIColor.red, UIColor.magenta, UIColor.orange, UIColor.yellow]
    
    var moneyCollected = 0
    var Score: Int = 0
    
    var canPressButton = true
    
    var music: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        let path = Bundle.main.path(forResource: "titleScreen.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            music = sound
            music.numberOfLoops = -1
            sound.play()
        } catch {
            // couldn't load file :(
        }
        
        MainMenu.musicPlayer.stop()
        
        currentTool = childNode(withName: "currentTool") as! SKLabelNode
        b1 = childNode(withName: "b1") as! SKSpriteNode
        b2 = childNode(withName: "b2") as! SKSpriteNode
        retryButton = childNode(withName: "//retryButton") as! MSButtonNode
        homeButton = childNode(withName: "//homeButton") as! MSButtonNode
        goHome = childNode(withName: "goHome") as! MSButtonNode
        pauseButton = childNode(withName: "pauseButton") as! MSButtonNode
        playNow = childNode(withName: "playNow") as! MSButtonNode
        
        retryButton.isHidden = true
        homeButton.isHidden = true
        playNow.isHidden = true
        
        physicsWorld.contactDelegate = self
        
        beginFunc()
        
        pauseButton.selectedHandler = { [weak self] in
            
            self?.playNow.isHidden = false
            
            self?.goHome.isHidden = true
            self?.pauseButton.isHidden = true
            
            var background = SKSpriteNode()
            let texture = SKTexture(imageNamed: "popUp")
            background = SKSpriteNode(texture: texture)
            
            self?.addChild(background)
            
            background.name = "d"
            background.size.height = 200
            background.size.width = 305
            background.position.x = 160
            background.position.y = 335
            background.zPosition = 5
            
            let paused = self?.textureToNode(name: "paused")
            self?.addChild(paused!)
            paused?.name = "d"
            paused?.position.x = 160
            paused?.position.y = 370
            paused?.zPosition = 6
            
            self?.playNow.selectedHandler = { [weak self] in
                background.removeFromParent()
                paused?.removeFromParent()
                self?.playNow.isHidden = true
                
                self?.scene?.view?.isPaused = false
                self?.goHome.isHidden = false
                self?.pauseButton.isHidden = false
            }
            
            let wait = SKAction.wait(forDuration: 0.1)
            let code = SKAction.run {
                self?.scene?.view?.isPaused = true
            }
            
            self?.run(SKAction.sequence([wait, code]))
        }
        
        goHome.selectedHandler = { [weak self] in
            
            if self?.canPressButton == false {return}
            
            self?.goHome.isHidden = true
            self?.pauseButton.isHidden = true
            
            var background = SKSpriteNode()
            var texture = SKTexture(imageNamed: "popUp")
            background = SKSpriteNode(texture: texture)
            
            self?.addChild(background)
            
            background.name = "d"
            background.size.height = 300
            background.size.width = 305
            background.position.x = 160
            background.position.y = 335
            background.zPosition = 5
            
            texture = SKTexture(imageNamed: "areYou")
            let cracksRemoved = SKSpriteNode(texture: texture)
            self?.addChild(cracksRemoved)
            
            cracksRemoved.name = "fehvsj"
            cracksRemoved.position.x = 160
            cracksRemoved.position.y = 400
            cracksRemoved.xScale = 0.9
            cracksRemoved.yScale = 0.9
            cracksRemoved.zPosition = 6
            
            texture = SKTexture(imageNamed: "moneyCollected")
            let finalMoney = SKSpriteNode(texture: texture)
            
            if self?.currentState == .tutorial{
                cracksRemoved.position.y = 350
            }else{
                self?.addChild(finalMoney)
            }
            
            finalMoney.name = "fehvsj"
            finalMoney.xScale = 0.55
            finalMoney.yScale = 0.55
            finalMoney.position.x = 160
            finalMoney.position.y = 325
            finalMoney.zPosition = 6
            
            self?.retryButton.isHidden = false
            self?.homeButton.isHidden = false
            
            self?.retryButton.texture = SKTexture(imageNamed: "cancelButton")
            self?.homeButton.texture = SKTexture(imageNamed: "confirmButton")
            
            let wait = SKAction.wait(forDuration: 0.1)
            let code = SKAction.run {
                self?.scene?.view?.isPaused = true
            }
            
            self?.run(SKAction.sequence([wait,code]))
            
            self?.retryButton.selectedHandler = { [weak self] in
                
                self?.goHome.isHidden = false
                self?.pauseButton.isHidden = false
                
                self?.scene?.view?.isPaused = false
                
                self?.retryButton.texture = SKTexture(imageNamed: "retryButton")
                self?.homeButton.texture = SKTexture(imageNamed: "homeButton")
                
                background.removeFromParent()
                finalMoney.removeFromParent()
                cracksRemoved.removeFromParent()
                
                self?.retryButton.isHidden = true
                self?.homeButton.isHidden = true
            }
            
            self?.homeButton.selectedHandler = { [weak self] in
                Answers.logLevelEnd("\(buildingMenu.buildingName)",
                    score: 0,
                    success: false,
                    customAttributes: [
                        "Money Collected": 0
                    ])
                
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
                
                self?.music.stop()
                
                let skView = self?.view as SKView!
                
                guard let scene = SKScene(fileNamed:"buildingsMenu") as SKScene! else { return }
                
                scene.scaleMode = .aspectFill
                skView?.presentScene(scene)
            }
            
        }
    }
    
    func beginFunc() {
        
        for i in 0 ... 5{
            let man = Man()
            
            addChild(man)
            
            man.name = "man\(i)"
            man.position.x = manPositionX[i]
            man.position.y = manPositionY
            man.zPosition = 3
            
            man.physicsBody =  SKPhysicsBody(rectangleOf: man.size)
            man.physicsBody?.categoryBitMask = 1
            man.physicsBody?.contactTestBitMask = 4294967295
            man.physicsBody?.isDynamic = false
            
            let face = textureToNode(name: "faceWithNeck")
            man.addChild(face)
            face.name = "face"
            face.position.x = 2
            face.position.y = 84
            
            face.physicsBody = SKPhysicsBody(rectangleOf: face.size)
            face.physicsBody?.categoryBitMask = 1
            face.physicsBody?.contactTestBitMask = 4294967295
            face.physicsBody?.isDynamic = false
            
            man.xScale = 0.25
            man.yScale = 0.3
        }
        
        if buildingMenu.oldManMoving{
            
            let old = textureToNode(name: "oldMan")
            addChild(old)
            
            old.name = "oldManMoving"
            old.zPosition = 3
            old.size.width = 30
            old.size.height = 30
            old.position.x = 40
            old.position.y = 435
            
            oldManMove(old: old)
        }
        
        for i in 1 ... buildingMenu.numberWindows - buildingMenu.numberNoCracks{
            let window = childNode(withName: "w\(i)")
            
            openWindowX.append((window?.position.x)!)
            openWindowY.append((window?.position.y)!)
        }
        
        let userDefaults = UserDefaults.standard
        let tutorialCompleted = userDefaults.bool(forKey: "tutorialCompelted") as Bool ?? false
        userDefaults.synchronize()

        
        if !tutorialCompleted{
            currentState = .tutorial
        }
        
        if currentState == .tutorial{
            tutorial()
            
            toolList.append(.glue)
            toolList.append(.wood)
        }else{
            addRandomTool()
            addRandomTool()
        }
        
        let pointer = addPointer(box: b1)
        previousPointer = pointer
        
        displayTools()
        
        currentTool.text = getNameOfCurrentTool()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if t1{
            arrow1.removeFromParent()
            arrow2.removeFromParent()
            tapSwitch.removeFromParent()
            
            let wait = SKAction.wait(forDuration: 1.5)
            let action = SKAction.run{
                self.t2 = true
            }
            
            run(SKAction.sequence([wait,action]))
            
            t1 = false
        }
        
        if t4{
            scene?.view?.isPaused = false
            leave.removeFromParent()
            hit5.removeFromParent()
            
            t4 = false
            
            however = textureToNode(name: "however")
            addChild(however)
            
            however.position.x = 160
            however.position.y = 400
            however.xScale = 0.55
            however.yScale = 0.55
            however.zPosition = 4
            
            remove5 = textureToNode(name: "remove5")
            addChild(remove5)
            
            remove5.position.x = 160
            remove5.position.y = 370
            remove5.xScale = 0.55
            remove5.yScale = 0.55
            remove5.zPosition = 4
            
            t4 = false
            t5 = true
            
            return
        }
        
        if ttt4{
            scene?.view?.isPaused = false
            
            fallingBrick.removeFromParent()
            
            ttt4 = false
            tt4 = true
        }
        
        if t5{
            however.removeFromParent()
            remove5.removeFromParent()
            
            let wait = SKAction.wait(forDuration: 0.1)
             let code = SKAction.run {
             self.toolList.append(.lock)
             
             self.removeTool()
             self.displayTools()
             self.currentTool.text = self.getNameOfCurrentTool()
             
             self.openWindow()
             
             self.lockLabel = self.textureToNode(name: "locks")
             self.addChild(self.lockLabel)
             
             self.lockLabel.position.x = 160
             self.lockLabel.position.y = 380
             self.lockLabel.xScale = 0.65
             self.lockLabel.yScale = 0.65
             self.lockLabel.zPosition = 4
             
             let point = self.addPointer(box: self.b2)
             self.previousPointer.removeFromParent()
             self.previousPointer = point
             self.pointerPosition = 1
             self.currentTool.text = self.getNameOfCurrentTool()
             
             self.arrow1 = self.textureToNode(name: "arrow")
             self.addChild(self.arrow1)
             
             self.arrow1.name = "a1"
             self.arrow1.zRotation = -((1/3) * CGFloat.pi)
             self.arrow1.zPosition = 3
             self.arrow1.position.x = 190
             self.arrow1.position.y = 165
             self.arrow1.xScale = 0.3
             self.arrow1.yScale = 0.3
             }
             
             run(SKAction.sequence([wait,code]))
             
             t7 = true
            t5 = false
            return
        }
        /*
         if tutorial3{
         tutorialLabel.removeFromParent()
         scene?.view?.isPaused = false
         
         tutorial3 = false
         tutorial4 = true
         
         return
         }
         
         if tutorial7{
         tutorialLabel.removeFromParent()
         tutorialLabel2.removeFromParent()
         scene?.view?.isPaused = false
         
         tutorial7 = false
         
         endTutorial()
         
         return
         }
         
         if tutorial6{
         tutorialLabel.removeFromParent()
         tutorialLabel2.removeFromParent()
         
         tutorialLabel.text = "HOWEVER, IF \(numCracksToMove) CRACKS ARE REMOVED "
         tutorialLabel.fontName = "Didot Bold"
         tutorialLabel.fontSize = 14
         tutorialLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
         
         tutorialLabel.name = "label"
         tutorialLabel.position.x = 160
         tutorialLabel.position.y = 380
         tutorialLabel.zPosition = 4
         
         tutorialLabel2.text = "A PERSON MOVES INSIDE AND PAYS YOU MONEY"
         tutorialLabel2.fontName = "Didot Bold"
         tutorialLabel2.fontSize = 12
         tutorialLabel2.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
         
         tutorialLabel2.name = "label"
         tutorialLabel2.position.x = 160
         tutorialLabel2.position.y = tutorialLabel.position.y - 24
         tutorialLabel2.zPosition = 4
         
         
         self.view?.isUserInteractionEnabled = false
         
         let wait = SKAction.wait(forDuration: 0.1)
         let code = SKAction.run {
         self.view?.isUserInteractionEnabled = true
         self.addChild(self.tutorialLabel)
         self.addChild(self.tutorialLabel2)
         }
         self.run(SKAction.sequence([wait,code]))
         
         tutorial6 = false
         tutorial7 = true
         
         return
         }*/
        
        if currentState != .notPlaying && cement == false && tape == false && portal == false{
            let touch = touches.first!
            let location = touch.location(in: self)
            let nodeAtPoint = atPoint(location)
            let nodeName = nodeAtPoint.name
            
            if nodeName == "box1" {
                let point = addPointer(box: b1)
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 0
                currentTool.text = getNameOfCurrentTool()
                return
            }
            
            if nodeName == "box2" {
                let point = addPointer(box: b2)
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 1
                currentTool.text = getNameOfCurrentTool()
                return
            }
            
            if coolingDown == false {
                
                if getCurrentTool() == .lock{
                    if (nodeName?.hasPrefix("openWindow"))! || (nodeName?.hasPrefix("oldMan"))!{
                        var index = 0
                        
                        for i in 1...buildingMenu.numberWindows{
                            if (childNode(withName: "noCracks\(i)")?.contains(location))!{
                                index = i - 1
                            }
                        }
                        
                        let window = childNode(withName: "openWindow\(index)")
                        let man = childNode(withName: "oldMan\(index)")
                        
                        let i = windowsPosition.index(of: index)
                        windows.remove(at: i!)
                        windowsPosition.remove(at: i!)
                        
                        man?.removeFromParent()
                        window?.removeFromParent()
                        
                        if t7{
                            lockLabel.removeFromParent()
                            arrow1.removeFromParent()
                            
                            endTutorial()
                        }
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
                        
                        Score += 1
                        scoreChanged = true
                        
                        shouldMovePerson()
                    }else if nodeName == "crack"{
                        /*if !warningLabelShowing{
                         warningLabelShowing = true
                         
                         addChild(warningLabel)
                         
                         warningLabel.name = "warning"
                         warningLabel.text = "LOCKS CLOSE WINDOWS"
                         warningLabel.fontName = "Didot Bold"
                         warningLabel.fontSize = 20
                         warningLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.8, duration: 0))
                         
                         warningLabel.position.x = 160
                         warningLabel.position.y = 400
                         warningLabel.zPosition = 58
                         
                         let wait = SKAction.wait(forDuration: 2)
                         let action = SKAction.run {
                         self.warningLabel.removeFromParent()
                         self.warningLabelShowing = false
                         }
                         
                         self.run(SKAction.sequence([wait,action]))
                         }*/
                    }
                }else if getCurrentTool() == .cement {
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("openWindow"))! || (nodeName?.hasPrefix("w"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        //cement = true
                        //canPressButton = false
                        
                        /*addChild(cementArea)
                        
                        cementArea.name = "cementArea"
                        cementArea.zPosition = 0
                        cementArea.color = UIColor.red
                        cementArea.alpha = 0.5
                        cementArea.size.height = 80
                        cementArea.size.width = 80
                        cementArea.anchorPoint.x = 0.5
                        cementArea.anchorPoint.y = 0.5
                        halfCementSize = cementArea.size.height/2*/
                        
                        /*if location.y > (gameTop - halfCementSize) - nodeAboveTouch{
                            cementArea.position.y = gameTop - halfCementSize
                        }else if location.y < gameBottom + halfCementSize - nodeAboveTouch{
                            cementArea.position.y = gameBottom + halfCementSize
                        }else{
                            cementArea.position.y = location.y + nodeAboveTouch
                        }
                        
                        if location.x < gameLeft + halfCementSize {
                            cementArea.position.x = halfCementSize
                        }else if location.x > gameRight - halfCementSize{
                            cementArea.position.x = gameRight - halfCementSize
                        }else{
                            cementArea.position.x = location.x
                        }*/
                        
                        let c = SKSpriteNode()
                        addChild(c)
                        
                        c.name = "cementArea"
                        c.zPosition = 0
                        c.color = UIColor.red
                        c.alpha = 0.5
                        c.size.height = 80
                        c.size.width = 80
                        c.anchorPoint.x = 0.5
                        c.anchorPoint.y = 0.5
                        halfCementSize = c.size.height/2
                        
                        
                        if location.y > (gameTop - halfCementSize) - nodeAboveTouch{
                            c.position.y = gameTop - halfCementSize
                        }else if location.y < gameBottom + halfCementSize - nodeAboveTouch{
                            c.position.y = gameBottom + halfCementSize
                        }else{
                            c.position.y = location.y + nodeAboveTouch
                        }
                        
                        if location.x < gameLeft + halfCementSize {
                            c.position.x = halfCementSize
                        }else if location.x > gameRight - halfCementSize{
                            c.position.x = gameRight - halfCementSize
                        }else{
                            c.position.x = location.x
                        }
                        
                        for crack in cracks{
                            if c.contains(crack.position){
                                removeCrack(nodeAtPoint: crack)
                                shouldMovePerson()
                            }
                        }
                        
                        cement = false
                        
                        let wait = SKAction.wait(forDuration: 0.1)
                        let action = SKAction.run {
                            c.removeFromParent()
                        }
                        run(SKAction.sequence([wait,action]))
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
                    }
                }else if getCurrentTool() == . tape{
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("openWindow"))! || (nodeName?.hasPrefix("w"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        //tape = true
                        //canPressButton = false
                        
                        /*addChild(tapeArea)
                        
                        tapeArea.name = "tapeArea"
                        tapeArea.zPosition = 0
                        tapeArea.color = UIColor.red
                        tapeArea.alpha = 0.5
                        tapeArea.size.height = 30
                        tapeArea.size.width = 320
                        tapeArea.anchorPoint.x = 0.5
                        tapeArea.anchorPoint.y = 0.5
                        tapeArea.position.x = 160
                        halfTapeSize = tapeArea.size.height/2*/
                        
                        /*if location.y > (gameTop - halfTapeSize) - nodeAboveTouch{
                            tapeArea.position.y = gameTop - halfTapeSize
                        }else if location.y < gameBottom + halfTapeSize - nodeAboveTouch{
                            tapeArea.position.y = gameBottom + halfTapeSize
                        }else{
                            tapeArea.position.y = location.y + nodeAboveTouch
                        }*/
                        
                        let t = SKSpriteNode()
                        addChild(t)
                        
                        t.name = "tapeArea"
                        t.zPosition = 0
                        t.color = UIColor.red
                        t.alpha = 0.5
                        t.size.height = 30
                        t.size.width = 320
                        t.anchorPoint.x = 0.5
                        t.anchorPoint.y = 0.5
                        t.position.x = 160
                        halfTapeSize = t.size.height/2
                        
                        if location.y > (gameTop - halfTapeSize) - nodeAboveTouch{
                            t.position.y = gameTop - halfTapeSize
                        }else if location.y < gameBottom + halfTapeSize - nodeAboveTouch{
                            t.position.y = gameBottom + halfTapeSize
                        }else{
                            t.position.y = location.y + nodeAboveTouch
                        }
                        
                        for crack in cracks{
                            if t.contains(crack.position){
                                removeCrack(nodeAtPoint: crack)
                                shouldMovePerson()
                            }
                        }
                        
                        let wait = SKAction.wait(forDuration: 0.1)
                        let action = SKAction.run {
                            t.removeFromParent()
                        }
                        run(SKAction.sequence([wait,action]))
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
                        
                    }
                }else if getCurrentTool() == .portal{
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("openWindow"))! || (nodeName?.hasPrefix("w"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        /*portal = true
                        canPressButton = false
                        
                        let portalHole = Portal()
                        addChild(portalHole)
                        portals.append(portalHole)
                        portalIndex = portals.index(of: portalHole)!
                        
                        portalHole.name = "portalHole"
                        portalHole.color = UIColor.black
                        portalHole.alpha = 0.8
                        portalHole.size.height = 5
                        portalHole.size.width = 90
                        halfPortalHeight = portalHole.size.height/2
                        halfPortalWidth = portalHole.size.width/2
                        
                        if location.y > (gameTop - halfPortalHeight) - nodeAboveTouch{
                            portalHole.position.y = gameTop - halfPortalHeight
                        }else if location.y < gameBottom + halfPortalHeight - nodeAboveTouch{
                            portalHole.position.y = gameBottom + halfPortalHeight
                        }else{
                            portalHole.position.y = location.y + nodeAboveTouch
                        }
                        
                        if location.x < gameLeft + halfPortalWidth {
                            portalHole.position.x = halfPortalWidth
                        }else if location.x > gameRight - halfPortalWidth{
                            portalHole.position.x = gameRight - halfPortalWidth
                        }else{
                            portalHole.position.x = location.x
                        }*/
                        
                        let portalHole = Portal()
                        addChild(portalHole)
                        portals.append(portalHole)
                        portalIndex = portals.index(of: portalHole)!
                        
                        portalHole.name = "portalHole"
                        portalHole.color = UIColor.black
                        portalHole.alpha = 0.8
                        portalHole.size.height = 5
                        portalHole.size.width = 90
                        halfPortalHeight = portalHole.size.height/2
                        halfPortalWidth = portalHole.size.width/2
                        
                        if location.y > (gameTop - halfPortalHeight) - nodeAboveTouch{
                            portalHole.position.y = gameTop - halfPortalHeight
                        }else if location.y < gameBottom + halfPortalHeight - nodeAboveTouch{
                            portalHole.position.y = gameBottom + halfPortalHeight
                        }else{
                            portalHole.position.y = location.y + nodeAboveTouch
                        }
                        
                        if location.x < gameLeft + halfPortalWidth {
                            portalHole.position.x = halfPortalWidth
                        }else if location.x > gameRight - halfPortalWidth{
                            portalHole.position.x = gameRight - halfPortalWidth
                        }else{
                            portalHole.position.x = location.x
                        }
                        
                        let wait = SKAction.wait(forDuration: 5)
                        let action = SKAction.run {
                            portalHole.removeFromParent()
                        }
                        
                        portalHole.run(SKAction.sequence([wait, action]))
                        portalHole.start = NSDate()
                        
                        portalHole.physicsBody = SKPhysicsBody(rectangleOf: portalHole.size)
                        portalHole.physicsBody?.affectedByGravity = false
                        portalHole.physicsBody?.isDynamic = false
                        portalHole.physicsBody?.contactTestBitMask = 7
                        portalHole.physicsBody?.categoryBitMask = 0
                        portalHole.physicsBody?.collisionBitMask = 7
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()

                    }
                    
                }else if getCurrentTool() == .wall{
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("openWindow"))! || (nodeName?.hasPrefix("w"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        /*newWall = true
                        canPressButton = false
                        
                        addChild(newWallArea)
                        
                        newWallArea.name = "newWallArea"
                        newWallArea.size.height = 330
                        newWallArea.size.width = 320
                        newWallArea.color = UIColor.red
                        newWallArea.alpha = 0.5
                        newWallArea.position.x = 160
                        newWallArea.position.y = 320*/
                        
                        let n = SKSpriteNode()
                        
                        addChild(n)
                        
                        n.name = "newWallArea"
                        n.size.height = 360
                        n.size.width = 320
                        n.color = UIColor.red
                        n.alpha = 0.5
                        n.position.x = 160
                        n.position.y = 330
                        
                        for crack in cracks{
                            if n.contains(crack.position){
                                removeCrack(nodeAtPoint: crack)
                                shouldMovePerson()
                            }
                        }
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()

                        let wait = SKAction.wait(forDuration: 0.1)
                        let action = SKAction.run {
                            n.removeFromParent()
                        }
                        run(SKAction.sequence([wait,action]))
                    }
                }else if getCurrentTool() == .ice{
                    let node = nodes(at: location)
                    
                    for i in node{
                        
                        if i.name == "oldManMoving"{
                            
                            i.removeAllActions()
                            
                            i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0))
                            
                            let wait = SKAction.wait(forDuration: freezeTime)
                            let code = SKAction.run {
                                i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 0, duration: 0))
                                self.oldManMove(old: i as! SKSpriteNode)
                            }
                            
                            i.run(SKAction.sequence([wait, code]))
                            
                            removeTool()
                            addRandomTool()
                            displayTools()
                            currentTool.text = getNameOfCurrentTool()
                        }else if i.name == "oldMan"{
                            
                            if i.hasActions(){
                                i.removeAllActions()
                                
                                i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0))
                                
                                let wait = SKAction.wait(forDuration: freezeTime)
                                let action = SKAction.repeatForever(SKAction.sequence([SKAction.run{
                                    i.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 0, duration: 0))
                                    },SKAction.wait(forDuration: 1.5),
                                      SKAction.run {
                                        self.makeTooth(node: i as! SKSpriteNode)
                                    }]))
                                
                                i.run(SKAction.sequence([wait, action]))
                                
                                removeTool()
                                addRandomTool()
                                displayTools()
                                currentTool.text = getNameOfCurrentTool()
                            }
                            
                        }else if i.name == "crack"{
                            
                            if i.hasActions(){
                                i.removeAllActions()
                                
                                i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0))
                                
                                let wait = SKAction.wait(forDuration: freezeTime)
                                let action = SKAction.repeatForever(SKAction.sequence([SKAction.run{
                                    i.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
                                    },SKAction.wait(forDuration: 1.5),
                                      SKAction.run {
                                        self.dropBrick(node: i as! SKSpriteNode)
                                    }]))
                                
                                i.run(SKAction.sequence([wait, action]))
                                
                                removeTool()
                                addRandomTool()
                                displayTools()
                                currentTool.text = getNameOfCurrentTool()
                            }
                            
                        }else if i.name == "robber"{
                            if i.hasActions(){
                                i.removeAllActions()
                                
                                i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0))
                                
                                let wait = SKAction.wait(forDuration: freezeTime)
                                let action = SKAction.run {
                                    let x = i.position.x
                                    
                                    let action = SKAction.run {
                                        var robbedMoney = 200
                                        
                                        if self.moneyCollected < 200{
                                            robbedMoney = self.moneyCollected
                                        }
                                        
                                        self.addText(node: i as! SKSpriteNode, t: "-\(robbedMoney)", color: UIColor.red)
                                        
                                        self.moneyCollected -= robbedMoney
                                        i.removeFromParent()
                                    }
                                    
                                    if x < 160{
                                        i.run(SKAction.sequence([SKAction.moveTo(x: 160, duration: TimeInterval(5/abs(160/x))), action]))
                                    }else{
                                        i.run(SKAction.sequence([SKAction.moveTo(x: 160, duration: TimeInterval(5/abs(x/160))), action]))
                                    }
                                    
                                    i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 0, duration: 0))
                                }
                                
                                i.run(SKAction.sequence([wait,action]))
                                
                                removeTool()
                                addRandomTool()
                                displayTools()
                                currentTool.text = getNameOfCurrentTool()
                            }
                        }
                        
                    }
                    
                }else if getCurrentTool() == .health{
                    
                    if (nodeName?.hasPrefix("man"))!{
                        let node = childNode(withName: nodeName!) as! Man
                        node.timesHit = 0
                        
                        let n = node.children
                        
                        for i in n{
                            if i.name == "face"{
                                 i.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 0))
                            }
                        }
                        
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
            
                    }else if nodeName == "face"{
                        let node = nodeAtPoint.parent as! Man
                        node.timesHit = 0
                        
                        let n = node.children
                        
                        for i in n{
                            if i.name == "face"{
                                i.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 0))
                            }
                        }
                        
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()

                    }
                }else if getCurrentTool() == .police{
                    if nodeName == "robber"{
                        let node = childNode(withName: "robber") as! SKSpriteNode
                        
                        node.removeAllActions()
                        
                        let action = SKAction.run {
                            node.removeFromParent()
                        }
                        if node.position.x > 160{
                            node.run(SKAction.sequence([SKAction.moveBy(x: 200, y: 0, duration: 2), action]))
                        }else{
                            node.run(SKAction.sequence([SKAction.moveBy(x: -200, y: 0, duration: 2), action]))
                        }
                        
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
                    }
                }else if nodeName == "crack"{
                    if currentState == .tutorial && t6{
                        
                        /*let wait = SKAction.wait(forDuration: 2)
                         let action = SKAction.run{
                         self.tutorial1 = true
                         }
                         
                         run(SKAction.sequence([wait,action]))*/
                        
                        tapCrack.removeFromParent()
                        
                        arrow1 = textureToNode(name: "arrow")
                        arrow2 = textureToNode(name: "arrow")
                        addChild(arrow1)
                        addChild(arrow2)
                        
                        arrow1.zRotation = -((1/3) * CGFloat.pi)
                        arrow1.zPosition = 3
                        arrow1.position.x = 190
                        arrow1.position.y = 165
                        
                        arrow2.zRotation = (4/3) * CGFloat.pi
                        arrow2.zPosition = 3
                        arrow2.position.x = 130
                        arrow2.position.y = 165
                        
                        arrow1.xScale = 0.3
                        arrow2.xScale = 0.3
                        arrow1.yScale = 0.3
                        arrow2.yScale = 0.3
                        
                        arrow1.name = "a1"
                        arrow2.name = "a2"
                        
                        tapSwitch = textureToNode(name: "tapSwitch")
                        addChild(tapSwitch)
                        
                        tapSwitch.xScale = 0.65
                        tapSwitch.yScale = 0.65
                        tapSwitch.position.x = 160
                        tapSwitch.position.y = 380
                        tapSwitch.zPosition = 3
                        
                        t6 = false
                        t1 = true
                    }
                    
                    addRandomTool()
                    
                    removeCrack(nodeAtPoint: nodeAtPoint)
                    
                    shouldMovePerson()
                    
                    removeTool()
                    displayTools()
                    currentTool.text = getNameOfCurrentTool()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if cement{
            if location.x < gameLeft + halfCementSize {
                cementArea.position.x = halfCementSize
            }else if location.x > gameRight - halfCementSize{
                cementArea.position.x = gameRight - halfCementSize
            }else{
                cementArea.position.x = location.x
            }
            
            if location.y > (gameTop - halfCementSize) - nodeAboveTouch{
                cementArea.position.y = gameTop - halfCementSize
            }else if location.y < gameBottom + halfCementSize - nodeAboveTouch{
                cementArea.position.y = gameBottom + halfCementSize
            }else{
                cementArea.position.y = location.y + nodeAboveTouch
            }
            
            //cementArea.position.x = location.x
            //cementArea.position.y = location.y
        }
        
        if tape{
            if location.y > (gameTop - halfTapeSize) - nodeAboveTouch{
                tapeArea.position.y = gameTop - halfTapeSize
            }else if location.y < gameBottom + halfTapeSize - nodeAboveTouch{
                tapeArea.position.y = gameBottom + halfTapeSize
            }else{
                tapeArea.position.y = location.y + nodeAboveTouch
            }
        }
        
        if portal{
            if location.y > (gameTop - halfPortalHeight) - nodeAboveTouch{
                portals[portalIndex].position.y = gameTop - halfPortalHeight
            }else if location.y < gameBottom + halfPortalHeight - nodeAboveTouch{
                portals[portalIndex].position.y = gameBottom + halfPortalHeight
            }else{
                portals[portalIndex].position.y = location.y + nodeAboveTouch
            }
            
            if location.x < gameLeft + halfPortalWidth {
                portals[portalIndex].position.x = halfPortalWidth
            }else if location.x > gameRight - halfPortalWidth{
                portals[portalIndex].position.x = gameRight - halfPortalWidth
            }else{
                portals[portalIndex].position.x = location.x
            }
        }
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if cement{
            for crack in cracks{
                if cementArea.contains(crack.position){
                    removeCrack(nodeAtPoint: crack)
                    shouldMovePerson()
                }
            }
            
            cement = false
            cementArea.removeFromParent()
            coolDown()
            removeTool()
            addRandomTool()
            displayTools()
            currentTool.text = getNameOfCurrentTool()
        }
        
        if tape{
            let tapeRoll = textureToNode(name: "tapeRoll")
            //addChild(tapeRoll)
            
            tapeRoll.name = "tapeRoll"
            tapeRoll.anchorPoint.x = 0.5
            tapeRoll.anchorPoint.y = 0.5
            tapeRoll.zPosition = 3
            tapeRoll.size.height = 30
            tapeRoll.size.width = 30
            tapeRoll.position.x = -30
            tapeRoll.position.y = tapeArea.position.y
            
            tapeRoll.run(SKAction.moveTo(x: 335, duration: 0.5))
            
            tape = false
            tapeArea.removeFromParent()
            
            for crack in cracks{
                if tapeArea.contains(crack.position){
                    removeCrack(nodeAtPoint: crack)
                    shouldMovePerson()
                }
            }
            
            coolDown()
            removeTool()
            addRandomTool()
            displayTools()
            currentTool.text = getNameOfCurrentTool()
        }
        
        if portal{
            let p = portals[portalIndex]
            
            let wait = SKAction.wait(forDuration: 5)
            let action = SKAction.run {
                p.removeFromParent()
            }
            
            p.run(SKAction.sequence([wait, action]))
            portals[portalIndex].start = NSDate()
            
            portals[portalIndex].physicsBody = SKPhysicsBody(rectangleOf: portals[portalIndex].size)
            portals[portalIndex].physicsBody?.affectedByGravity = false
            portals[portalIndex].physicsBody?.isDynamic = false
            portals[portalIndex].physicsBody?.contactTestBitMask = 7
            portals[portalIndex].physicsBody?.categoryBitMask = 0
            portals[portalIndex].physicsBody?.collisionBitMask = 7
            
            coolDown()
            removeTool()
            addRandomTool()
            displayTools()
            currentTool.text = getNameOfCurrentTool()
            
            portal = false
        }
        
        if newWall{
            for crack in cracks{
                if newWallArea.contains(crack.position){
                    removeCrack(nodeAtPoint: crack)
                    shouldMovePerson()
                }
            }
            
            newWallArea.removeFromParent()
            coolDown()
            removeTool()
            addRandomTool()
            displayTools()
            currentTool.text = getNameOfCurrentTool()
            
            newWall = false
        }
        
        canPressButton = true
        windowContains = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentState == .tutorial{
            /*if tutorial1{
             let crack = Crack()
             addChild(crack)
             
             crack.zPosition = 1
             crack.name = "crack"
             crack.position.x = 45
             crack.position.y = 250
             
             cracks.append(crack)
             
             crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
             
             firstCrackStart = NSDate()
             
             self.view?.isUserInteractionEnabled = false
             
             tutorial2 = true
             tutorial1 = false
             }*/
            
            if t2{
                let crack = Crack()
                addChild(crack)
                
                crack.zPosition = 1
                crack.name = "crack"
                crack.position.x = 45
                crack.position.y = 250
                
                cracks.append(crack)
                
                crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
                
                firstCrackStart = NSDate()
                
                self.view?.isUserInteractionEnabled = false
                
                t2 = false
                t3 = true
            }
            
            if t3{
                let end = NSDate()
                
                if end.timeIntervalSince(firstCrackStart as Date) > 1{
                    
                    t3 = false
                    
                    dropBrick(node: cracks[0])
                    
                    fallingBrick = textureToNode(name: "fallingBrick")
                    addChild(fallingBrick)
                    
                    fallingBrick.name = "fallingBrick"
                    fallingBrick.position.x = 160
                    fallingBrick.position.y = 370
                    fallingBrick.zPosition = 4
                    
                    let wait = SKAction.wait(forDuration: 0.3)
                    let code = SKAction.run {
                        self.view?.isUserInteractionEnabled = true
                        self.scene?.view?.isPaused = true
                        self.ttt4 = true
                    }
                    
                    run(SKAction.sequence([wait,code]))
                }
                
            }
            /*
             if tutorial2{
             let end = NSDate()
             
             if end.timeIntervalSince(firstCrackStart as Date) > 1{
             
             dropBrick(node: cracks[0])
             
             addChild(tutorialLabel)
             
             tutorialLabel.text = "A BRICK IS FALLING"
             tutorialLabel.fontName = "Didot Bold"
             tutorialLabel.fontSize = 28
             tutorialLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
             
             tutorialLabel.name = "label"
             tutorialLabel.position.x = 160
             tutorialLabel.position.y = 370
             tutorialLabel.zPosition = 4
             
             let wait = SKAction.wait(forDuration: 0.3)
             let code = SKAction.run {
             self.view?.isUserInteractionEnabled = true
             self.scene?.view?.isPaused = true
             self.tutorial3 = true
             }
             
             run(SKAction.sequence([wait,code]))
             
             tutorial2 = false
             }
             }*/
        }else{
            if coolingDown == false{
                coolDownLabel.removeFromParent()
                ifPressedTwice = false
            }
            
            if currentState == .playing {
                
                shouldMovePerson()
                
                let end = NSDate()
                let time = end.timeIntervalSince(crackStart as Date)
                
                if time > crackInterval{
                    addCrack()
                    crackStart = NSDate()
                    
                    if crackInterval > 1{
                        crackInterval -= 0.2
                    }
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA: SKPhysicsBody = contact.bodyA
        let contactB: SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        if (nodeA.name == "singleBrick" && nodeB.name == "singleBrick") && (nodeA.name == "tooth" || nodeB.name == "tooth") {
            waitToRemove(node: nodeA, time: 1.5)
            waitToRemove(node: nodeB, time: 1.5)
            
        }else if nodeA.name == "singleBrick" || nodeB.name == "singleBrick" || nodeA.name == "tooth" || nodeB.name == "tooth"{
            
            if (nodeB.name?.hasPrefix("man"))! || (nodeA.name?.hasPrefix("man"))! || nodeA.name == "face" || nodeB.name == "face"{
                
                var p = SKSpriteNode()
                
                if nodeA.name == "face"{
                    p = nodeA.parent as! SKSpriteNode
                    contactManSomething(man: p, something: nodeB)
                }else if nodeB.name == "face"{
                    p = nodeB.parent as! SKSpriteNode
                    contactManSomething(man: p, something: nodeA)
                }else if (nodeA.name?.hasPrefix("man"))!{
                    contactManSomething(man: nodeA, something: nodeB)
                }else if (nodeB.name?.hasPrefix("man"))!{
                    contactManSomething(man: nodeB, something: nodeA)
                }
                
            }else if nodeB.name == "ground" || nodeA.name == "ground"{
                
                if nodeA.name == "singleBrick"{
                    waitToRemove(node: nodeA, time: 1.5)
                }else{
                    waitToRemove(node: nodeB, time: 1.5)
                }
                
                if nodeA.name == "tooth"{
                    waitToRemove(node: nodeA, time: 1.5)
                }else{
                    waitToRemove(node: nodeB, time: 1.5)
                }
                
            }else if nodeB.name == "portalHole" || nodeA.name == "portalHole"{
                
                if nodeA.name == "singleBrick"{
                    waitToRemove(node: nodeA, time: 0.0)
                }else{
                    waitToRemove(node: nodeB, time: 0.0)
                }
            }
            
        }
    }
    
    func tutorial() {
        let crack = Crack()
        addChild(crack)
        
        crack.zPosition = 1
        crack.name = "crack"
        crack.position.x = 150
        crack.position.y = 350
        
        cracks.append(crack)
        
        crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
        
        tapCrack = textureToNode(name: "tapCrack")
        addChild(tapCrack)
        tapCrack.zPosition = 3
        tapCrack.position.x = 160
        tapCrack.position.y = 380
        tapCrack.xScale = 0.75
        tapCrack.yScale = 0.75
        
        /*let tapLabel: SKLabelNode = SKLabelNode(fontNamed: "Georgia")
         crack.addChild(tapLabel)
         
         tapLabel.text = "Using Tools Below"
         tapLabel.name = "someText"
         tapLabel.fontSize = 24
         tapLabel.zPosition = 3
         tapLabel.position.x = 0
         tapLabel.position.y = 25
         tapLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
         
         let arrow1 = textureToNode(name: "arrow")
         let arrow2 = textureToNode(name: "arrow")
         crack.addChild(arrow1)
         crack.addChild(arrow2)
         
         arrow1.zRotation = -45
         arrow1.position.x = 45
         arrow1.position.y = -180
         
         arrow2.zRotation = -90
         arrow2.position.x = -25
         arrow2.position.y = -180
         
         arrow1.xScale = 0.3
         arrow2.xScale = 0.3
         arrow1.yScale = 0.3
         arrow2.yScale = 0.3
         
         arrow1.name = "efvr"
         arrow2.name = "jkwsdan"*/
    }
    
    func endTutorial(){
        currentState = .playing
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "tutorialCompelted")
        userDefaults.synchronize()
    }
    
    func shouldMovePerson() {
        if manMovingInside == false{
            if Score >= numCracksToMove {
                if Score % (numCracksToMove * 2) == 0{
                    if scoreChanged{
                        self.manMovingInside = true
                        movePersonInside(movingMan: leftMan)
                        scoreChanged = false
                    }
                }else if Score % numCracksToMove == 0 {
                    if scoreChanged{
                        self.manMovingInside = true
                        movePersonInside(movingMan: rightMan)
                        scoreChanged = false
                    }
                }
            }
        }
    }
    
    func addCrack() {
        
        let crack = Crack()
        
        crack.zPosition = 1
        crack.xScale = 1
        crack.yScale = 1
        
        var randPosition = randCrackPosition(crack: crack)
        
        while randPosition.x == 1000 || randPosition.y == 1000 {
            randPosition = randCrackPosition(crack: crack)
        }
        
        crack.position.x = CGFloat(randPosition.x)
        crack.position.y = CGFloat(randPosition.y)
        
        addChild(crack)
        crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
        
        crack.name = "crack"
        
        crack.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3.5),
                                                            SKAction.run {
                                                                if self.currentState == .playing{
                                                                    self.dropBrick(node: crack)
                                                                }
            }])))
        
        cracks.append(crack)
    }
    
    func randCrackPosition(crack: SKSpriteNode) -> CGPoint{
        var randPosition: CGPoint = CGPoint(x: 0, y: 0)
        
        randPosition.x = CGFloat(arc4random_uniform(UInt32(gameRight - (crack.size.width/2 + offTheWall))))
        
        while randPosition.x < CGFloat(crack.size.width/2 + offTheWall) {
            randPosition.x = CGFloat(arc4random_uniform(UInt32(gameRight - (crack.size.width/2 + offTheWall))))
        }
        
        randPosition.y = CGFloat(arc4random_uniform(UInt32(gameTop - (crack.size.height/2 - offTheWall))))
        
        while randPosition.y < CGFloat(gameBottom + crack.size.height/2 + offTheWall) {
            randPosition.y = CGFloat(arc4random_uniform(UInt32(gameTop - (crack.size.height/2 - offTheWall))))
        }
        
        for i in 1...buildingMenu.numberWindows{
            if (childNode(withName: "noCracks\(i)")?.contains(randPosition))!{
                randPosition.x = 1000
                randPosition.y = 1000
            }
        }
        
        return randPosition
    }
    
    func removeCrack(nodeAtPoint: SKNode) {
        
        let index = cracks.index(of: nodeAtPoint as! Crack)!
        cracks.remove(at: index)
        
        let crackRemoval = SKAction.run ({
            nodeAtPoint.removeFromParent()
        })
        
        self.run(crackRemoval)
        
        Score += 1
        
        scoreChanged = true
    }
    
    func displayTools() {
        for i in 0 ... 1 {
            let tool = toolList[i]
            displayTool(tool: tool, i: i)
        }
    }
    
    func displayTool(tool: tools, i: Int) {
        var newTool: SKSpriteNode = textureToNode(name: "glue")
        let box: SKSpriteNode = childNode(withName: "b\(i+1)") as! SKSpriteNode
        
        let position = box.position
        let size = box.size
        
        switch tool {
        case .cement:
            newTool = textureToNode(name: "cement")
        case .glue:
            newTool = textureToNode(name: "glue")
        case .tape:
            newTool = textureToNode(name: "tape")
        case .wood:
            newTool = textureToNode(name: "wood")
        case .lock:
            newTool = textureToNode(name: "lock")
        case .portal:
            newTool = textureToNode(name: "portal")
        case .wall:
            newTool = textureToNode(name: "wall")
        case .ice:
            newTool = textureToNode(name: "ice")
        case .health:
            newTool = textureToNode(name: "health")
        case .police:
            newTool = textureToNode(name: "police")
        }
        
        newTool.size = size
        newTool.zPosition = 1
        newTool.position = position
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedTools") as? [Bool] ?? []
        
        var unlockedTools: [Bool] = []
        
        if firstTime.count == 0{
            userDefaults.set(toolsMenu.unlocked, forKey: "unlockedTools")
            unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        }else{
            unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        }
        
        userDefaults.synchronize()
        
        var i = Int(arc4random_uniform(UInt32(unlockedTools.count)))
        
        while unlockedTools[i] == false || previousTool == i || i == 9{
            i = Int(arc4random_uniform(UInt32(unlockedTools.count)))
        }
        
        if currentState == .tutorial{
            while i != 1 && i != 0{
                i = Int(arc4random_uniform(UInt32(unlockedTools.count)))
            }
        }
        
        var randTool: tools = .glue
        
        switch i {
        case 0:
            randTool = .wood
        case 1:
            randTool = .glue
        case 2:
            randTool = .tape
        case 3:
            randTool = .cement
        case 4:
            randTool = .lock
            openWindow()
        case 5:
            randTool = .portal
        case 6:
            randTool = .ice
        case 7:
            randTool = .health
        case 8:
            randTool = .wall
        case 9:
            randTool = .police
            robberArrive()
        default:
            randTool = .glue
        }
        
        if randTool == .wall{
            let r = arc4random_uniform(3)
            
            if r == 0{
                randTool = .cement
            }
        }
        
        toolList.append(randTool)
        
        previousTool = i
    }
    
    func removeTool() {
        toolList.remove(at: pointerPosition)
        for i in 0 ... toolPics.count - 1{
            toolPics[i].removeFromParent()
        }
        toolPics.removeAll()
        
        /*let point = self.addPointer(box: self.b1)
         self.previousPointer.removeFromParent()
         self.previousPointer = point
         self.pointerPosition = 1
         self.currentTool.text = self.getNameOfCurrentTool()*/
        
    }
    
    func addPointer(box: SKSpriteNode) -> SKNode{
        
        let pointer = textureToNode(name: "pointer")
        addChild(pointer)
        
        let x = box.position.x
        let y = box.position.y
        
        pointer.name = "point"
        //pointer.xScale = 1.5
        //pointer.yScale = 1.5
        pointer.zPosition = 2
        
        pointer.position.x = x
        pointer.position.y = y + 30
        
        return pointer
    }
    
    func changeWaitingState() {
        coolingDown = false
    }
    
    func curentWaitTime() -> TimeInterval{
        let currentTool = getCurrentTool()
        var duration: TimeInterval = 1
        
        switch currentTool {
        case .cement:
            duration = 2
        case .glue:
            duration = 1.5
        case .tape:
            duration = 2
        case .wood:
            duration = 1.5
        case .lock:
            duration = 1
        case .portal:
            duration = 2
        case .wall:
            duration = 4
        case .ice:
            duration = 1.5
        case .health:
            duration = 2
        case .police:
            duration = 1
        }
        duration = 0.5
        
        return duration
    }
    
    func coolDown() {
        /*coolingDown = true
         
         let duration: TimeInterval = curentWaitTime()
         let finalHeightScale: CGFloat = 0.0
         let scaleHeightAction = SKAction.scaleX(to: finalHeightScale, duration: TimeInterval(duration))
         let change = SKAction.run(changeWaitingState)
         
         waitBar.run(
         SKAction.sequence([scaleHeightAction, change])
         )*/
    }
    
    func gameOver() {
        Answers.logLevelEnd("\(buildingMenu.buildingName)",
            score: Score as NSNumber,
            success: true,
            customAttributes: [
                "Money Collected": moneyCollected
            ])
        
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
        
        music.stop()
        
        currentState = .notPlaying
        
        retryButton.isHidden = false
        homeButton.isHidden = false
        
        retryButton.selectedHandler = { [weak self] in
            let skView = self?.view as SKView!
            
            guard let scene = SKScene(fileNamed:"\(buildingMenu.buildingName)") as SKScene! else { return }
            
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
        homeButton.selectedHandler = { [weak self] in
            let skView = self?.view as SKView!
            
            guard let scene = SKScene(fileNamed:"buildingsMenu") as SKScene! else { return }
            
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
        goHome.state = .msButtonNodeStateHidden
        
        
        windowsPosition.removeAll()
        
        var background = SKSpriteNode()
        var texture = SKTexture(imageNamed: "popUp")
        background = SKSpriteNode(texture: texture)
        
        addChild(background)
        
        background.name = "popUp"
        background.size.height = 300
        background.size.width = 305
        background.position.x = 160
        background.position.y = 335
        background.zPosition = 5
        
        texture = SKTexture(imageNamed: "gameOverLabel")
        let gameOverLabel = SKSpriteNode(texture: texture)
        addChild(gameOverLabel)
        
        gameOverLabel.name = "d"
        gameOverLabel.xScale = 0.5
        gameOverLabel.yScale = 0.5
        gameOverLabel.position.x = 160
        gameOverLabel.position.y = 420
        gameOverLabel.zPosition = 6
        
        let moneySign = textureToNode(name: "money")
        addChild(moneySign)
        
        moneySign.xScale = 0.8
        moneySign.yScale = 0.8
        moneySign.position.x = 100
        moneySign.position.y = 355
        moneySign.zPosition = 6
        
        let finalMoney = SKLabelNode(fontNamed: "Georgia")
        addChild(finalMoney)
        
        finalMoney.name = "fds"
        finalMoney.text = "\(moneyCollected)"
        finalMoney.fontSize = 35
        
        finalMoney.position.x = 220
        finalMoney.position.y = 345
        finalMoney.zPosition = 6
        finalMoney.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0))
        
        let scoreLabel = textureToNode(name: "scoreLabel")
        addChild(scoreLabel)
        scoreLabel.xScale = 0.5
        scoreLabel.yScale = 0.5
        scoreLabel.position.x = 100
        scoreLabel.position.y = 290
        scoreLabel.zPosition = 6
        
        let cracksRemoved = SKLabelNode(fontNamed: "Georgia")
        addChild(cracksRemoved)
        
        cracksRemoved.name = "fds"
        cracksRemoved.text = "\(Score)"
        cracksRemoved.fontSize = 35
        
        cracksRemoved.position.x = 220
        cracksRemoved.position.y = 280
        cracksRemoved.zPosition = 6
        cracksRemoved.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0))
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userDefaults.integer(forKey: "money") + moneyCollected, forKey: "money")
        userDefaults.synchronize()
        
        for crack in cracks {
            crack.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 2, duration: 3))
        }
        
        for tool in toolPics {
            tool.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 2, duration: 3))
        }
        
    }
    
    func getCurrentTool() -> tools {
        return toolList[pointerPosition]
    }
    
    func textureToNode(name: String) -> SKSpriteNode{
        let texture = SKTexture(imageNamed: name)
        return SKSpriteNode(texture: texture)
    }
    
    func getNameOfCurrentTool() -> String{
        let tool = getCurrentTool()
        
        var name = ""
        
        switch tool {
        case .cement:
            name = "cement"
        case .glue:
            name = "glue"
        case .tape:
            name = "tape"
        case .wood:
            name = "wood"
        case . lock:
            name = "lock"
        case .portal:
            name = "portal"
        case .wall:
            name = "wall"
        case .ice:
            name = "ice"
        case .health:
            name = "health"
        case .police:
            name = "police"
        }
        
        return name
    }
    
    func openWindow() {
        var num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows - buildingMenu.numberNoCracks)))
        
        while windowsPosition.contains(num) || num == prevoiusWindowOpened{
            num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows - buildingMenu.numberNoCracks)))
        }
        
        let window = Window()
        addChild(window)
        
        let man = textureToNode(name: "windowMan")
        addChild(man)
        
        window.name = "openWindow\(num)"
        window.zPosition = 2
        window.size.width = 50
        window.size.height = 50
        
        man.name = "oldMan\(num)"
        man.zPosition = 3
        man.xScale = 0.2
        man.yScale = 0.2
        
        window.position.x = openWindowX[num]
        window.position.y = openWindowY[num]
        man.position.x = openWindowX[num]
        man.position.y = openWindowY[num] - 5
        
        windows.append(window)
        windowsPosition.append(num)
        
        man.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3),
                                                          SKAction.run {
                                                            self.dropTooth(node: man, num: num)
            }])))
        
        prevoiusWindowOpened = num
    }
    
    func dropBrick(node: SKSpriteNode) {
        let brick = textureToNode(name: "singleBrick")
        addChild(brick)
        
        brick.name = "singleBrick"
        brick.position = node.position
        brick.zPosition = 2
        brick.xScale = 0.15
        brick.yScale = 0.15
        
        let rand = arc4random_uniform(180)
        brick.zRotation = CGFloat(rand)
        
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.affectedByGravity = true
        brick.physicsBody?.contactTestBitMask = 4294967295
        brick.physicsBody?.categoryBitMask = 3
        brick.physicsBody?.collisionBitMask = 3
    }
    
    func dropTooth(node: SKSpriteNode, num: Int){
        if windowsPosition.contains(num){
            makeTooth(node: node)
        }else{
            node.removeAllActions()
        }
    }
    
    func makeTooth(node: SKSpriteNode){
        
        let r = arc4random_uniform(4)
        
        let tooth = textureToNode(name: "tool\(r)")
        addChild(tooth)
        
        tooth.name = "tooth"
        tooth.position = node.position
        tooth.xScale = 0.5
        tooth.yScale = 0.5
        tooth.zPosition = 2
        
        let rand = arc4random_uniform(180)
        tooth.zRotation = CGFloat(rand)
        
        tooth.physicsBody = SKPhysicsBody(texture: tooth.texture!, size: tooth.size)
        tooth.physicsBody?.affectedByGravity = true
        tooth.physicsBody?.contactTestBitMask = 4294967295
        tooth.physicsBody?.categoryBitMask = 4
        tooth.physicsBody?.collisionBitMask = 3
    }
    
    func addText(node: SKSpriteNode, t: String, color: UIColor) {
        let textLabel: SKLabelNode = SKLabelNode(fontNamed: "Georgia")
        addChild(textLabel)
        
        textLabel.text = "\(t)"
        textLabel.fontSize = 36
        
        textLabel.position.x = node.position.x
        textLabel.position.y = node.position.y + 75
        textLabel.zPosition = 3
        textLabel.run(SKAction.colorize(with: color, colorBlendFactor: 1, duration: 0.1))
        
        let wait = SKAction.wait(forDuration: 3)
        let code = SKAction.run {
            textLabel.removeFromParent()
        }
        
        textLabel.run(
            SKAction.sequence([wait,code])
        )
    }
    
    func contactManSomething(man: SKSpriteNode, something: SKSpriteNode) {
        if something != previousNode{
            
            waitToRemove(node: something, time: 0.0)
            
            //let allNodes = nodes(at: man.position)
            let node: Man = man as! Man
            
            /*for n in allNodes{
             if (n.name?.hasPrefix("man"))!{
             node = n as! Man
             }
             }*/
            
            let time: TimeInterval = 1
            
            if node.timesHit >= Int(timesHitToLeave){
                if node.name == "man1"{
                    
                    let person: SKSpriteNode = childNode(withName: "man1") as! SKSpriteNode
                    person.name = "left"
                    
                    let f: SKSpriteNode = man.childNode(withName: "face") as! SKSpriteNode
                    f.name = "l"
                    
                    let man: SKSpriteNode = childNode(withName: "man0") as! SKSpriteNode
                    //                    let face: SKSpriteNode = man.childNode(withName: "face0") as! SKSpriteNode
                    //                    face.name = "face1"
                    man.name = "man1"
                    man.run(SKAction.moveTo(x: manPositionX[1], duration: 0.5))
                    
                }else if node.name == "man2"{
                    
                    let person: SKSpriteNode = childNode(withName: "man2") as! SKSpriteNode
                    person.name = "left"
                    
                    let f: SKSpriteNode = man.childNode(withName: "face") as! SKSpriteNode
                    f.name = "l"
                    
                    let man: SKSpriteNode = childNode(withName: "man0") as! SKSpriteNode
                    let man2: SKSpriteNode = childNode(withName: "man1") as! SKSpriteNode
                    //                    let face: SKSpriteNode = man.childNode(withName: "face0") as! SKSpriteNode
                    //                    let face2: SKSpriteNode = man.childNode(withName: "face1") as! SKSpriteNode
                    //                    face.name = "face1"
                    //                    face2.name = "face2"
                    man.name = "man1"
                    man2.name = "man2"
                    man.run(SKAction.moveTo(x: manPositionX[1], duration: 0.5))
                    man2.run(SKAction.moveTo(x: manPositionX[2], duration: 0.5))
                    
                }else if node.name == "man3"{
                    
                    let person: SKSpriteNode = childNode(withName: "man3") as! SKSpriteNode
                    person.name = "left"
                    
                    let f: SKSpriteNode = man.childNode(withName: "face") as! SKSpriteNode
                    f.name = "l"
                    
                    let man: SKSpriteNode = childNode(withName: "man4") as! SKSpriteNode
                    let man2: SKSpriteNode = childNode(withName: "man5") as! SKSpriteNode
                    man.name = "man3"
                    man2.name = "man4"
                    man.run(SKAction.moveTo(x: manPositionX[3], duration: 0.5))
                    man2.run(SKAction.moveTo(x: manPositionX[4], duration: 0.5))
                    
                }else if node.name == "man4"{
                    
                    let person: SKSpriteNode = childNode(withName: "man4") as! SKSpriteNode
                    person.name = "left"
                    
                    let f: SKSpriteNode = man.childNode(withName: "face") as! SKSpriteNode
                    f.name = "l"
                    
                    let man: SKSpriteNode = childNode(withName: "man5") as! SKSpriteNode
                    man.name = "man4"
                    man.run(SKAction.moveTo(x: manPositionX[4], duration: 0.5))
                    
                }
                if node.position.x >= 160 {
                    node.run(SKAction.moveTo(x: 320 + node.size.width, duration: time))
                    node.name = "left"
                    moveNewPerson(location: node.position)
                }else{
                    node.run(SKAction.moveTo(x: -node.size.width, duration: time))
                    node.name = "left"
                    moveNewPerson(location: node.position)
                }
                
                //run(SKAction.playSoundFileNamed("flee", waitForCompletion: false))
                
                //node.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0.1))
                
                waitToRemove(node: node, time: time)
                
                peopleLeft += 1
                
                if peopleLeft > 2{
                    gameOver()
                }
            }else{
                node.timesHit += 1
                let face: SKSpriteNode = node.childNode(withName: "face") as! SKSpriteNode
                
                face.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: face.colorBlendFactor + 1/timesHitToLeave, duration: 0))
                
                if tt4{
                    self.view?.isUserInteractionEnabled = false
                    
                    /*tutorialLabel.text = "A PERSON LEAVES IF THEY"
                     tutorialLabel.fontName = "Didot Bold"
                     tutorialLabel.fontSize = 20
                     tutorialLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
                     
                     tutorialLabel.name = "label"
                     tutorialLabel.position.x = 160
                     tutorialLabel.position.y = 380
                     tutorialLabel.zPosition = 4
                     
                     tutorialLabel2.text = "GET HIT \(Int(timesHitToLeave)) TIMES"
                     tutorialLabel2.fontName = "Didot Bold"
                     tutorialLabel2.fontSize = 20
                     tutorialLabel2.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 0))
                     
                     tutorialLabel2.name = "label"
                     tutorialLabel2.position.x = 160
                     tutorialLabel2.position.y = tutorialLabel.position.y - 24
                     tutorialLabel2.zPosition = 4
                     
                     tutorial4 = false*/
                    
                    hit5 = textureToNode(name: "hit5")
                    
                    hit5.position.x = 160
                    hit5.position.y = 400
                    hit5.xScale = 0.55
                    hit5.yScale = 0.55
                    hit5.zPosition = 4
                    
                    leave = textureToNode(name: "leave")
                    
                    leave.position.x = 160
                    leave.position.y = 370
                    leave.xScale = 0.55
                    leave.yScale = 0.55
                    leave.zPosition = 4
                    
                    let wait = SKAction.wait(forDuration: 0.1)
                    let code = SKAction.run {
                        self.view?.isUserInteractionEnabled = true
                        self.addChild(self.hit5)
                        self.addChild(self.leave)
                        
                        self.t4 = true
                    }
                    self.run(SKAction.sequence([wait,code]))
                    
                    tt4 = false
                }
            }
            previousNode = something
        }
    }
    
    func waitToRemove(node: SKSpriteNode, time: TimeInterval){
        node.run(SKAction.sequence([SKAction.wait(forDuration: time),
                                    SKAction.run {
                                        node.removeFromParent()
            }]))
    }
    
    func openDoorClose(man: SKSpriteNode) {
        let door: SKSpriteNode = childNode(withName: "door") as! SKSpriteNode
        let open = textureToNode(name: "doorIsOpen")
        
        addChild(open)
        
        open.position = door.position
        open.size = door.size
        open.zPosition = door.zPosition + 1
        
        open.run(SKAction.sequence([SKAction.wait(forDuration: 0.6),
                                    SKAction.run {
                                        open.removeFromParent()
                                        man.removeFromParent()
                                        
                                        let node: Man = man as! Man
                                        let moneyLost = 100 - (node.timesHit * 25)
                                        self.moneyCollected += moneyLost
                                        
                                        let texture = SKTexture(imageNamed: "plus\(moneyLost)")
                                        let label = SKSpriteNode(texture: texture)
                                        self.addChild(label)
                                        
                                        label.name = "plus"
                                        label.position.x = 160
                                        label.position.y = 125
                                        label.xScale = 0.65
                                        label.yScale = 0.65
                                        label.zPosition = 3
                                        
                                        let wait = SKAction.wait(forDuration: 2)
                                        let code = SKAction.run {
                                            label.removeFromParent()
                                        }
                                        
                                        label.run(SKAction.sequence([wait,code]))
                                        
                                        self.manMovingInside = false
            }]))
    }
    
    func movePersonInside(movingMan: CGPoint) {
        let moveTime = 0.5
        
        let node: [SKSpriteNode] = nodes(at: movingMan) as! [SKSpriteNode]
        var left = false
        
        if movingMan.x < 160{
            left = true
        }
        
        for man in node{
            if (man.name?.hasPrefix("man"))!{
                man.physicsBody = nil
                man.name = "person"
                
                //man.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1))
                man.run(SKAction.sequence([SKAction.moveTo(x: 160, duration: moveTime),
                                           SKAction.run {
                                            self.openDoorClose(man: man)
                                            
                                            if left{
                                                let man: SKSpriteNode = self.childNode(withName: "man0") as! SKSpriteNode
                                                let man2: SKSpriteNode = self.childNode(withName: "man1") as! SKSpriteNode
                                                man.name = "man1"
                                                man2.name = "man2"
                                                //                                                face.name = "face1"
                                                //                                                face2.name = "face2"
                                                man.run(SKAction.moveTo(x: self.manPositionX[1], duration: moveTime))
                                                man2.run(SKAction.moveTo(x: self.manPositionX[2], duration: moveTime))
                                            }else{
                                                let man: SKSpriteNode = self.childNode(withName: "man4") as! SKSpriteNode
                                                let man2: SKSpriteNode = self.childNode(withName: "man5") as! SKSpriteNode
                                                man.name = "man3"
                                                man2.name = "man4"
                                                man.run(SKAction.moveTo(x: self.manPositionX[3], duration: moveTime))
                                                man2.run(SKAction.moveTo(x: self.manPositionX[4], duration: moveTime))
                                            }
                                            self.moveNewPerson(location: movingMan)
                    }]))
            }
        }
        
    }
    
    func moveNewPerson(location: CGPoint) {
        let man = Man()
        addChild(man)
        
        man.zPosition = 3
        man.xScale = 0.25
        man.yScale = 0.3
        man.position.y = manPositionY
        
        let face = textureToNode(name: "faceWithNeck")
        man.addChild(face)
        face.name = "face"
        face.position.x = 2
        face.position.y = 84
        
        man.xScale = 0.25
        man.yScale = 0.3
        
        if location.x < 160{
            man.position.x = -25
            man.name = "man0"
            man.run(SKAction.moveTo(x: manPositionX[0], duration: 0.5))
        }else{
            man.position.x = 345
            man.name = "man5"
            man.run(SKAction.moveTo(x: manPositionX[5], duration: 0.5))
        }
        
        man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
        man.physicsBody?.categoryBitMask = 1
        man.physicsBody?.contactTestBitMask = 4294967295
        man.physicsBody?.isDynamic = false
        face.physicsBody = SKPhysicsBody(rectangleOf: face.size)
        face.physicsBody?.categoryBitMask = 1
        face.physicsBody?.contactTestBitMask = 4294967295
        face.physicsBody?.isDynamic = false
    }
    
    func oldManMove(old: SKSpriteNode){
        let moveRight = SKAction.moveTo(x: 280, duration: 8)
        let flipLeft = SKAction.run {
            old.xScale = -1
        }
        let moveLeft = SKAction.moveTo(x: 30, duration: 8)
        let flipRight = SKAction.run {
            old.xScale = 1
        }
        
        old.run(SKAction.repeatForever(SKAction.sequence([moveRight,
                                                          flipLeft,
                                                          moveLeft,
                                                          flipRight])))
        
        let wait = SKAction.wait(forDuration: 4)
        let drop = SKAction.run {
            self.makeTooth(node: old)
        }
        
        old.run(SKAction.repeatForever(SKAction.sequence([wait,
                                                          drop])))
    }
    
    func robberArrive(){
        let robber = textureToNode(name: "robber")
        addChild(robber)
        
        robber.zPosition = 4
        robber.position.y = 58
        robber.name = "robber"
        
        let rand = arc4random_uniform(100)
        
        if rand < 50{
            robber.position.x = -12.5
        }else{
            robber.position.x = 332.5
        }
        
        let action = SKAction.run {
            var robbedMoney = 200
            
            if self.moneyCollected < 200{
                robbedMoney = self.moneyCollected
            }
            
            self.addText(node: robber, t: "-\(robbedMoney)", color: UIColor.red)
            
            self.moneyCollected -= robbedMoney
            robber.removeFromParent()
        }
        
        robber.run(SKAction.sequence([SKAction.moveTo(x: 160, duration: 5), action]))
        
    }
    
}
