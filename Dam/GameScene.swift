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
    case glue, cement, tape
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
    
    var pointerPosition = 0
    var previousPointer: SKNode!
    
    var cracks: [Crack] = []
    var cracksPositon: [CGPoint] = []
    
    var coolingDown = false
    
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
            let tool = self.toolList[self.pointerPosition]
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
            
            if nodeAtPoint.name == "box1" {
                let point = addPointer()
                point.position.x = 114.4
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 0
                return
            }
            
            if nodeAtPoint.name == "box2" {
                let point = addPointer()
                point.position.x = 205.6
                previousPointer.removeFromParent()
                previousPointer = point
                pointerPosition = 1
                return
            }
            
//            if nodeAtPoint.name == "damArea" {return}
            
            if coolingDown == false {
                if toolList[pointerPosition] == .cement && nodeAtPoint.name == "damArea"{
                    
                }
                
                if nodeAtPoint.name == "crack"{
                    if cracks.contains(nodeAtPoint as! Crack){
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
        
        crack.zPosition = 0
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
            newTool = Glue()
            newTool.xScale = 0.8
            newTool.yScale = 0.8
        }else if tool == .tape{
            newTool = Tape()
            newTool.xScale = 2.5
            newTool.yScale = 2.5
        }else if tool == .cement{
            newTool = Cement()
            newTool.size.height = 40
            newTool.size.width = 40
        }
        
        newTool.position.x = toolX[i]
        newTool.position.y = toolY[i]
        
        addChild(newTool)
        toolPics.append(newTool)
    }
    
    func addRandomTool() {
        let i = Int(arc4random_uniform(3))
        var randTool: tools = .cement
        
        if i == 0 {
            randTool = .cement
        }else if i == 1{
            randTool = .glue
        }else if i == 2{
            randTool = .tape
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
        let currentTool = toolList[pointerPosition]
        var duration: TimeInterval = 1
        
        switch currentTool {
        case .cement:
            duration = 3
        case .glue:
            duration = 2
        case .tape:
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
        gameOverLabel.zPosition = 3
        
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
}
