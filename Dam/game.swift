//
//  GameScene.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//
//https://opengameart.org/content/64x-textures-an-overlays

import SpriteKit
import Foundation

class game: SKScene, SKPhysicsContactDelegate {
    
    enum tools {
        case glue, cement, tape, wood, lock
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
    
    var currentState: playingState = .playing
    
    var toolList: [tools] = []
    var toolPics: [SKSpriteNode] = []
    var specialTool: tools!
    
    var openWindowX: [CGFloat] = [75, 245, 75, 245, 75, 245]
    var openWindowY: [CGFloat] = [415, 415, 310, 310, 205, 205]
    var manPositionX: [CGFloat] = [17.5, 55, 92.5, 227.5, 265, 302.5]
    var manPositionY: CGFloat = 55
    
    var num = 0
    var other = 0
    var frequency = 50
    var offTheWall: CGFloat = 2.5
    
    var nodeAboveTouch: CGFloat = 0
    var halfCementSize: CGFloat = 0
    var halfTapeSize: CGFloat = 0
    var gameTop: CGFloat = 485
    var gameBottom: CGFloat = 155
    var gameRight: CGFloat = 320
    var gameLeft: CGFloat = 0
    
    let cementArea: SKSpriteNode = SKSpriteNode()
    let tapeArea: SKSpriteNode = SKSpriteNode()
    var cement = false
    var tape = false
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    //var firstCrack: Crack!
    var cracks: [Crack] = []
    var cracksPositon: [CGPoint] = []
    
    let coolDownLabel: SKLabelNode = SKLabelNode()
    var coolingDown = false
    var ifPressedTwice = false
    
    var windowContains = false
    var windows: [Window] = []
    var windowsPosition: [Int] = []
    
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
        
        trashButton.selectedHandler = {
            if self.currentState == .playing{
                self.removeTool()
                self.addRandomTool()
                self.displayTools()
                self.currentTool.text = self.getNameOfCurrentTool()
            }
        }
        
        physicsWorld.contactDelegate = self
        
