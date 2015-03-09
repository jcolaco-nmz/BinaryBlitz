//
//  GamePlay.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit
import AVFoundation

let levelBaseMapping = [ 2:5, 3:5, 4:10, 5:10, 6:15]
let defaultAmount = 15

class GamePlay: SKNode {
    
    let size : CGSize
    
    var colorLayer : SKSpriteNode
    let line = SKSpriteNode(imageNamed: "line")
    let zeroButton = BinaryButton(value: 0)
    let oneButton = BinaryButton(value: 1)
    let timer = Timer()
    let level = createLabel("Erbos-Draco-1st-Open-NBP", size: 30, color: SKColor.white)
    let targetValue : SKLabelNode
    let binaryValue : BinaryValueNode
    let previewValue : SKLabelNode
    
    let bitDisplayer : BitDisplayer
    
    let restartButtonLabel = createLabel("Erbos-Draco-1st-Open-NBP", size: 14, color: SKColor.white)
    let restartButton : SKSpriteNode
    
    let blackCurtain : SKSpriteNode
    
    var levelNumber = 0
    var currentBinaryStr = ""
    var currentDecimalValue = 0 as UInt
    var targetDecimalValue = 0 as UInt
    
    var currentBase = 0
    var playedValues = [] as Array<Int>
    var playValues = [] as Array<Int>
    var playIndex = 0
    
    var gameType = GameType.ARCADE
    
