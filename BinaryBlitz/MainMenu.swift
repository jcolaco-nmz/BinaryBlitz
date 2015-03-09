//
//  MainMenu.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit
import GameKit
import AVFoundation

class MainMenu : SKNode  {
    
    let headerBand: SKSpriteNode
    let logo: SKSpriteNode
    let arcadeButton : GenericButton
    let classicButton : GenericButton
    let rushButton : GenericButton
    let music : SKSpriteNode?
    let score : SKSpriteNode
    
    let size : CGSize
    
    let menuClick = URL(fileURLWithPath: Bundle.main.path(forResource: "menu", ofType: "wav")!)
    var menuClickPlayer : AVAudioPlayer?
    
    init(size: CGSize) {
        self.size = size
        
        headerBand = SKSpriteNode(color: SKColor.black, size: CGSize(width: size.width, height: size.height * 0.07))
        logo = SKSpriteNode(imageNamed: "binary_logo")
        score = SKSpriteNode(imageNamed: "score")
        arcadeButton = ArcadeButton()
        classicButton = ClassicButton()
        rushButton = RushButton()
        
        let musicTexture = SKTexture(imageNamed: "sound_\(getMusicState())")
        music = SKSpriteNode(texture: musicTexture)
        
        super.init()
        
        headerBand.alpha = 0.2
        headerBand.zPosition = 1
        headerBand.anchorPoint = CGPoint(x: 0, y: 1)
        headerBand.position = CGPoint(x: 0, y: size.height)
        
        let chooseAMode = createLabel("Helvetica", size: 21, color: SKColor.gray)
        chooseAMode.zPosition = 1
        chooseAMode.text = "CHOOSE A MODE"
        chooseAMode.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        
        let alphaMinus = SKAction.fadeAlpha(to: 0.2, duration: 1)
        let alphaPlus = SKAction.fadeAlpha(to: 1, duration: 1)
        let seq = SKAction.sequence([alphaMinus, alphaPlus])
        let repeatAction = SKAction.repeatForever(seq)
        
        chooseAMode.run(repeatAction)
        
        music!.zPosition = 2
        score.zPosition = 2
        
        music!.position = CGPoint(x: size.width * 0.1, y: size.height - (headerBand.size.height / 2))
        score.position = CGPoint(x: size.width * 0.9, y: size.height - (headerBand.size.height / 2))
        
        logo.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        
        rushButton.zPosition = 10
        arcadeButton.zPosition = 6
        classicButton.zPosition = 2
        
        let offset = rushButton.size().height * 0.33
        
        rushButton.position = CGPoint(x: size.width / 2, y: rushButton.size().height * 0.5 - offset)
        arcadeButton.position = CGPoint(x: size.width / 2, y: arcadeButton.size().height * 0.5 - offset)
        classicButton.position = CGPoint(x: size.width / 2, y: classicButton.size().height * 0.5 - offset)
        
        do {
            try menuClickPlayer = AVAudioPlayer(contentsOf: self.menuClick)
        } catch {
            // Do nothing
        }
        
        menuClickPlayer?.prepareToPlay()
        
        self.addChild(music!)
        self.addChild(score)
        self.addChild(headerBand)
        self.addChild(logo)
        self.addChild(arcadeButton)
        self.addChild(classicButton)
        self.addChild(rushButton)
        self.addChild(chooseAMode)
        
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadLeaderboard() {
        let scene = self.scene as! GameScene
        
        scene.gameCenterDelegate?.showLeaderboard(GameType.NONE)
    }
    
    func changeMusicSprite(_ state: Int) {
        music!.texture = SKTexture(imageNamed: "sound_\(state)")
    }
    
    func hideButtons() {
        let offset = rushButton.size().height * 0.33
        
        rushButton.position = CGPoint(x: size.width / 2, y: -(rushButton.size().height * 0.5 - offset))
        arcadeButton.position = CGPoint(x: size.width / 2, y: -(arcadeButton.size().height * 0.5 - offset))
        classicButton.position = CGPoint(x: size.width / 2, y: -(classicButton.size().height * 0.5 - offset))
        
        
    }
    
    
    func showButtons() {
        let offset = rushButton.size().height * 0.33
        let moveRush = SKAction.moveTo(y: rushButton.size().height * 0.5 - offset, duration: 0.3)
        let moveZen = SKAction.moveTo(y: arcadeButton.size().height * 0.5 - offset, duration: 0.5)
        let moveClassic = SKAction.moveTo(y: classicButton.size().height * 0.5 - offset, duration: 0.7)
        
        rushButton.run(moveRush)
        arcadeButton.run(SKAction.sequence([moveZen]))
        classicButton.run(SKAction.sequence([moveClassic]))
    }
    
    fileprivate func playMenuClick() {
        if (getMusicState() > 1) {
            menuClickPlayer?.play()
        }
    }
    
    func applySpecialScale(_ xScale: CGFloat, yScale: CGFloat) {
        let deltay = 1 - (yScale - 1)
        
        logo.yScale = deltay
        
        //rushButton.yScale = deltay
        //arcadeButton.yScale = deltay
        //classicButton.yScale = deltay
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let goUp = SKAction.move(by: CGVector(dx: 0, dy: rushButton.size().height * 0.15), duration: 0.2)
        let goDown = SKAction.move(by: CGVector(dx: 0, dy: -rushButton.size().height * 0.15), duration: 0.2)
        
        let disapear = SKAction.move(by: CGVector(dx: 0, dy: -300), duration: 0.3)
        
        for touch in touches {
            let location = touch.location(in: self)
            let scene = self.scene as! GameScene
            
            if (rushButton.contains(location)) {
                playMenuClick()
                let block = SKAction.run({scene.loadRush(self)})
                rushButton.run(SKAction.sequence([goUp, goDown, block]))
                arcadeButton.run(disapear)
                classicButton.run(disapear)
            } else if (arcadeButton.contains(location)) {
                playMenuClick()
                let block = SKAction.run({scene.loadArcade(self)})
                arcadeButton.run(SKAction.sequence([goUp, goDown, block]))
                rushButton.run(disapear)
                classicButton.run(disapear)
            } else if (classicButton.contains(location)) {
                playMenuClick()
                let block = SKAction.run({scene.loadClassic(self)})
                classicButton.run(SKAction.sequence([goUp, goDown, block]))
                arcadeButton.run(disapear)
                rushButton.run(disapear)
            } else if (score.contains(location)) {
                loadLeaderboard()
            } else if (music!.contains(location)) {
                changeMusicSprite(scene.toggleMusicState())
            }
        }
    }
    
}