        beginFunc()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentState == .playing{
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
                        
                        for i in 1...6{
                            if (childNode(withName: "noCracks\(i)")?.contains(location))!{
                                index = i - 1
                            }
                        }
                        print(index)
                        
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
                    }
                }else if getCurrentTool() == .cement {
                    if nodeName == "wallArea" || nodeName == "crack"  || nodeName == "openWindow" || (nodeName?.hasPrefix("window"))! || (nodeName?.hasPrefix("noCracks"))! || (nodeName?.hasPrefix("oldMan"))! {
                        cement = true
                        
                        addChild(cementArea)
                        
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
                }else if nodeName == "crack"{
                    if cracks.contains(nodeAtPoint as! Crack){
                        if windowContains == false{
                            removeCrack(nodeAtPoint: nodeAtPoint)
                            
                            coolDown()
                            removeTool()
                            addRandomTool()
                            displayTools()
                            currentTool.text = getNameOfCurrentTool()
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
                        coolDownLabel.color = UIColor.red
                        coolDownLabel.alpha = 0.6
                        
                        coolDownLabel.name = "coolDown"
                        coolDownLabel.position.x = 160
                        coolDownLabel.position.y = 400
                        coolDownLabel.zPosition = 5678956
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if cement{
            for crack in cracks{
                if cementArea.contains(crack.position){
                    removeCrack(nodeAtPoint: crack)
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
                }
            }
            
            coolDown()
            removeTool()
            addRandomTool()
            displayTools()
            currentTool.text = getNameOfCurrentTool()
        }
        
        windowContains = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentState == .tutorial {
            tutorial()
        }else{
            if coolingDown == false{
                coolDownLabel.removeFromParent()
                ifPressedTwice = false
            }
            
            if currentState == .playing {
                
                for crack in cracks{
                    let end = NSDate()
                    let time: Double = end.timeIntervalSince(crack.start as Date)
                    
                    if time > 4{
                        dropBrick(node: crack)
                        crack.start = NSDate()
//                        removeCrack(nodeAtPoint: crack)
                    }
                }
                
                if num >= frequency {
                    if other > 5{
                        openWindow()
                    }else{
                        addCrack()
                    }
                    
                    num = 0
                }else{
                    num += 1
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        let nodeA = contactA.node as! SKSpriteNode
        //       print(nodeA.name)
        let nodeB = contactB.node as! SKSpriteNode
        //     print(nodeB.name)
        
        if nodeA.name == "singlBrick" && nodeB.name == "singleBrick" {
            waitToRemove(node: nodeA, time: 1.5)
            waitToRemove(node: nodeB, time: 1.5)
            
        }else if nodeA.name == "singlBrick" || nodeB.name == "singleBrick"{
            
            if (nodeB.name?.hasPrefix("man"))! || (nodeA.name?.hasPrefix("man"))!{
                if (nodeA.name?.hasPrefix("man"))!{
                    contactManBrick(man: nodeA, brick: nodeB)
                }else{
                    contactManBrick(man: nodeB, brick: nodeA)
                }
            }else if nodeB.name == "ground" || nodeA.name == "ground"{
                
                if nodeA.name == "singleBrick"{
                    waitToRemove(node: nodeA, time: 1.5)
                }else{
                    waitToRemove(node: nodeB, time: 1.5)
                }
            }
        }
    }
    
    func beginFunc() {
        let pointer = addPointer(box: b1)
        previousPointer = pointer
        
        addRandomTool()
        addRandomTool()
        
        displayTools()
        
        currentTool.text = getNameOfCurrentTool()
        
        for i in 0 ... 5{
            let man = Man()
            addChild(man)
            
            man.name = "man\(i)"
            man.position.x = manPositionX[i]
            man.position.y = manPositionY
            man.zPosition = 1
            man.size.height = 35
            man.size.width = 25
            
            man.physicsBody =  SKPhysicsBody(rectangleOf: man.size)
            man.physicsBody?.categoryBitMask = 1
            man.physicsBody?.contactTestBitMask = 4294967295
            man.physicsBody?.isDynamic = false
        }
    }
    
    func tutorial() {
        
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
        
        for i in 1...6{
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
        
        if tool == .glue{
            newTool = textureToNode(name: "glue")
        }else if tool == .tape{
            newTool = textureToNode(name: "tape")
        }else if tool == .cement{
            newTool = textureToNode(name: "cement")
        }else if tool == .wood{
            newTool = textureToNode(name: "wood")
        }else if tool == .lock{
            newTool = textureToNode(name: "lock")
        }
        
        newTool.size = size
        newTool.zPosition = 1
        newTool.position = position
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        var i = Int(arc4random_uniform(5))
        var randTool: tools = .cement
        
        if i == 0 {
            randTool = .cement
        }else if i == 1{
            randTool = .glue
        }else if i == 2{
            randTool = .tape
        }else if i == 3{
            randTool = .wood
        }else if i == 4{
            randTool = .lock
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
        
        pointer.xScale = 1.5
        pointer.yScale = 1.5
        pointer.zPosition = 2
        
        pointer.position.x = x
        pointer.position.y = y + 20
        
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
            duration = 1.5
        case .glue:
            duration = 1
        case .tape:
            duration = 0.5
        case .wood:
            duration = 0.5
        case .lock:
            duration = 0.5
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
        
        let texture = SKTexture(imageNamed: "gameOver")
        let gameOverLabel = SKSpriteNode(texture: texture)
        
        addChild(gameOverLabel)
        
        gameOverLabel.size.height = 58
        gameOverLabel.size.width = 310
        gameOverLabel.position.x = 160
        gameOverLabel.position.y = 310
        gameOverLabel.zPosition = 10
        
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
        }
        
        return name
    }
    
    func openWindow() {
        var num = Int(arc4random_uniform(6))
        
        while windowsPosition.contains(num){
            num = Int(arc4random_uniform(6))
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
        man.size.width = 60
        man.size.height = 60
        
        window.position.x = openWindowX[num]
        window.position.y = openWindowY[num]
        man.position.x = openWindowX[num]
        man.position.y = openWindowY[num] - 5
        
        windows.append(window)
        windowsPosition.append(num)
        
        //        Score += 3
    }
    
    func movePeople() {
        
    }
    
    func dropBrick(node: SKSpriteNode) {
        let texture = SKTexture(imageNamed: "singleBrick")
        let brick = SKSpriteNode(texture: texture)
        
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
    
    func addText(node: SKSpriteNode) {
        let text: SKLabelNode = SKLabelNode()
        
        //        addChild(text)
        
        text.text = "OW"
        text.fontName = "Georgia"
        text.fontSize = 18
        
        text.position.x = node.position.x
        text.position.y = node.position.y + 20
        text.zPosition = 3
        
        let wait = SKAction.wait(forDuration: 3)
        let code = SKAction.run {
            text.removeFromParent()
        }
        
        text.run(
            SKAction.sequence([wait,code])
        )
    }
    
    func contactManBrick(man: SKSpriteNode, brick: SKSpriteNode) {
        addText(node: man)
        waitToRemove(node: brick, time: 0)
        
        let node: Man = childNode(withName: man.name!) as! Man
        let time: TimeInterval = 2
        
        if node.timesHit >= 4{
            if node.position.x >= 160 {
                node.run(SKAction.moveTo(x: 320 + node.size.width, duration: time))
            }else{
                node.run(SKAction.moveTo(x: -node.size.width, duration: time))
            }
            waitToRemove(node: node, time: time)
        }else{
            node.timesHit += 1
            node.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: node.colorBlendFactor + 0.25, duration: 0.1))
        }
    }
    
    func waitToRemove(node: SKSpriteNode, time: TimeInterval){
        node.run(SKAction.sequence([SKAction.wait(forDuration: time),
                                    SKAction.run {
                                        node.removeFromParent()
            }
            ])
        )
    }
    
}
