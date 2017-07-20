//
//  Portal.swift
//  Dam
//
//  Created by Akash Nambiar on 7/19/17.
//  Copyright © 2017 Akash Nambiar. All rights reserved.
//

import SpriteKit

class Portal: SKSpriteNode {
    
    var start = NSDate()
    
    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "portalHole")
        let color = UIColor.black
        let size = texture.size()
  
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
