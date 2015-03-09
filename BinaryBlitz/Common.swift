//
//  Common.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import SpriteKit
import GameKit

let highscore_store_key_rush = "jc_binary_blitz_rush"
let highscore_store_key_classic = "jc_binary_blitz_classic"
let highscore_store_key_zen = "jc_binary_blitz_zen"

let music_state_key = "music_state"
let tutorial_state_key = "tutorial_state"

let iphone5Size = CGSize(width: 320.0, height: 568.0)

extension Int
{
    static func random(_ range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

func createLabel(_ fontName: String, size: CGFloat, color: UIColor) -> SKLabelNode {
    let label = SKLabelNode()
    
    label.fontColor = color
    label.fontSize = size
    label.fontName = fontName
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
    label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
    
    return label
}

protocol GameSceneDelegate {
    func showLeaderboard(_ type: GameType)
}

protocol ShareDelegate {
    func share(_ type: GameType, score: Int, highscore: Int, isHighscore: Bool)
}

class HighScore {
    let score: Int
    let isNewHighScore: Bool
    
    init(score: Int, isNewHighScore: Bool) {
        self.score = score
        self.isNewHighScore = isNewHighScore
    }
}


func storeHighscore(_ key: String, score: Int) -> HighScore {
    let defaults = UserDefaults.standard
    
    if let highscore = defaults.integer(forKey: key) as Int? {
        if (highscore < score) {
            defaults.set(score, forKey: key)
            submitToGameCenter(key, score: score)
            return HighScore(score: score, isNewHighScore: true)
        }
        return HighScore(score: highscore, isNewHighScore: false)
    } else {
        defaults.set(score, forKey: key)
        submitToGameCenter(key, score: score)
        return HighScore(score: score, isNewHighScore: true)
    }
}

func submitToGameCenter(_ leaderboard: String, score: Int) {
    let newGCScore = GKScore(leaderboardIdentifier: leaderboard)
    newGCScore.value = Int64(score)
    GKScore.report([newGCScore], withCompletionHandler: {(error) -> Void in
        if error != nil {
            print("Score not submitted")
            // Continue
        } else {
            // Notify the delegate to show the game center leaderboard:
            // Not implemented yet
        }
    })
}

// STATE 1: No sound, 2: Only sound effects, 3: sound effects and music
func getMusicState() -> Int {
    let defaults = UserDefaults.standard
    let musicState = defaults.integer(forKey: music_state_key) as Int?
    
    if (musicState! != 0) {
        return musicState!
    } else {
        defaults.set(3, forKey: music_state_key)
        return 3
    }
}

func setTutorialRan() {
    let defaults = UserDefaults.standard
    
    defaults.set(true, forKey: tutorial_state_key)
}

func runTutorial() -> Bool {
    let defaults = UserDefaults.standard
    let wasTutorialRan = defaults.bool(forKey: tutorial_state_key) as Bool?
    
    return !wasTutorialRan!
}

extension String
{
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}