    let buzzer = URL(fileURLWithPath: Bundle.main.path(forResource: "error", ofType: "wav")!)
    let point = URL(fileURLWithPath: Bundle.main.path(forResource: "point", ofType: "wav")!)
    let click = URL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "wav")!)
    let restart = URL(fileURLWithPath: Bundle.main.path(forResource: "paper", ofType: "mp3")!)
    
    var audioPlayer = AVAudioPlayer()
    var pointPlayer = AVAudioPlayer()
    var clickPlayer = AVAudioPlayer()
    var restartPlayer = AVAudioPlayer()
    
    var musicState = 3 as Int
    
    init(size: CGSize) {
        
        self.size = size
        
        blackCurtain = SKSpriteNode(color: SKColor.black, size: size)
        blackCurtain.alpha = 0
        
        restartButton = SKSpriteNode(color: SKColor.black, size: CGSize(width: size.width * 0.25, height: size.height * 0.1))
        restartButton.alpha = 0
        
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        binaryValue = BinaryValueNode(size: size)
        
        bitDisplayer = BitDisplayer(size: size)
        
        colorLayer = SKSpriteNode(color: SKColor.red, size: size)
        //colorLayer.alpha = 0.4
        colorLayer.anchorPoint = CGPoint(x: 0, y: 0)
        colorLayer.position = CGPoint.zero
        
        line.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        zeroButton.position = CGPoint(x: size.width * 0.14, y: size.height * 0.19)
        oneButton.position = CGPoint(x: size.width * 0.86, y: size.height * 0.19)
        
        level.position = CGPoint(x: size.width * 0.95, y: size.height * 0.94)
        level.text = "20"
        
        restartButtonLabel.text = "RESTART"
        restartButtonLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.07)
        restartButton.position = restartButtonLabel.position
        
        timer.position = CGPoint(x: size.width * 0.26, y: size.height * 0.94)
        
        line.zPosition = 1
        zeroButton.zPosition = 2
        oneButton.zPosition = 2
        timer.zPosition = 2
        level.zPosition = 2
        restartButtonLabel.zPosition = 2
        restartButton.zPosition = 3
        
        blackCurtain.zPosition = 5
        
        bitDisplayer.zPosition = 2
        bitDisplayer.position = CGPoint(x: size.width / 2, y: size.height * 0.35)
        
        blackCurtain.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        targetValue = createLabel("Erbos-Draco-1st-Open-NBP", size: 100, color: SKColor.white)
        previewValue = createLabel("Erbos-Draco-1st-Open-NBP", size: 40, color: SKColor.white)
        targetValue.zPosition = 2
        previewValue.zPosition = 2
        targetValue.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        previewValue.position = CGPoint(x: size.width / 2, y: size.height * 0.5)
        
        binaryValue.zPosition = 2
        binaryValue.position = CGPoint(x: size.width / 2, y: size.height * 0.63)
        
        
        previewValue.text = "5"
        targetValue.text = "254"
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GamePlay.stopGame(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        self.addChild(line)
        self.addChild(colorLayer)
        self.addChild(zeroButton)
        self.addChild(oneButton)
        self.addChild(timer)
        self.addChild(level)
        self.addChild(restartButtonLabel)
        self.addChild(restartButton)
        self.addChild(targetValue)
        self.addChild(binaryValue)
        self.addChild(previewValue)
        self.addChild(bitDisplayer)
        self.addChild(blackCurtain)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopGame(_ notification: Notification) {
        if (self.scene as? GameScene) != nil {
            gameOver()
        }
    }
    
    fileprivate func add1Bit() {
        currentBinaryStr = "1" + currentBinaryStr
        updateValue()

        if (musicState > 1) {
            clickPlayer.play()
        }
    }
    
    fileprivate func add0Bit() {
        currentBinaryStr = "0" + currentBinaryStr
        updateValue()
        
        if (musicState > 1) {
            clickPlayer.play()
        }
    }
    
    fileprivate func updateValue() {
        currentDecimalValue = strtoul(currentBinaryStr, nil, 2)
        // Update BinaryValueNode
        binaryValue.update(currentBinaryStr)
        previewValue.text = String(currentDecimalValue)
        evaluateTarget()
    }
    
    fileprivate func evaluateTarget(){
        if (currentDecimalValue == targetDecimalValue) {
            if (musicState > 1) {
                pointPlayer.play()
            }
            changeLevel()
            
            if (gameType == GameType.CLASSIC) {
                self.timer.restartClock()
            }
        } else if (currentDecimalValue > targetDecimalValue) {
            self.isUserInteractionEnabled = false
            let waitAction = SKAction.wait(forDuration: 0.5)
            
            let playbuzzerAction = SKAction.run({self.playBuzzer()})
            let gameOverAction = SKAction.run({self.gameOver()})
            let seq = SKAction.sequence([waitAction, playbuzzerAction, gameOverAction])
            self.run(seq)
        }
    }
    
    func playBuzzer() {
        if (musicState > 1) {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: buzzer)
            } catch {
                // Do nothing
            }
            audioPlayer.numberOfLoops = 0
            audioPlayer.volume = 0.5
            audioPlayer.play()
        }
    }
    
    fileprivate func changeLevel() {
        playIndex += 1
        if (playIndex >= playValues.count) {
            currentBase = currentBase == 15 ? currentBase : currentBase + 1
            playValues.removeAll(keepingCapacity: false)
            playIndex = 0
            if let amount = levelBaseMapping[currentBase] {
                playValues += generateNumber(currentBase, amount: amount, playedValues: playedValues)
            } else {
                playValues += generateNumber(currentBase, amount: defaultAmount, playedValues: playedValues)
            }
            bitDisplayer.updateBit(currentBase)
        }
        
        let target = playValues[playIndex]
        playedValues.append(target)
        targetDecimalValue = UInt(target)
        
        currentBinaryStr = ""
        currentDecimalValue = 0
        levelNumber += 1
        binaryValue.update(currentBinaryStr)
        previewValue.text = String(currentDecimalValue)
        
        targetValue.text = String(targetDecimalValue)
        
        let extra = CGFloat(String(targetDecimalValue).characters.count - 2)
        
        targetValue.fontSize = 100 - (10 * extra)
        
        level.text = String(levelNumber - 1)
        
        let zoomIn = SKAction.scale(to: 1.2, duration: 0.3)
        let zoomOut = SKAction.scale(to: 1, duration: 0.3)
        let seq = SKAction.sequence([zoomIn, zoomOut])
        level.run(seq)
    }
    
    fileprivate func bootstrap() {
        bitDisplayer.resetBits()
        musicState = getMusicState()
        timer.changeClockType(gameType)
        playIndex = 0
        currentBase = 2
        playValues.removeAll(keepingCapacity: false)
        playedValues.removeAll(keepingCapacity: false)
        
        let amount = levelBaseMapping[currentBase]
        playValues += generateNumber(currentBase, amount: amount!, playedValues: playedValues)
        
        let target = playValues[playIndex]
        playedValues.append(target)
        targetDecimalValue = UInt(target)
        
        currentBinaryStr = ""
        currentDecimalValue = 0
        levelNumber = 1
        binaryValue.update(currentBinaryStr)
        previewValue.text = String(currentDecimalValue)
        targetValue.text = String(targetDecimalValue)
        level.text = String(levelNumber - 1)
        self.isUserInteractionEnabled = true
        
        do {
            try pointPlayer = AVAudioPlayer(contentsOf: self.point)
            pointPlayer.volume = 0.5
            pointPlayer.prepareToPlay()
            try clickPlayer = AVAudioPlayer(contentsOf: self.click)
            clickPlayer.volume = 0.5
            clickPlayer.prepareToPlay()
            try restartPlayer = AVAudioPlayer(contentsOf: self.restart)
            restartPlayer.prepareToPlay()
        } catch {
            // Do nothing
        }
    }
    
    func gameOver() {
        self.timer.stopClock()
        let gameScene = self.scene as! GameScene
        gameScene.loadGameOver(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (oneButton.contains(location)) {
                add1Bit()
            } else if (zeroButton.contains(location)) {
                add0Bit()
            } else if (restartButton.contains(location)) {
                restartGame()
            }
        }
    }
    
    fileprivate func restartGame() {
        let seq = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.1), SKAction.fadeAlpha(to: 0, duration: 0.1)])
        self.timer.stopClock()
        self.bootstrap()
        self.timer.restartClock()
        blackCurtain.run(seq)
        if (musicState > 1) {
            restartPlayer.play()
        }
        if (musicState == 3) {
            let scene = self.scene as! GameScene
            scene.restartMusic()
        }
    }
    
    fileprivate func generateNumber(_ baseLevel: Int, amount: Int, playedValues: Array<Int>) -> Array<Int> {
        var returnValues = [] as Array<Int>
        let min = Int(baseLevel == 2 ? 1 : pow(2, Double(baseLevel)))
        let max = Int(pow(2, Double(baseLevel + 1))) - 1
        
        for _ in 1...amount {
            var value = 0 as Int
            repeat {
                value = Int.random(min..<(max + 1))
            } while (value == 0 || returnValues.contains(value) || playedValues.contains(value))
            
            returnValues.append(value)
            
        }
        
        return returnValues
    }
    
    
    func changeToArcade() {
        gameType = GameType.ARCADE
        bootstrap()
        colorLayer.color = UIColor(red: 30 / 255, green: 170 / 255, blue: 230 / 255, alpha: 0.75)
        self.timer.startClock(0)
    }
    
    func changeToClassic() {
        gameType = GameType.CLASSIC
        bootstrap()
        colorLayer.color = UIColor(red: 150 / 255, green: 65 / 255, blue: 195 / 255, alpha: 0.75)
        self.timer.startClock(10)
    }
    
    func changeToRush() {
        gameType = GameType.RUSH
        bootstrap()
        colorLayer.color = UIColor(red: 1, green: 90 / 255, blue: 90 / 255, alpha: 0.75)
        self.timer.startClock(59)
    }

}
