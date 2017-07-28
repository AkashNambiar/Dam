//
//  GameScene.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//
//https://opengameart.org/content/64x-textures-an-overlays
//
//LIFETIME CRACKS REMOVED

import SpriteKit
import Foundation

class buildingScene: SKScene, SKPhysicsContactDelegate {
    
    enum tools {
        case glue, cement, tape, wood, lock, portal, wall, ice, health
    }
    
    enum playingState{
        case playing, notPlaying, tutorial
    }
    
    var scoreLabel: SKLabelNode!
    var trashButton: MSButtonNode!
    var waitBar: SKSpriteNode!
    var currentTool: SKLabelNode!
    var b1: SKSpriteNode!
    var b2: SKSpriteNode!
    var returnButton: MSButtonNode!
    
    var currentState: playingState = .playing
    
    var toolList: [tools] = []
    var toolPics: [SKSpriteNode] = []
    var specialTool: tools!
    
    var men = [0, 0, 0, 0, 0, 0]
    
    var openWindowX: [CGFloat] = []
    var openWindowY: [CGFloat] = []
    var manPositionX: [CGFloat] = [17.5, 55, 92.5, 227.5, 265, 302.5]
    var manPositionY: CGFloat = 55
    var leftMan: CGPoint = CGPoint(x: 227.5, y: 55)
    var rightMan: CGPoint = CGPoint(x: 92.5, y: 55)
    
    var num = 0
    var other = 0
    var frequency = 120
    var peopleLeft = 0
    var offTheWall: CGFloat = 2.5
    var freezeTime: TimeInterval = 5
    
    var nodeAboveTouch: CGFloat = 0
    var halfCementSize: CGFloat = 0
    var halfTapeSize: CGFloat = 0
    var halfPortalHeight: CGFloat = 0
    var halfPortalWidth: CGFloat = 0
    var gameTop: CGFloat = 485
    var gameBottom: CGFloat = 155
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
    var tutorialInProgress = true
    var manMovingInside = false
    
    var crackStart = NSDate()
    var crackInterval: TimeInterval = 4
    var oldManMoveStart = NSDate()
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    var previousNode: SKSpriteNode = SKSpriteNode()
    
    var cracks: [Crack] = []
    var cracksPositon: [CGPoint] = []
    
    let coolDownLabel: SKLabelNode = SKLabelNode()
    var coolingDown = false
    var ifPressedTwice = false
    
    var windowContains = false
    var windows: [Window] = []
    var windowsPosition: [Int] = []
    
    var emptyArray: [Bool] = []
    var colors: [UIColor] = [UIColor.blue, UIColor.green, UIColor.red, UIColor.magenta, UIColor.orange, UIColor.yellow]
    
    var moneyCollected = 0
    var Score: Int = 0 {
        didSet {
            scoreLabel.text = String(Score)
        }
    }
    
    override func didMove(to view: SKView) {
        scoreLabel = childNode(withName: "score") as! SKLabelNode
        trashButton = childNode(withName: "trashButton") as! MSButtonNode
        waitBar = childNode(withName: "waitBar") as! SKSpriteNode
        currentTool = childNode(withName: "currentTool") as! SKLabelNode
        b1 = childNode(withName: "b1") as! SKSpriteNode
        b2 = childNode(withName: "b2") as! SKSpriteNode
        returnButton = childNode(withName: "//returnButton") as! MSButtonNode
        
        trashButton.selectedHandler = {
            if self.currentState == .playing{
                self.removeTool()
                self.addRandomTool()
                self.displayTools()
                self.currentTool.text = self.getNameOfCurrentTool()
            }
        }
        
        returnButton.isHidden = true
        
        physicsWorld.contactDelegate = self
        
        beginFunc()
    }
    
