//
//  BinaryValueNode.swift
//  BinaryBlitz
//
//  Created by João Colaço on 11/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class BinaryValueNode: SKNode {
    
    var background : SKSpriteNode
    var label : SKLabelNode
    
    let startFontSize = 40 as CGFloat
    
    init(size: CGSize) {
        background = SKSpriteNode(color: SKColor.white, size: CGSize(width: size.width * 0.8, height: size.height * 0.1))
        background.alpha = 0.3
        label = createLabel("Erbos-Draco-1st-Open-NBP", size: startFontSize, color: SKColor.white)
        label.zPosition = 1
        
        label.text = ""
        
        super.init()
        self.addChild(background)
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ value: String) {
        label.text = value
        let extra = CGFloat(value.characters.count - 7)
        
        if (extra > 0) {
            if (extra < 3) {
                label.fontSize -= 5
            } else if (extra < 8) {
                label.fontSize -= 2
            } else {
                label.fontSize -= 1
            }
        } else {
            label.fontSize = startFontSize
        }
    }
    
}
