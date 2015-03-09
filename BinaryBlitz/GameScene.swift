//
//  GameScene.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit
import AVFoundation

enum GameType : String {
    case ARCADE = "Zen"
    case CLASSIC = "Classic"
    case RUSH = "Rush"
    case TUTORIAL = "Tutorial"
    case NONE = "none"
}

class GameScene: SKScene {
    
    var background : SKSpriteNode?
    var mainMenu : MainMenu?
    var gameplay : GamePlay?
    var gameOver : GameOver?
    var tutorial : Tutorial?
    
    var gameCenterDelegate : GameSceneDelegate?
    var shareDelegate : ShareDelegate?
    
    var audioPlayer = AVAudioPlayer()
    
    let classicMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "classic", ofType: "m4a")!)
    let zenMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "zen", ofType: "m4a")!)
    let rushMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "rush", ofType: "m4a")!)
    
    
    override func didMove(to view: SKView) {
        let frameSize = view.frame.size
        let size = iphone5Size
        mainMenu = MainMenu(size: size)
        gameplay = GamePlay(size: size)
        gameOver = GameOver(size: size)
        tutorial = Tutorial()
        background = SKSpriteNode(imageNamed: "background")
        
        tutorial!.zPosition = 50
        mainMenu!.zPosition = 30
        gameOver!.zPosition = 20
        gameplay!.zPosition = 10
        
        background!.zPosition = 0
        background!.anchorPoint = CGPoint(x: 0, y: 0)
        background!.position = CGPoint(x: 0, y: 0)
        
        
        let scaleX = frameSize.width / size.width
        let scaleY = frameSize.height / size.height
        
        mainMenu!.xScale = scaleX
        mainMenu!.yScale = scaleY
        
        if (frameSize.height < iphone5Size.height) {
            mainMenu!.applySpecialScale(scaleX, yScale: scaleY)
        }
        
        tutorial!.xScale = scaleX
        tutorial!.yScale = scaleY
        gameplay!.xScale = scaleX
        gameplay!.yScale = scaleY
        gameOver!.xScale = scaleX
        gameOver!.yScale = scaleY
        background!.xScale = scaleX
        background!.yScale = scaleY
        
        self.addChild(background!)
        mainMenu!.hideButtons()
        mainMenu!.changeMusicSprite(getMusicState())
        self.addChild(mainMenu!)
        mainMenu!.showButtons()
        
        /*for family in UIFont.familyNames(){
        let familyName = family as String
        println("Family name: \(familyName)")
        
        for name in UIFont.fontNamesForFamilyName(familyName){
        let fontName = name as String
        println("font name: \(fontName)")
        }
        }*/
        
        //GameCenterInteractor.sharedInstance.authenticationCheck()
        
    }
    
    func loadGameOver(_ node: SKNode) {
        let game = node as! GamePlay
        let gameType = game.gameType
        let reachedLevel = game.levelNumber - 1
        
        var highscore : HighScore?
        
        audioPlayer.stop()
        
        switch gameType {
        case .CLASSIC:
            highscore = storeHighscore(highscore_store_key_classic, score: reachedLevel)
            break
        case .ARCADE:
            highscore = storeHighscore(highscore_store_key_zen, score: reachedLevel)
            break
        case .RUSH:
            highscore = storeHighscore(highscore_store_key_rush, score: reachedLevel)
            break
        default:
            break
        }
        
        node.removeFromParent()
        gameOver!.changeMusicSprite(getMusicState())
        gameOver!.display(gameType, score: reachedLevel, highscore: highscore!)
        self.addChild(gameOver!)
    }
    
    func loadMainMenu(_ node: SKNode) {
        audioPlayer.stop()
        node.removeFromParent()
        mainMenu!.hideButtons()
        mainMenu!.changeMusicSprite(getMusicState())
        self.addChild(mainMenu!)
        mainMenu!.showButtons()
    }
    
    func loadArcade(_ node: SKNode) {
        node.removeFromParent()
        
        if (!runTutorial()) {
            gameplay!.changeToArcade()
            self.addChild(gameplay!)
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: zenMusic)
            } catch {
                // Do nothing
            }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            
            let state = getMusicState()
            
            if (state == 3) {
                audioPlayer.play()
            }
        } else {
            loadTutorial(GameType.ARCADE)
        }
    }
    
    func loadClassic(_ node: SKNode) {
        node.removeFromParent()
        
        if (!runTutorial()) {
            gameplay!.changeToClassic()
            self.addChild(gameplay!)
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: classicMusic)
            } catch {
                // Do nothing
            }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            
            let state = getMusicState()
            
            if (state == 3) {
                audioPlayer.play()
            }
        } else {
            loadTutorial(GameType.CLASSIC)
        }
    }
    
    func restartMusic(){
        let musicTrack : URL
        switch (gameplay!.gameType) {
        case .ARCADE:
            musicTrack = zenMusic
            break
        case .CLASSIC:
            musicTrack = classicMusic
            break
        case .RUSH:
            musicTrack = rushMusic
            break
        default:
            musicTrack = zenMusic
            break
        }
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: musicTrack)
        } catch {
            // Do nothing
        }
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        
        let state = getMusicState()
        
        if (state == 3) {
            audioPlayer.play()
        }
    }
    
    func loadRush(_ node: SKNode) {
        node.removeFromParent()
        
        if (!runTutorial()) {
            gameplay!.changeToRush()
            self.addChild(gameplay!)
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: rushMusic)
            } catch {
                // Do nothing
            }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            
            let state = getMusicState()
            
            if (state == 3) {
                audioPlayer.play()
            }
        } else {
            loadTutorial(GameType.RUSH)
        }

    }
    
    func loadTutorial(_ type: GameType){
        tutorial!.gameType = type
        self.addChild(tutorial!)
    }
    
    func toggleMusicState() -> Int{
        let defaults = UserDefaults.standard
        
        if let musicState = defaults.integer(forKey: music_state_key) as Int? {
            let newMusicState = musicState == 1 ? 3 : (musicState - 1)
            defaults.set(newMusicState, forKey: music_state_key)
            return newMusicState
        } else {
            return getMusicState()
        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
