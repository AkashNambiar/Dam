//
//  GameScene.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit
import Foundation

enum tools {
    case glue, cement, tape, wood, lock
}

enum playingState{
    case playing, notPlaying
}

class GameScene: SKScene {
    
    var currentState: playingState = .playing
    
    var toolList: [tools] = []
    var toolPics: [SKSpriteNode] = []
    var specialTool: tools!
    
    var toolX: [CGFloat] = [115, 206, 282, 38]
    var toolY: [CGFloat] = [100, 100, 44, 44]
    var openWindowX: [CGFloat] = [83, 243, 83, 243, 83, 243]
    var openWindowY: [CGFloat] = [405, 405, 300, 300, 195, 195]
    
    var num = 0
    var frequency = 100
    var offTheWall: CGFloat = 2.5
    
    var nodeAboveTouch: CGFloat = 10
    var gameTop: CGFloat = 470
    var gameBottom: CGFloat = 150
    var gameRight: CGFloat = 320
    var gameLeft: CGFloat = 0
    
    let cementArea: SKSpriteNode = SKSpriteNode()
    let tapeArea: SKSpriteNode = SKSpriteNode()
    var cement = false
    var tape = false
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    var cracks: [Crack] = []
    var cracksPositon: [CGPoint] = []
    
    let coolDownLabel: SKLabelNode = SKLabelNode()
    var coolingDown = false
    var ifPressedTwice = false
    
    var windowContains = false
    var windows: [Window] = []
    var windowsPosition: [Int] = []
    
    var scoreLabel: SKLabelNode!
    var trashButton: MSButtonNode!
    var waitBar: SKSpriteNode!
    var returnButton: MSButtonNode!
    var specialButton: MSButtonNode!
    var currentTool: SKLabelNode!
    
