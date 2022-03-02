//
//  LeaderboardManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 02/02/22.
//

import GameKit

class LeaderboardManager: NSObject, GKGameCenterControllerDelegate {
    static let shared = LeaderboardManager()
    private var userAchievements = [GKAchievement]()
    
    // Leaderboard variables
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    func authenticateLocalPlayer(presentingVC: UIViewController?) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                presentingVC!.present(ViewController!, animated: true, completion: nil)
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
                
//                self.loadActiveAchievements()
//                if self.userAchievements.isEmpty {
//                    // Saves achievements for the first time, tricks being done here hehe
//                    self.initAchievements()
//                }
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
            GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [self.gcDefaultLeaderBoard], completionHandler: {error in
                if error != nil {
                    print("Error updating score: \(error!)")
                }
            })
        }
    }
    
    
    func navigateToLeaderboard(presentingVC: UIViewController?) {
        let gameCenterVC = GKGameCenterViewController(state: .dashboard)
//        let gameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        gameCenterVC.gameCenterDelegate = self
        presentingVC!.present(gameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    private let playIDs = ["firstPlay"]
    private let obstacleIDs = ["obstacles10", "obstacles50", "obstacles100"]
    func initAchievements() {
        var achievementsToReport = [GKAchievement]()
        
        for id in playIDs {
            achievementsToReport.append(GKAchievement(identifier: id))
        }
        
        for id in obstacleIDs {
            achievementsToReport.append(GKAchievement(identifier: id))
        }
        
        // Must report achievements when app init
        print("[Acv] Will report \(achievementsToReport)")
        GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
            if error != nil {
                // Handle the error that occurs.
                print("[Acv] Error on init: \(String(describing: error))")
            } else {
                self.loadActiveAchievements()
            }
        })
    }
    
    func loadActiveAchievements() {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            print("[Acv] Retrieved achievements \(achievements)")
            if achievements != nil {
                self.userAchievements = achievements!
            }
            
            if error != nil {
                // Handle the error that occurs.
                print("[Acv] Error on load: \(String(describing: error))")
            }
        })
    }
}
