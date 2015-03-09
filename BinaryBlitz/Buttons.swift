//
//  Buttons.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class GenericButton : SKNode {
    
    let icon : SKSpriteNode
    let background : SKSpriteNode
    let label : SKLabelNode
    
    init(icon: String, background: String, label: String) {
        self.icon = SKSpriteNode(imageNamed: icon)
        self.background = SKSpriteNode(imageNamed: background)
        self.label = createLabel("Erbos-Draco-1st-Open-NBP", size: 20, color: SKColor.white)
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.label.text = label
        
        self.background.zPosition = 0
        self.icon.zPosition = 1
        self.label.zPosition = 1
        
        self.label.position = CGPoint(x: -self.background.size.width * 0.15, y: self.background.size.height / 2 - self.background.size.width * 0.1)
        self.icon.position = CGPoint(x: -self.background.size.width * 0.35, y: self.background.size.height / 2 - self.background.size.width * 0.1)
        
        super.init()
        
        self.addChild(self.background)
        self.addChild(self.label)
        self.addChild(self.icon)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func size() -> CGSize {
        return background.size
    }
    
}

class ArcadeButton: GenericButton {
    
    init() {
        super.init(icon: "zen_clock", background: "btn_blue", label: "Zen")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class ClassicButton: GenericButton {
    init() {
        super.init(icon: "classic_clock", background: "btn_purple", label: "Classic")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RushButton: GenericButton {
    init() {
        super.init(icon: "rush_clock", background: "btn_red", label: "Rush")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
