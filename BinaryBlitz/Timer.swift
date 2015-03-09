//
//  Timer.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit

class TimerLabel : SKNode {
    let seconds : SKLabelNode = createLabel("Erbos-Draco-1st-Open-NBP", size: 16, color: SKColor.white)
    let apostrophe : SKLabelNode = createLabel("Erbos-Draco-1st-Open-NBP", size: 16, color: SKColor.white)
    let fraction : SKLabelNode = createLabel("Erbos-Draco-1st-Open-NBP", size: 16, color: SKColor.white)
    
    override init() {
        apostrophe.text = ":"
        seconds.text = "00"
        seconds.position = CGPoint(x: -(seconds.fontSize + 5), y: 0)
        fraction.text = "00"
        fraction.position = CGPoint(x: fraction.fontSize + 5, y: 0)
        super.init()
        
        self.addChild(apostrophe)
        self.addChild(seconds)
        self.addChild(fraction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTime(_ secondsStr: String, apostropheStr: String, fractionStr: String) {
        seconds.text = secondsStr
        apostrophe.text = apostropheStr
        fraction.text = fractionStr
    }
}

class Timer: SKNode {
    let clock = SKSpriteNode(texture: SKTexture(imageNamed: "classic_clock"))
    let time : TimerLabel
    var timer : Foundation.Timer?
    var startTime : TimeInterval?
    
    var gameTime = Int(0)
    
    var lastSec = 4
    var newSec = 3
    
    override init() {
        time = TimerLabel()
        clock.position = CGPoint(x: -clock.size.width * 1.35, y: 2)
        time.setTime("00", apostropheStr: ":", fractionStr: "00")
        super.init()
        self.addChild(clock)
        self.addChild(time)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startClock(_ time: Int){
        gameTime = time
        lastSec = 4
        newSec = 3
        
        if (time > 0) {
            timer = Foundation.Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(Timer.updateClock), userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        } else {
            self.time.setTime("", apostropheStr: "", fractionStr: "")
            // TODO change timer sprite
        }
    }
    
    func changeClockType(_ type: GameType) {
        switch type {
        case .RUSH:
            clock.texture = SKTexture(imageNamed: "rush_clock")
            break
        case .CLASSIC:
            clock.texture = SKTexture(imageNamed: "classic_clock")
            break
        case .ARCADE:
            clock.texture = SKTexture(imageNamed: "zen_clock_offset")
            break
        default:
            break
        }
    }
    
    func stopClock() {
        timer?.invalidate()
        timer = nil
    }
    
    func restartClock() {
        stopClock()
        startClock(gameTime)
    }
    
    func updateClock(){
        let timeLeft = getTime()
        let secondsStr = timeLeft.substring(to: 2)
        let fractionStr = timeLeft.substring(with: 3..<5)
        
        self.time.setTime(secondsStr, apostropheStr: ":", fractionStr: fractionStr)
        
        let seconds = Int(secondsStr)
        
        if (seconds == newSec) {
            newSec -= 1
            let zoomIn = SKAction.scale(to: 1.2, duration: 0.3)
            let zoomOut = SKAction.scale(to: 1, duration: 0.3)
            let seq = SKAction.sequence([zoomIn, zoomOut])
            time.run(seq)
        }
        
        if (timeLeft == "00:00") {
            stopClock()
            let gameplay = parent as! GamePlay
            let waitAction = SKAction.wait(forDuration: 0.5)
            
            let playbuzzerAction = SKAction.run({gameplay.playBuzzer()})
            let gameOverAction = SKAction.run({gameplay.gameOver()})
            let seq = SKAction.sequence([waitAction, playbuzzerAction, gameOverAction])
            self.run(seq)
        }
    }
    
    func getTime() -> String {
        if (startTime == nil) {
            return "00:00"
        }
        
        if(timer == nil) {
            startTime = Date.timeIntervalSinceReferenceDate
        }
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime = currentTime - startTime! as TimeInterval

        //calculate the minutes in elapsed time.
        let minutes = Int(UInt8(elapsedTime / 60.0))
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = Int(UInt8(elapsedTime))
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        let secondsLeft = gameTime - seconds - (fraction > 0 ? 1 : 0)
        
        let fractionLeft = fraction > 0 ? 100 - fraction : 0
        
        if(secondsLeft < 0) {
            return "00:00"
        }
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strSeconds = secondsLeft > 9 ? String(secondsLeft):"0" + String(secondsLeft)
        let strFraction = fractionLeft > 9 ? String(fractionLeft):"0" + String(fractionLeft)
        
        return "\(strSeconds):\(strFraction)"
    }

}
