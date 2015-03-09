//
//  BitDisplayer.swift
//  BinaryBlitz
//
//  Created by João Colaço on 06/04/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class BitDisplayer : SKNode {
    
    var bits = Array<SKSpriteNode>()
    
    let dot_full = SKTexture(imageNamed: "dot_full")
    let dot_empty = SKTexture(imageNamed: "dot_empty")
    
    init(size: CGSize) {
        
        let stepX = size.width * 0.8 / 8
        let stepY = size.height * 0.05
        
        var startX = 3.5 * stepX
        var startY = stepY / 2
        
        super.init()
        
        for index in 1...16 {
            let sprite = SKSpriteNode(texture: dot_empty)
            sprite.position = CGPoint(x: startX, y: startY)
            bits.append(sprite)
            startX -= stepX
            self.addChild(sprite)
            
            if (index == 8) {
                startY -= stepY
                startX = 3.5 * stepX
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetBits() {
        for index in 0...(self.bits.count - 1) {
            bits[index].texture = index < 3 ? dot_full : dot_empty
        }
    }
    
    func updateBit(_ bit: Int) {
        let changeTexture = SKAction.setTexture(dot_full)
        let zoomIn = SKAction.scale(to: 1.2, duration: 0.3)
        let zoomOut = SKAction.scale(to: 1, duration: 0.3)
        
        bits[bit].run(SKAction.sequence([changeTexture, zoomIn, zoomOut]))
    }
    
}
