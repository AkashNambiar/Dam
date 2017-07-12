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
    case glue, cement, tape, wood
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
    
    var num = 0
    var frequency = 100
    
    let cementArea: SKSpriteNode = SKSpriteNode()
    var cement = false
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    var cracks: [Crack] = []
    var cracksPositon: [CGPoint] = []
    
    var coolingDown = false
    var windowContains = false
    
    var scoreLabel: SKLabelNode!
    var trashButton: MSButtonNode!
    var waitBar: SKSpriteNode!
    var returnButton: MSButtonNode!
    var specialButton: MSButtonNode!
    //var damArea: SKSpriteNode!
    
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
        //        damArea = childNode(withName: "damArea") as! SKSpriteNode
        
        trashButton.selectedHandler = {
            self.removeTool()
            self.addRandomTool()
            self.displayTools()
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
                return
            }
            
            if nodeName == "box2" {
                let point = addPointer()
                point.position.x = 205.6
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 1
                return
            }
            
            if coolingDown == false {
                if getCurrentTool() == .cement {
                    if nodeName == "wallArea" || nodeName == "crack" || ((nodeName?.substring(to: nodeName!.index(nodeName!.startIndex, offsetBy: 5))) == "window"){
                        cement = true
                        
                        addChild(cementArea)
                        
                        cementArea.zPosition = 1
                        cementArea.color = UIColor.red
                        cementArea.alpha = 0.5
                        cementArea.size.height = 75
                        cementArea.size.width = 75
                        cementArea.position.x = location.x
                        cementArea.position.y = location.y + 50
                    }
                }else if nodeName == "crack"{
                    for i in 1 ... 6{
                        if (childNode(withName: "window\(i)")?.contains(nodeAtPoint.position))!{
                            if getCurrentTool() != .wood{
                                windowContains = true
                            }
                        }
                    }
                  
                    if cracks.contains(nodeAtPoint as! Crack){
                        if windowContains == false{
                            removeCrack(nodeAtPoint: nodeAtPoint)
                            
                            //                      coolDown()
                            removeTool()
                            addRandomTool()
                            displayTools()
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if cement{
            let touch = touches.first!
            let location = touch.location(in: self)
            
            cementArea.position.x = location.x
            cementArea.position.y = location.y + 50
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
            removeTool()
            addRandomTool()
            displayTools()
        }
        
        windowContains = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentState == .playing {
            if cracks.count > 98457 {
                gameOver()
            }
            
            if num >= frequency {
                addCrack()
                num = 0
            }else{
                num += 1
            }
        }
    }
    
    func beginFunc() {
        returnButton.isHidden = true
        
        let pointer = point()
        addChild(pointer)
        
        pointer.xScale = 1.5
        pointer.yScale = 1.5
        
        pointer.position.x = 114.4
        pointer.position.y = 138
        
        previousPointer = pointer
        
        addRandomTool()
        addRandomTool()
        addRandomTool()
        
        displayTools()
    }
    
    func addCrack() {
        
        let crack = Crack()
        addChild(crack)
        
        crack.zPosition = 1
        crack.xScale = 1
        crack.yScale = 1
        
        var randPosition: CGPoint = CGPoint(x: 0, y: 0)
        
        randPosition.x = CGFloat(arc4random_uniform(UInt32(320 - crack.size.width)))
        
        while randPosition.x < CGFloat(crack.size.width) {
            randPosition.x = CGFloat(arc4random_uniform(UInt32(320 - crack.size.width)))
        }
        
        randPosition.y = CGFloat(arc4random_uniform(UInt32(470 - crack.size.height)))
        
        while randPosition.y < CGFloat(150 + crack.size.height) {
            randPosition.y = CGFloat(arc4random_uniform(UInt32(470 - crack.size.height)))
        }
        
        crack.position.x = CGFloat(randPosition.x)
        crack.position.y = CGFloat(randPosition.y)
        
        crack.run(SKAction.colorize(with: UIColor.black, colorBlendFactor: 3, duration: 0.1))
    
        crack.name = "crack"
        cracks.append(crack)
        cracksPositon.append(randPosition)
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
        var newTool: SKSpriteNode = Glue()
        
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
        }
        
        newTool.position.x = toolX[i]
        newTool.position.y = toolY[i]
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        var i = Int(arc4random_uniform(4))
        i = 0
        var randTool: tools = .cement
        
        if i == 0 {
            randTool = .cement
        }else if i == 1{
            randTool = .glue
        }else if i == 2{
            randTool = .tape
        }else if i == 3{
            randTool = .wood
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
            duration = 3
        case .glue:
            duration = 2
        case .tape:
            duration = 1
        case .wood:
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
            
            guard let scene = GameScene(fileNamed:"GameScene") as GameScene! else { return }
            
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

}
