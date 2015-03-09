//
//  GameOver.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class GameOver: SKNode {
    let size : CGSize
    let headerBand: SKSpriteNode
    let music : SKSpriteNode?
    let leaderboard : SKSpriteNode
    
    let gameOver : SKSpriteNode
    let retry : SKSpriteNode
    let menu : SKSpriteNode
    let share : SKSpriteNode
    let scoreBg : SKSpriteNode
    
    let score = createLabel("Erbos-Draco-1st-Open-NBP", size: 80, color: SKColor.white)
    let highscore = createLabel("Erbos-Draco-1st-Open-NBP", size: 40, color: SKColor.white)
    
    var gametype = GameType.CLASSIC
    
    
    var scoreValue = 0
    var highscoreValue = 0
    var isNewHighscore = false
    
    init(size: CGSize) {
        self.size = size
        headerBand = SKSpriteNode(color: SKColor.black, size: CGSize(width: size.width, height: size.height * 0.07))
        leaderboard = SKSpriteNode(imageNamed: "score")
        
        gameOver = SKSpriteNode(imageNamed: "gameover")
        retry = SKSpriteNode(imageNamed: "retry")
        menu = SKSpriteNode(imageNamed: "menu")
        share = SKSpriteNode(imageNamed: "share")
        scoreBg = SKSpriteNode(imageNamed: "score_bg")
        
        let musicTexture = SKTexture(imageNamed: "sound_\(getMusicState())")
        music = SKSpriteNode(texture: musicTexture)
        super.init()
        
        headerBand.alpha = 0.2
        headerBand.zPosition = 1
        headerBand.anchorPoint = CGPoint(x: 0, y: 1)
        headerBand.position = CGPoint(x: 0, y: size.height)
        
        score.zPosition = 2
        highscore.zPosition = 2
        music!.zPosition = 2
        leaderboard.zPosition = 2
        gameOver.zPosition = 1
        retry.zPosition = 1
        menu.zPosition = 1
        share.zPosition = 1
        scoreBg.zPosition = 1
        
        music!.position = CGPoint(x: size.width * 0.1, y: size.height - (headerBand.size.height / 2))
        leaderboard.position = CGPoint(x: size.width * 0.9, y: size.height - (headerBand.size.height / 2))
        
        gameOver.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        retry.position = CGPoint(x: size.width / 2, y: size.height * 0.15)
        menu.position = CGPoint(x: size.width * 0.2, y: size.height * 0.15)
        share.position = CGPoint(x: size.width * 0.8, y: size.height * 0.15)
        scoreBg.position = CGPoint(x: size.width / 2, y: size.height * 0.48)
        
        score.position = CGPoint(x: size.width / 2, y: size.height * 0.54)
        highscore.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        
        score.text = "34"
        highscore.text = "12"
        
        self.addChild(music!)
        self.addChild(leaderboard)
        self.addChild(headerBand)
        self.addChild(gameOver)
        self.addChild(retry)
        self.addChild(menu)
        self.addChild(share)
        self.addChild(scoreBg)
        self.addChild(score)
        self.addChild(highscore)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(_ type: GameType, score: Int, highscore: HighScore) {
        self.gametype = type
        self.score.text = String(score)
        self.scoreValue = score
        self.highscoreValue = highscore.score
        self.isNewHighscore = highscore.isNewHighScore
        
        if (highscore.isNewHighScore) {
            let zoomIn = SKAction.scale(to: 1.2, duration: 0.3)
            let zoomOut = SKAction.scale(to: 1, duration: 0.3)
            let seq = SKAction.sequence([zoomIn, zoomOut])
            self.highscore.text = String(score)
            self.highscore.run(SKAction.repeat(seq, count: 4))
        } else {
            self.highscore.text = String(highscore.score)
        }
    }
    
    func changeMusicSprite(_ state: Int) {
        music!.texture = SKTexture(imageNamed: "sound_\(state)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let scene = self.scene as! GameScene
            
            if (share.contains(location)) {
                scene.shareDelegate!.share(gametype, score: scoreValue, highscore: highscoreValue, isHighscore: isNewHighscore)
            } else if (retry.contains(location)) {
                switch gametype {
                case .ARCADE:
                    scene.loadArcade(self)
                    break
                case .CLASSIC:
                    scene.loadClassic(self)
                    break
                case .RUSH:
                    scene.loadRush(self)
                    break
                default:
                    break
                }
            } else if (menu.contains(location)) {
                scene.loadMainMenu(self)
            } else if (leaderboard.contains(location)) {
                scene.gameCenterDelegate!.showLeaderboard(self.gametype)
            } else if (music!.contains(location)) {
                changeMusicSprite(scene.toggleMusicState())
            }
        }
    }
   
}
