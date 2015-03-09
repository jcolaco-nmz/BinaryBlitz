//
//  GameViewController.swift
//  BinaryBlitz
//
//  Created by Joao on 01/03/15.
//  Copyright (c) 2015 João Colaço. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GameSceneDelegate, ShareDelegate, GKGameCenterControllerDelegate {
    
    private var _orientations = UIInterfaceOrientationMask.portrait

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed: "GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .resizeFill
            
            scene.gameCenterDelegate = self
            scene.shareDelegate = self
            
            skView.presentScene(scene)
            initGameCenter()
        }
    }
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func showLeaderboard(_ type: GameType) {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
        
        switch type {
        case .ARCADE:
            gcViewController.leaderboardIdentifier = "jc_binary_blitz_zen"
            break
        case .CLASSIC:
            gcViewController.leaderboardIdentifier = "jc_binary_blitz_classic"
            break
        case .RUSH:
            gcViewController.leaderboardIdentifier = "jc_binary_blitz_rush"
            break
        default:
            break
        }
        
        // Show leaderboard
        self.present(gcViewController, animated: true, completion: nil)
    }
    
    func share(_ type: GameType, score: Int, highscore: Int, isHighscore: Bool) {
        var textToShare = ""
        
        if (isHighscore) {
            textToShare = "I've just achieved a new highscore of \(highscore) in BinaryBlitz \(type.rawValue) Mode!!!"
        } else {
            textToShare = "I've just scored \(score) in BinaryBlitz \(type.rawValue) Mode!!!"
        }
        
        textToShare += " How much can you score?"
        
        
        if let myWebsite = URL(string: "https://itunes.apple.com/app/id980949730")
        {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    override var shouldAutorotate : Bool {
        return true
    }

    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func gameCenterStateChanged() {
        
    }
    
    // Initialize Game Center
    func initGameCenter() {
        
        // Check if user is already authenticated in game center
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            
            // Show the Login Prompt for Game Center
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    self.present(viewController!, animated: true, completion: nil)
                    
                    // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.addObserver(self, selector:#selector(GameViewController.gameCenterStateChanged), name: NSNotification.Name(rawValue: "GKPlayerAuthenticationDidChangeNotificationName"), object: nil)
                }
            }
        }
    }
}
