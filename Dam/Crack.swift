//
//  Crack.swift
//  Dam
//
//  Created by Akash Nambiar on 7/10/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class Crack: SKSpriteNode {
    
    let start = NSDate()
    
    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "cracks")
        let color = UIColor.clear
        let size = texture.size()
        
              // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
