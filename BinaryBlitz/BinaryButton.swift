//
//  BinaryButton.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit


class BinaryButton : SKNode {
    
    let hittingBox = SKSpriteNode(color: SKColor.white, size: CGSize(width: 60, height: 60))
    let number = createLabel("Erbos-Draco-1st-Open-NBP", size: 40, color: SKColor.white)
    
    init(value: Int) {
        hittingBox.alpha = 0
        number.text = String(value)
        number.zPosition = 1
        super.init()
        self.addChild(hittingBox)
        self.addChild(number)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
