//
//  StartViewController.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 02/02/22.
//

import UIKit
import GameKit
import SpriteKit
import GameplayKit

class StartViewController: UIViewController {
    // Leaderboard variables
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StartViewController: GKGameCenterControllerDelegate {
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            }
            else if (localPlayer.isAuthenticated) {
                
                // Player is already authenticated and logged in
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
            }
            else {
                // Game center is not enabled on the user's device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    func updateScore(with value:Int) {
        if (self.gcEnabled) {
            GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in})
        }
    }
    
    @IBAction func gameClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func leaderBoardClicked(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
}
