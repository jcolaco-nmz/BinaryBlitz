//
//  Tutorial.swift
//  BinaryBlitz
//
//  Created by João Colaço on 19/04/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class Tutorial : SKNode {
    
    var gameType = GameType.CLASSIC
    
    override init() {
        super.init()
        self.loadTutorialIntro()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func loadTutorialIntro() {
        self.addChild(TutorialIntro())
    }
    
    func loadGamePlayIntro(_ node: SKNode) {
        node.removeFromParent()
        self.addChild(TutorialGameplay())
    }
    
    func loadBinaryExplanation(_ node: SKNode) {
        node.removeFromParent()
        self.addChild(TutorianBinary())
    }
    
    func exitTutorial() {
        setTutorialRan()
        if let scene = self.scene as? GameScene {
            switch gameType {
            case .CLASSIC:
                scene.loadClassic(self)
                break
            case .ARCADE:
                scene.loadArcade(self)
                break
            case .RUSH:
                scene.loadRush(self)
                break
            default:
                break
            }
        }
    }
    
}

class TutorialIntro : SKNode {
    let tut_1 = SKSpriteNode(imageNamed: "tut_1")
    let yesButton = TutorialButton(label: "Yes")
    let noButton = TutorialButton(label: "No")
    
    override init() {
        tut_1.anchorPoint = CGPoint(x: 0, y: 0)
        
        yesButton.zPosition = 1
        noButton.zPosition = 1
        
        let size = tut_1.size
        
        yesButton.position = CGPoint(x: size.width * 0.25, y: size.height * 0.3)
        noButton.position = CGPoint(x: size.width * 0.75, y: size.height * 0.3)
        
        super.init()
        
        self.addChild(tut_1)
        self.addChild(yesButton)
        self.addChild(noButton)
        
        self.isUserInteractionEnabled = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let tutorial = self.parent as! Tutorial
            
            if (yesButton.contains(location)) {
                tutorial.loadGamePlayIntro(self)
            } else if (noButton.contains(location)) {
                tutorial.loadBinaryExplanation(self)
            }
        }
    }
    
}

class TutorianBinary : SKNode {
    let bg : SKSpriteNode
    let tut_2 = SKTexture(imageNamed: "tut_2")
    
    let nextButton = TutorialButton(label: "Next")
    
    override init() {
        bg = SKSpriteNode(texture: tut_2)
        let size = bg.size
        
        bg.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        nextButton.zPosition = 1
        nextButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.08)
        
        super.init()
        self.addChild(bg)
        self.addChild(nextButton)
        self.isUserInteractionEnabled = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (nextButton.contains(location)) {
                    let tutorial = self.parent as! Tutorial
                    tutorial.loadGamePlayIntro(self)
            }
        
        }
    }
    
}

class TutorialGameplay : SKNode {
    let bg : SKSpriteNode
    let tut_3_1 = SKTexture(imageNamed: "tut_3_1")
    let tut_3_2 = SKTexture(imageNamed: "tut_3_2")
    let tut_3_3 = SKTexture(imageNamed: "tut_3_3")
    let tut_3_4 = SKTexture(imageNamed: "tut_3_4")
    let tut_3_5 = SKTexture(imageNamed: "tut_3_5")
    let tut_3_6 = SKTexture(imageNamed: "tut_3_6")
    let tut_3_7 = SKTexture(imageNamed: "tut_3_7")
    
    let nextButton = TutorialButton(label: "Next")
    let playButton = TutorialButton(label: "Play!")
    
    let touchBall0 : SKShapeNode
    let touchBall1 : SKShapeNode
    
    var step : Int
    var playActive = false
    
    override init() {
        bg = SKSpriteNode(texture: tut_3_1)
        let size = bg.size
        step = 1
        
        bg.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        nextButton.zPosition = 1
        nextButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.08)
        playButton.zPosition = 1
        playButton.position = nextButton.position
        
        let color = UIColor(red: 30 / 255, green: 170 / 255, blue: 230 / 255, alpha: 0.75)
        
        touchBall0 = SKShapeNode()
        touchBall1 = SKShapeNode()
        
        let diameter = 60
        
        touchBall0.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        touchBall1.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        
        touchBall0.strokeColor = color
        touchBall1.strokeColor = color
        touchBall0.glowWidth = 10.0
        touchBall1.glowWidth = 10.0
        touchBall0.fillColor = color
        touchBall1.fillColor = color
        touchBall0.zPosition = 1
        touchBall1.zPosition = 1
        
        touchBall0.position = CGPoint(x: size.width * 0.05, y: size.height * 0.14)
        touchBall1.position = CGPoint(x: size.width * 0.77, y: size.height * 0.14)
        
        touchBall0.alpha = 0
        touchBall1.alpha = 0
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.addChild(bg)
        self.addChild(nextButton)
        self.addChild(touchBall0)
        self.addChild(touchBall1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadNextStep() {
        step += 1
        
        if (step == 2) {
            bg.run(SKAction.setTexture(tut_3_2))
        } else if (step == 3) {
            bg.run(SKAction.setTexture(tut_3_3))
        } else if (step == 4) {
            let wait = SKAction.wait(forDuration: 2)
            let waitSmallest = SKAction.wait(forDuration: 0.2)
            let waitSmall = SKAction.wait(forDuration: 1)
            let waitBig = SKAction.wait(forDuration: 4)
            let touch = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.fadeAlpha(to: 0, duration: 0.3)])
            
            let touch0 = SKAction.run({self.touchBall0.run(touch)})
            let touch1 = SKAction.run({self.touchBall1.run(touch)})

            let removeNextButton = SKAction.run({self.nextButton.removeFromParent(); self.nextButton.position = CGPoint.zero})
            let addPlayButton = SKAction.run({self.addChild(self.playButton); self.playActive = true})
            
            let loopSeq = SKAction.sequence([SKAction.setTexture(tut_3_4), wait, touch0, waitSmallest, SKAction.setTexture(tut_3_5), waitSmall, touch0, waitSmallest, SKAction.setTexture(tut_3_6), waitSmall, touch1, waitSmallest, SKAction.setTexture(tut_3_7)])
            
            let loopAction = SKAction.repeatForever(SKAction.sequence([loopSeq, waitBig]))
            
            let seq = SKAction.sequence([removeNextButton, loopSeq, wait, addPlayButton, wait, loopAction])
            
            bg.run(seq)
            
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (nextButton.contains(location)) {
                loadNextStep()
            } else if (playActive && playButton.contains(location)) {
                let tutorial = self.parent as! Tutorial
                tutorial.exitTutorial()
            }
        
        }
    }
    
}

class TutorialButton : SKNode {
    
    init(label: String) {
        let bg = SKSpriteNode(imageNamed: "tut_button")
        let labelNode = SKLabelNode()
        
        labelNode.text = label
        labelNode.fontName = "Helvetica-Neue"
        labelNode.fontSize = 18
        labelNode.color = SKColor.white
        
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        labelNode.zPosition = 1
        
        super.init()
        
        self.addChild(bg)
        self.addChild(labelNode)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
