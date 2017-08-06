//
//  Man.swift
//  Dam
//
//  Created by Akash Nambiar on 7/18/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class Man: SKSpriteNode{
   
    var timesHit = 0
    
    init() {
    // Make a texture from an image, a color, and size
    let texture = SKTexture(imageNamed: "manWithout")
    let color = UIColor.clear
    let size = texture.size()
    
    // Call the designated initializer
    super.init(texture: texture, color: color, size: size)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