    var Score: Int = 0 {
        didSet {
            scoreLabel.text = String(Score)
        }
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel = childNode(withName: "score") as! SKLabelNode
        trashButton = childNode(withName: "trashButton") as! MSButtonNode
        waitBar = childNode(withName: "waitBar") as! SKSpriteNode
        returnButton = childNode(withName: "//returnButton") as! MSButtonNode
        specialButton = childNode(withName: "specialButton") as! MSButtonNode
        currentTool = childNode(withName: "currentTool") as! SKLabelNode
        
        trashButton.selectedHandler = {
            if self.currentState == .playing{
                self.removeTool()
                self.addRandomTool()
                self.displayTools()
                self.currentTool.text = self.getNameOfCurrentTool()
            }
        }
        
        specialButton.selectedHandler = {
            let tool = self.getCurrentTool()
            self.specialTool = tool
            self.removeTool()
            self.addRandomTool()
            self.displayTools()
            self.displayTool(tool: tool, i: 3)
        }
        
        beginFunc()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentState == .playing{
            let touch = touches.first!
            let location = touch.location(in: self)
            let nodeAtPoint = atPoint(location)
            let nodeName = nodeAtPoint.name
            
            if nodeName == "box1" {
                let point = addPointer()
                point.position.x = 114.4
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 0
                currentTool.text = getNameOfCurrentTool()
                return
            }
            
            if nodeName == "box2" {
                let point = addPointer()
                point.position.x = 205.6
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 1
                currentTool.text = getNameOfCurrentTool()
                return
            }
            
            
            
            if coolingDown == false {
                
                if getCurrentTool() == .lock{
                    if nodeName == "openWindow"{
                        let window = childNode(withName: "openWindow")
                        
                        let index = windows.index(of: window as! Window)
                        windows.remove(at: index!)
                        windowsPosition.remove(at: index!)
                        
                        window?.removeFromParent()
                    }
                }else if getCurrentTool() == .cement {
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("window"))!{
                        cement = true
                        
                        addChild(cementArea)
                        
                        cementArea.zPosition = 1
                        cementArea.color = UIColor.red
                        cementArea.alpha = 0.5
                        cementArea.size.height = 80
                        cementArea.size.width = 80
                        cementArea.anchorPoint.x = 0
                        cementArea.anchorPoint.y = 0
                        
                        if location.y > (gameTop - cementArea.size.height) - nodeAboveTouch{
                            cementArea.position.y = gameTop - cementArea.size.height
                        }else{
                            cementArea.position.y = location.y + nodeAboveTouch
                        }
                        
                        if location.x < gameLeft + (cementArea.size.width/2) {
                            cementArea.position.x = gameLeft
                        }else if location.x > gameRight - (cementArea.size.width/2){
                            cementArea.position.x = gameRight - cementArea.size.width
                        }else{
                            cementArea.position.x = location.x - (cementArea.size.width/2)
                        }
                    }
                }else if getCurrentTool() == . tape{
                    if nodeName == "wallArea" || nodeName == "crack"  || (nodeName?.hasPrefix("window"))!{
                        tape = true
                        
                        addChild(tapeArea)
                        
                        tapeArea.zPosition = 1
                        tapeArea.color = UIColor.red
                        tapeArea.alpha = 0.5
                        tapeArea.size.height = 30
                        tapeArea.size.width = 320
                        tapeArea.anchorPoint.x = 0
                        tapeArea.anchorPoint.y = 0
                        tapeArea.position.x = 0
                        if location.y > (gameTop - tapeArea.size.height) - nodeAboveTouch{
                            tapeArea.position.y = gameTop - tapeArea.size.height
                        }else{
                            tapeArea.position.y = location.y + nodeAboveTouch
                        }
                    }
                }else if nodeName == "crack"{
                    /*                    for i in 1 ... 6{
                     if (childNode(withName: "window\(i)")?.contains(nodeAtPoint.position))!{
                     if getCurrentTool() != .wood{
                     windowContains = true
                     }
                     }
                     }
                     */
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
                        coolDownLabel.alpha = 0.6
                        
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
            if location.x < gameLeft + (cementArea.size.width/2) {
                cementArea.position.x = gameLeft
            }else if location.x > gameRight - (cementArea.size.width/2){
                cementArea.position.x = gameRight - cementArea.size.width
            }else{
                cementArea.position.x = location.x - (cementArea.size.width/2)
            }
            
            if location.y > (gameTop - cementArea.size.height) - nodeAboveTouch{
                cementArea.position.y = gameTop - cementArea.size.height
            }else if location.y < gameBottom - nodeAboveTouch{
                cementArea.position.y = gameBottom
            }else{
                cementArea.position.y = location.y + nodeAboveTouch
            }
            
        }
        if tape{
            if location.y > (gameTop - tapeArea.size.height) - nodeAboveTouch{
                tapeArea.position.y = gameTop - tapeArea.size.height
            }else if location.y < gameBottom - nodeAboveTouch{
                tapeArea.position.y = gameBottom
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
            let tapeRoll = rollTape()
            addChild(tapeRoll)
            
            tapeRoll.name = "tapeRoll"
            tapeRoll.anchorPoint.x = 0.5
            tapeRoll.anchorPoint.y = 0.5
            tapeRoll.zPosition = 3
            tapeRoll.size.height = 30
            tapeRoll.size.width = 30
            tapeRoll.position.x = -30
            tapeRoll.position.y = tapeArea.position.y + 15
            
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
        
        if coolingDown == false{
            coolDownLabel.removeFromParent()
            ifPressedTwice = false
        }
        
        if currentState == .playing {
            if cracks.count > 5 {
                //                gameOver()
            }
            
            if num >= frequency {
                if num > 4{
                    openWindow()
                    num = 0
                }else{
                    addCrack()
                    num += 1
                }
            }
        }
    }
    
    func beginFunc() {
        returnButton.isHidden = true
        
        let pointer = point()
        addChild(pointer)
        
        pointer.xScale = 1.5
        pointer.yScale = 1.5
        pointer.zPosition = 2
        
        pointer.position.x = 114.4
        pointer.position.y = 138
        
        previousPointer = pointer
        
        addRandomTool()
        addRandomTool()
        addRandomTool()
        
        displayTools()
        
        currentTool.text = getNameOfCurrentTool()
    }
    
    func addCrack() {
        
        let crack = Crack()
        
        crack.zPosition = 1
        crack.xScale = 1
        crack.yScale = 1
        
        var randPosition = randCrackPosition(crack: crack)
        
        while randPosition.x == 1000 || randPosition.y == 100 {
            randPosition = randCrackPosition(crack: crack)
        }
        
        crack.position.x = CGFloat(randPosition.x)
        crack.position.y = CGFloat(randPosition.y)
        
        addChild(crack)
        crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0.1))
        
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
        for i in 0 ... 2 {
            let tool = toolList[i]
            displayTool(tool: tool, i: i)
        }
    }
    
    func displayTool(tool: tools, i: Int) {
        var newTool: SKSpriteNode = glueTool()
        
        if tool == .glue{
            newTool = glueTool()
            newTool.xScale = 0.8
            newTool.yScale = 0.8
        }else if tool == .tape{
            newTool = tapeTool()
            newTool.xScale = 2.5
            newTool.yScale = 2.5
        }else if tool == .cement{
            newTool = cementTool()
            newTool.size.height = 40
            newTool.size.width = 40
        }else if tool == .wood{
            newTool = woodTool()
            newTool.xScale = 0.5
            newTool.yScale = 0.5
        }else if tool == .lock{
            newTool = lockTool()
            newTool.size.height = 40
            newTool.size.width = 40
        }
        
        newTool.zPosition = 1
        newTool.position.x = toolX[i]
        newTool.position.y = toolY[i]
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        var i = Int(arc4random_uniform(5))
        i = 4
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
    
    func addPointer() -> SKNode{
        previousPointer.removeFromParent()
        
        let pointer = point()
        addChild(pointer)
        
        pointer.xScale = 1.5
        pointer.yScale = 1.5
        pointer.zPosition = 2
        
        pointer.position.x = 114.4
        pointer.position.y = 138
        
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
            SKAction.sequence([scaleHeightAction,  change])
        )
    }
    
    func gameOver() {
        currentState = .notPlaying
        
        returnButton.isHidden = false
        
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
        
        returnButton.selectedHandler = {
            let skView = self.view as SKView!
            
            guard let scene = GameScene(fileNamed:"MainMenu") as GameScene! else { return }
            
            scene.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
    }
    
    func getCurrentTool() -> tools {
        return toolList[pointerPosition]
    }
    
    func woodTool() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "wood")
        return SKSpriteNode(texture: texture)
    }
    
    func glueTool() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "glue")
        return SKSpriteNode(texture: texture)
    }
    
    func cementTool() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "cement")
        return SKSpriteNode(texture: texture)
    }
    
    func tapeTool() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "tape")
        return SKSpriteNode(texture: texture)
    }
    
    func lockTool() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "lock")
        return SKSpriteNode(texture: texture)
    }
    
    func basicCrack() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "cracks")
        return SKSpriteNode(texture: texture)
    }
    
    func rollTape() -> SKSpriteNode{
        let texture = SKTexture(imageNamed: "tapeRoll")
        return SKSpriteNode(texture: texture)
    }
    
    func point() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "pointer")
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
        
        window.name = "openWindow"
        window.zPosition = 2
        window.size.width = 70
        window.size.height = 70
        
        window.position.x = openWindowX[num]
        window.position.y = openWindowY[num]
        
        windows.append(window)
        windowsPosition.append(num)
    }
    
    func waitForTape(node: SKSpriteNode) {
        print(0)
        for crack in cracks{
            if node.contains(crack.position){
                removeCrack(nodeAtPoint: crack)
            }
        }
        print(1)
    }
}