    func beginFunc() {
        
        for i in 0 ... 5{
            let man = Man()
            addChild(man)
            
            man.name = "man\(i)"
            man.position.x = manPositionX[i]
            man.position.y = manPositionY
            man.zPosition = 3
            man.size.height = 35
            man.size.width = 25
            
            man.physicsBody =  SKPhysicsBody(rectangleOf: man.size)
            man.physicsBody?.categoryBitMask = 1
            man.physicsBody?.contactTestBitMask = 4294967295
            man.physicsBody?.isDynamic = false
            
            //            man.run(SKAction.colorize(with: colors[i], colorBlendFactor: 1, duration: 0.01))
            
            men[i] = 1
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
        
        for i in 1 ... buildingMenu.numberWindows{
            let window = childNode(withName: "window\(i)")
            
            openWindowX.append((window?.position.x)!)
            openWindowY.append((window?.position.y)!)
        }
        
        let pointer = addPointer(box: b1)
        previousPointer = pointer
        
        addRandomTool()
        addRandomTool()
        
        displayTools()
        
        currentTool.text = getNameOfCurrentTool()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentState == .playing && cement == false && tape == false && portal == false{
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
                    if nodeName == "openWindow" || (nodeName?.hasPrefix("oldMan"))!{
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
                        
                        coolDown()
                        removeTool()
                        addRandomTool()
                        displayTools()
                        currentTool.text = getNameOfCurrentTool()
                    }else if nodeName == "crack"{
                        coolDownLabel.text = "LOCKS CLOSE WINDOWS"
                        coolDownLabel.fontName = "Didot Bold"
                        coolDownLabel.fontSize = 30
                        coolDownLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.6, duration: 0.01))
                        
                        coolDownLabel.name = "coolDown"
                        coolDownLabel.position.x = 160
                        coolDownLabel.position.y = 400
                        coolDownLabel.zPosition = 5
                        
                    }
                }else if getCurrentTool() == .cement {
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        cement = true
                        
                        addChild(cementArea)
                        
                        cementArea.name = "cementArea"
                        cementArea.zPosition = 0
                        cementArea.color = UIColor.red
                        cementArea.alpha = 0.5
                        cementArea.size.height = 80
                        cementArea.size.width = 80
                        cementArea.anchorPoint.x = 0.5
                        cementArea.anchorPoint.y = 0.5
                        halfCementSize = cementArea.size.height/2
                        
                        if location.y > (gameTop - halfCementSize) - nodeAboveTouch{
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
                        }
                    }
                }else if getCurrentTool() == . tape{
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        tape = true
                        
                        addChild(tapeArea)
                        
                        tapeArea.name = "tapeArea"
                        tapeArea.zPosition = 0
                        tapeArea.color = UIColor.red
                        tapeArea.alpha = 0.5
                        tapeArea.size.height = 30
                        tapeArea.size.width = 320
                        tapeArea.anchorPoint.x = 0.5
                        tapeArea.anchorPoint.y = 0.5
                        tapeArea.position.x = 160
                        halfTapeSize = tapeArea.size.height/2
                        
                        if location.y > (gameTop - halfTapeSize) - nodeAboveTouch{
                            tapeArea.position.y = gameTop - halfTapeSize
                        }else if location.y < gameBottom + halfTapeSize - nodeAboveTouch{
                            tapeArea.position.y = gameBottom + halfTapeSize
                        }else{
                            tapeArea.position.y = location.y + nodeAboveTouch
                        }
                        
                    }
                }else if getCurrentTool() == .portal{
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        portal = true
                        
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
                        
                    }
                    
                }else if getCurrentTool() == .wall{
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        newWall = true
                        
                        addChild(newWallArea)
                        
                        newWallArea.name = "newWallArea"
                        newWallArea.size.height = 330
                        newWallArea.size.width = 320
                        newWallArea.color = UIColor.red
                        newWallArea.alpha = 0.5
                        newWallArea.position.x = 160
                        newWallArea.position.y = 320
                    }
                }else if getCurrentTool() == .ice{
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        
                        let node = nodes(at: location)
                        
                        for i in node{
                            if i.name == "oldManMoving"{
                                
                                i.removeAllActions()
                                
                                i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0.01))
                                
                                let wait = SKAction.wait(forDuration: freezeTime)
                                let code = SKAction.run {
                                    i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 0, duration: 0))
                                    self.oldManMove(old: i as! SKSpriteNode)
                                }
                                
                                i.run(SKAction.sequence([wait, code]))
                            }else if i.name == "oldMan"{
                                
                                if i.hasActions(){
                                    i.removeAllActions()
                                    
                                    i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0.01))
                                    
                                    let wait = SKAction.wait(forDuration: freezeTime)
                                    let action = SKAction.repeatForever(SKAction.sequence([SKAction.run{
                                        i.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 0, duration: 0))
                                        },SKAction.wait(forDuration: 1.5),
                                          SKAction.run {
                                            self.makeTooth(node: i as! SKSpriteNode)
                                        }]))
                                    
                                    i.run(SKAction.sequence([wait, action]))
                                }
                                
                            }else if i.name == "crack"{
                                
                                if i.hasActions(){
                                    i.removeAllActions()
                                    
                                    i.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0.01))
                                    
                                    let wait = SKAction.wait(forDuration: freezeTime)
                                    let action = SKAction.repeatForever(SKAction.sequence([SKAction.run{
                                        i.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0))
                                        },SKAction.wait(forDuration: 1.5),
                                          SKAction.run {
                                            self.dropBrick(node: i as! SKSpriteNode)
                                        }]))
                                    
                                    i.run(SKAction.sequence([wait, action]))
                                }
                            }
                            
                        }
                    }
                }else if getCurrentTool() == .health{
                    if (nodeName?.hasPrefix("man"))!{
                        let node = childNode(withName: nodeName!) as! Man
                        
                        node.timesHit = 0
                        
                        node.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0, duration: 0))
                    }
                }else if nodeName == "crack"{
                    if cracks.contains(nodeAtPoint as! Crack){
                        if tutorialInProgress{
                            removeCrack(nodeAtPoint: nodeAtPoint)
                            
                            coolDown()
                            removeTool()
                            addRandomTool()
                            displayTools()
                            currentTool.text = getNameOfCurrentTool()
                        }else{
                            removeCrack(nodeAtPoint: nodeAtPoint)
                            
                            tutorialInProgress = true
                        }
                    }
                }
            }else{
                if location.y > gameBottom && location.y < gameTop{
                    if ifPressedTwice == false{
                        ifPressedTwice = true
                        addChild(coolDownLabel)
                        
                        coolDownLabel.text = "COOLING DOWN"
                        coolDownLabel.fontName = "Didot Bold"
                        coolDownLabel.fontSize = 36
                        coolDownLabel.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.6, duration: 0.01))
                        
                        coolDownLabel.name = "coolDown"
                        coolDownLabel.position.x = 160
                        coolDownLabel.position.y = 400
                        coolDownLabel.zPosition = 5
                    }
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
            addChild(tapeRoll)
            
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
        
        windowContains = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentState == .tutorial && tutorialInProgress{
            tutorial()
        }else{
            if coolingDown == false{
                coolDownLabel.removeFromParent()
                ifPressedTwice = false
            }
            
            if currentState == .playing {
                
                shouldMovePerson()
                
                for portal in portals{
                    let end = NSDate()
                    let time = end.timeIntervalSince(portal.start as Date)
                    
                    if time > 5{
                        portal.removeFromParent()
                    }
                }
                /*
                 for crack in cracks{
                 let end = NSDate()
                 let time: Double = end.timeIntervalSince(crack.start as Date)
                 
                 if time > 3.5{
                 dropBrick(node: crack)
                 crack.start = NSDate()
                 }
                 }*/
                /*
                 for i in 0 ... 5{
                 let node = self.childNode(withName: "man\(i)")
                 
                 node?.run(SKAction.colorize(with: self.colors[i], colorBlendFactor: 1, duration: 0.01))
                 }*/
                
                let end = NSDate()
                let time = end.timeIntervalSince(crackStart as Date)
                
                if time > crackInterval{
                    addCrack()
                    crackStart = NSDate()
                    
                    
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
            
            if (nodeB.name?.hasPrefix("man"))! || (nodeA.name?.hasPrefix("man"))! {
                if (nodeA.name?.hasPrefix("man"))!{
                    contactManSomething(man: nodeA, something: nodeB)
                }else{
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
                    waitToRemove(node: nodeB, time: 0.0 )
                }
            }
            
        }
    }
    
    func tutorial() {
        tutorialInProgress = false
        addCrack()
        
        let tapCrackToRemove: SKLabelNode = SKLabelNode()
        addChild(tapCrackToRemove)
        
        for crack in cracks{
            tapCrackToRemove.text = "Tap Crack To Remove"
            tapCrackToRemove.fontSize = 20
            tapCrackToRemove.zPosition = 4
            tapCrackToRemove.position.x = crack.position.x
            tapCrackToRemove.position.y = crack.position.y + 25
            tapCrackToRemove.run(SKAction.colorize(with: UIColor.blue, colorBlendFactor: 1, duration: 0.1))
        }
        
    }
    
    func shouldMovePerson() {
        if manMovingInside == false{
            if Score >= 5 {
                if Score % 10 == 0{
                    if scoreChanged{
                        movePersonInside(movingMan: leftMan)
                        scoreChanged = false
                        self.manMovingInside = true
                    }
                }else if Score % 5 == 0 {
                    if scoreChanged{
                        movePersonInside(movingMan: rightMan)
                        scoreChanged = false
                        self.manMovingInside = true
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
                                                                self.dropBrick(node: crack)
            }])))
        
        cracks.append(crack)
        cracksPositon.append(randPosition)
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
        cracksPositon.remove(at: index)
        
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
        }
        
        newTool.size = size
        newTool.zPosition = 1
        newTool.position = position
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        let userDefaults = UserDefaults.standard
        let firstTime: [Bool] = userDefaults.array(forKey: "unlockedTools") as? [Bool] ?? emptyArray
        
        var unlockedTools: [Bool] = []
        
        if firstTime.count == 0{
            userDefaults.set(toolsMenu.unlocked, forKey: "unlockedTools")
            unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        }else{
            unlockedTools = userDefaults.array(forKey: "unlockedTools") as! [Bool]
        }
        
        var i = Int(arc4random_uniform(UInt32(unlockedTools.count)))
        
        while unlockedTools[i] == false{
            i = Int(arc4random_uniform(UInt32(unlockedTools.count)))
        }
        
        var randTool: tools = .cement
        
        switch i {
        case 0:
            randTool = .glue
        case 1:
            randTool = .cement
        case 2:
            randTool = .tape
        case 3:
            randTool = .wood
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
        default:
            randTool = .glue
        }
        
        toolList.append(randTool)
    }
    
    func removeTool() {
        toolList.remove(at: pointerPosition)
        for i in 0 ... toolPics.count - 1{
            toolPics[i].removeFromParent()
        }
        toolPics.removeAll()
    }
    
    func addPointer(box: SKSpriteNode) -> SKNode{
        
        let pointer = textureToNode(name: "pointer")
        addChild(pointer)
        
        let x = box.position.x
        let y = box.position.y
        
        pointer.name = "point"
        pointer.xScale = 1.5
        pointer.yScale = 1.5
        pointer.zPosition = 2
        
        pointer.position.x = x
        pointer.position.y = y + 30
        
        return pointer
    }
    
    func changeWaitingState() {
        coolingDown = false
        waitBar.xScale = 0.75
    }
    
    func curentWaitTime() -> TimeInterval{
        let currentTool = getCurrentTool()
        var duration: TimeInterval = 1
        
        switch currentTool {
        case .cement:
            duration = 0.5
        case .glue:
            duration = 0.5
        case .tape:
            duration = 0.5
        case .wood:
            duration = 0.5
        case .lock:
            duration = 0.5
        case .portal:
            duration = 0.5
        case .wall:
            duration = 1
        case .ice:
            duration = 1
        case .health:
            duration = 1
        }
        
        return duration
    }
    
    func coolDown() {
        coolingDown = true
        
        let duration: TimeInterval = curentWaitTime()
        let finalHeightScale: CGFloat = 0.0
        let scaleHeightAction = SKAction.scaleX(to: finalHeightScale, duration: TimeInterval(duration))
        let change = SKAction.run(changeWaitingState)
        
        waitBar.run(
            SKAction.sequence([scaleHeightAction, change])
        )
    }
    
    func gameOver() {
        currentState = .notPlaying
        
        returnButton.isHidden = false
        
        returnButton.selectedHandler = {
            let skView = self.view as SKView!
            
            guard let scene = GameScene(fileNamed:"buildingsMenu") as GameScene! else { return }
            
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
        windowsPosition.removeAll()
        
        let background = SKSpriteNode()
        addChild(background)
        
        background.size.height = 300
        background.size.width = 310
        background.position.x = 160
        background.position.y = 320
        background.zPosition = 5
        background.color = UIColor.purple
        
        let texture = SKTexture(imageNamed: "gameOver")
        let gameOverLabel = SKSpriteNode(texture: texture)
        addChild(gameOverLabel)
        
        gameOverLabel.size.height = 58
        gameOverLabel.size.width = 310
        gameOverLabel.position.x = 160
        gameOverLabel.position.y = 450
        gameOverLabel.zPosition = 6
        
        let finalMoney = SKLabelNode()
        addChild(finalMoney)
        
        finalMoney.text = "Money Collected: $\(moneyCollected)"
        finalMoney.fontName = "AvenirNext-Bold"
        finalMoney.fontSize = 25
        
        finalMoney.position = gameOverLabel.position
        finalMoney.position.y -= 75
        finalMoney.zPosition = 6
        finalMoney.color = UIColor.green
        
        let cracksRemoved = SKLabelNode()
        addChild(cracksRemoved)
        
        cracksRemoved.text = "Cracks Removed: \(Score)"
        cracksRemoved.fontName = "AvenirNext-Bold"
        cracksRemoved.fontSize = 20
        
        cracksRemoved.position = finalMoney.position
        cracksRemoved.position.y -= 75
        cracksRemoved.zPosition = 6
        cracksRemoved.color = UIColor.orange
        
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
        }
        
        return name
    }
    
    func openWindow() {
        var num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows)))
        
        while windowsPosition.contains(num){
            num = Int(arc4random_uniform(UInt32(buildingMenu.numberWindows)))
        }
        
        let window = Window()
        addChild(window)
        
        let man = textureToNode(name: "oldMan")
        addChild(man)
        
        window.name = "openWindow\(num)"
        window.zPosition = 2
        window.size.width = 60
        window.size.height = 60
        
        man.name = "oldMan\(num)"
        man.zPosition = 3
        man.size.width = 30
        man.size.height = 30
        
        window.position.x = openWindowX[num]
        window.position.y = openWindowY[num] - 10
        man.position.x = openWindowX[num] + 2.5
        man.position.y = openWindowY[num] - 5
        
        windows.append(window)
        windowsPosition.append(num)
        
        man.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 3),
                                                          SKAction.run {
                                                            self.dropTooth(node: man, num: num)
            }])))
    }
    
    func dropBrick(node: SKSpriteNode) {
        let brick = textureToNode(name: "singleBrick")
        addChild(brick)
        
        brick.name = "singleBrick"
        brick.position = node.position
        brick.zPosition = 2
        brick.xScale = 3
        brick.yScale = 3
        
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
        let tooth = textureToNode(name: "tooth")
        addChild(tooth)
        
        tooth.name = "tooth"
        tooth.position = node.position
        tooth.xScale = 0.75
        tooth.yScale = 0.75
        tooth.zPosition = 2
        
        let rand = arc4random_uniform(180)
        tooth.zRotation = CGFloat(rand)
        
        tooth.physicsBody = SKPhysicsBody(texture: tooth.texture!, size: tooth.size)
        tooth.physicsBody?.affectedByGravity = true
        tooth.physicsBody?.contactTestBitMask = 4294967295
        tooth.physicsBody?.categoryBitMask = 4
        tooth.physicsBody?.collisionBitMask = 3
    }
    
    func addText(node: SKSpriteNode, t: String) {
        let textLabel: SKLabelNode = SKLabelNode()
        addChild(textLabel)
        
        textLabel.text = "\(t)"
        textLabel.fontSize = 36
        
        textLabel.position.x = node.position.x
        textLabel.position.y = node.position.y + 75
        textLabel.zPosition = 3
        textLabel.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1))
        
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
            
            //            addText(node: man)
            waitToRemove(node: something, time: 0.0)
            
            let allNodes = nodes(at: man.position)
            var node: Man = childNode(withName: man.name!) as! Man
            
            for n in allNodes{
                if (n.name?.hasPrefix("man"))!{
                    node = n as! Man
                }
            }
            
            let time: TimeInterval = 1
            
            if node.timesHit >= 4{
                var f = 10
                var l = 10
                var needsToMove = true
                
                if node.name == "man1"{
                    f = 0
                    l = 0
                    
                    let person: SKSpriteNode = childNode(withName: "man1") as! SKSpriteNode
                    person.name = "left"
                    
                    let man: SKSpriteNode = childNode(withName: "man0") as! SKSpriteNode
                    man.name = "man1"
                    men[0] = 0
                    men[1] = 1
                    man.run(SKAction.moveTo(x: manPositionX[1], duration: 0.5))
                    
                }else if node.name == "man2"{
                    f = 0
                    l = 1
                    
                    let person: SKSpriteNode = childNode(withName: "man2") as! SKSpriteNode
                    person.name = "left"
                    
                    men[1] = 1
                    men[2] = 1
                    men[0] = 0
                    let man: SKSpriteNode = childNode(withName: "man0") as! SKSpriteNode
                    let man2: SKSpriteNode = childNode(withName: "man1") as! SKSpriteNode
                    man.name = "man1"
                    man2.name = "man2"
                    man.run(SKAction.moveTo(x: manPositionX[1], duration: 0.5))
                    man2.run(SKAction.moveTo(x: manPositionX[2], duration: 0.5))
                    
                }else if node.name == "man3"{
                    
                    let person: SKSpriteNode = childNode(withName: "man3") as! SKSpriteNode
                    person.name = "left"
                    
                    f = 4
                    l = 5
                    
                    men[3] = 1
                    men[4] = 1
                    men[5] = 0
                    let man: SKSpriteNode = childNode(withName: "man4") as! SKSpriteNode
                    let man2: SKSpriteNode = childNode(withName: "man5") as! SKSpriteNode
                    man.name = "man3"
                    man2.name = "man4"
                    man.run(SKAction.moveTo(x: manPositionX[3], duration: 0.5))
                    man2.run(SKAction.moveTo(x: manPositionX[4], duration: 0.5))
                    
                }else if node.name == "man4"{
                    f = 5
                    l = 5
                    
                    let person: SKSpriteNode = childNode(withName: "man4") as! SKSpriteNode
                    person.name = "left"
                    
                    men[5] = 0
                    men[4] = 1
                    let man: SKSpriteNode = childNode(withName: "man5") as! SKSpriteNode
                    man.name = "man4"
                    man.run(SKAction.moveTo(x: manPositionX[4], duration: 0.5))
                    
                }else{
                    needsToMove = false
                }
                
                if node.position.x >= 160 {
                    node.run(SKAction.moveTo(x: 320 + node.size.width, duration: time))
                    node.name = "left"
                    moveNewPerson(location: node.position)
                    if needsToMove{
                        //                            moveAllPeople(s: false, first: f, second: l)
                    }
                }else{
                    node.run(SKAction.moveTo(x: -node.size.width, duration: time))
                    node.name = "left"
                    moveNewPerson(location: node.position)
                    if needsToMove{
                        //                           moveAllPeople(s: true, first: f, second: l)
                    }
                }
                
                
                node.run(SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 1, duration: 0.1))
                
                waitToRemove(node: node, time: time)
                
                peopleLeft += 1
                
                if peopleLeft > 4{
                    gameOver()
                }
            }else{
                node.timesHit += 1
                node.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: node.colorBlendFactor + 0.25, duration: 0.1))
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
        let open = textureToNode(name: "openDoor")
        
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
                                        self.addText(node: man, t: "+\(moneyLost)")
                                        
                                        self.manMovingInside = false
            }]))
    }
    
    func movePersonInside(movingMan: CGPoint) {
        
        let node: [SKSpriteNode] = nodes(at: movingMan) as! [SKSpriteNode]
        var left = false
        
        if movingMan.x < 160{
            left = true
        }
        
        for man in node{
            if (man.name?.hasPrefix("man"))!{
                man.physicsBody = nil
                man.name = "person"
                
                man.run(SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.1))
                man.run(SKAction.sequence([SKAction.moveTo(x: 160, duration: 0.5),
                                           SKAction.run {
                                            self.openDoorClose(man: man)
                                            
                                            if left{
                                                //self.moveAllPeople(s: left, first: 0, second: 1)
                                                
                                                let man: SKSpriteNode = self.childNode(withName: "man0") as! SKSpriteNode
                                                let man2: SKSpriteNode = self.childNode(withName: "man1") as! SKSpriteNode
                                                man.name = "man1"
                                                man2.name = "man2"
                                                man.run(SKAction.moveTo(x: self.manPositionX[1], duration: 0.5))
                                                man2.run(SKAction.moveTo(x: self.manPositionX[2], duration: 0.5))
                                            }else{
                                                //self.moveAllPeople(s: left, first: 4, second: 5)
                                                let man: SKSpriteNode = self.childNode(withName: "man4") as! SKSpriteNode
                                                let man2: SKSpriteNode = self.childNode(withName: "man5") as! SKSpriteNode
                                                man.name = "man3"
                                                man2.name = "man4"
                                                man.run(SKAction.moveTo(x: self.manPositionX[3], duration: 0.5))
                                                man2.run(SKAction.moveTo(x: self.manPositionX[4], duration: 0.5))
                                            }
                                            
                                            self.moveNewPerson(location: movingMan)
                    }]))
            }
        }
        
    }
    /*
     func moveAllPeople(s: Bool, first: Int, second: Int) {
     if s{
     for i in first ... second{
     let man: SKSpriteNode = childNode(withName: "man\(i)") as! SKSpriteNode
     
     man.name = "man\(i+1)"
     men[i+1] = 1
     
     man.run(SKAction.moveTo(x: manPositionX[i+1], duration: 0.5))
     }
     }else{
     for i in first ... second{
     let man: SKSpriteNode = childNode(withName: "man\(i)") as! SKSpriteNode
     man.name = "man\(i-1)"
     men[i-1] = 1
     
     man.run(SKAction.moveTo(x: manPositionX[i-1], duration: 0.5))
     }
     }
     
     for i in 0 ... 5{
     let node = childNode(withName: "man\(i)")
     
     node?.run(SKAction.colorize(with: colors[i], colorBlendFactor: 1, duration: 0.01))
     }
     }*/
    
    func moveNewPerson(location: CGPoint) {
        let man = Man()
        addChild(man)
        
        man.zPosition = 3
        man.size.height = 35
        man.size.width = 25
        man.position.y = manPositionY
        
        if location.x < 160{
            man.position.x = -25
            men[0] = 1
            man.name = "man0"
            man.run(SKAction.moveTo(x: manPositionX[0], duration: 0.5))
        }else{
            man.position.x = 345
            men[5] = 1
            man.name = "man5"
            man.run(SKAction.moveTo(x: manPositionX[5], duration: 0.5))
        }
        
        man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
        man.physicsBody?.categoryBitMask = 1
        man.physicsBody?.contactTestBitMask = 4294967295
        man.physicsBody?.isDynamic = false
        
        for i in 0 ... 5{
            
            if men[i] == 0{
                
                let man = Man()
                addChild(man)
                
                man.zPosition = 3
                man.size.height = 35
                man.size.width = 25
                man.position.y = manPositionY
                
                if location.x < 160{
                    man.position.x = -25
                    man.run(SKAction.moveTo(x: manPositionX[i], duration: 0.5))
                    man.name = "man\(i)"
                }else{
                    man.position.x = 345
                    man.run(SKAction.moveTo(x: manPositionX[i], duration: 0.5))
                    man.name = "man\(i)"
                }
                
                man.physicsBody = SKPhysicsBody(rectangleOf: man.size)
                man.physicsBody?.categoryBitMask = 1
                man.physicsBody?.contactTestBitMask = 4294967295
                man.physicsBody?.isDynamic = false
            }
        }
        
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
    
}
