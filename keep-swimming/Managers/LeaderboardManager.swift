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
                
                self.loadActiveAchievements()
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
                
                GKLeaderboard.loadLeaderboards(IDs: [self.gcDefaultLeaderBoard], completionHandler: { leaderboards, leaderboardError in
                    if leaderboardError != nil {
                        print("[Acv] Error getting leaderboard", leaderboardError!)
                    }
                    else {
                        let leaderboard = leaderboards?.first
                        if leaderboard != nil {
                            leaderboard!.loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime, completionHandler: { entry, entries, error in
                                let rank = entry?.rank
                                if rank == 1 {
                                    self.updateAchievement(id: "bestPlayer", value: 1, total: 1)
                                }

                            })
                        }
                    }
                })
            })
        }
    }
    
    
    func navigateToLeaderboard(presentingVC: UIViewController?) {
        let gameCenterVC = GKGameCenterViewController(state: .dashboard)
        gameCenterVC.gameCenterDelegate = self
        presentingVC!.present(gameCenterVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    private let achievementIDs = ["play1", "play100", "obstacles50", "obstacles100", "obstacles500", "obstacles1000",
    "distance100", "distance500", "distance1000", "distance15000", "distance20000", "distance100000", "bestPlayer",
    "loss1", "loss10", "extraLife", "memory1", "memory10"]

    func loadActiveAchievements() {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            if achievements != nil {
                print("[Acv] Loaded achievements \(achievements!)")
                self.userAchievements = achievements!
            }
            
            if error != nil {
                // Handle the error that occurs.
                print("[Acv] Error on load: \(String(describing: error))")
            }
        })
    }
    
    func updateAchievement(id: String, value: Double, total: Double) {
        let achievement = self.userAchievements.first { $0.identifier == id }
        
        if achievement != nil {
//            print("[Acv] Will update before: \(achievement!)")
            if achievement!.percentComplete < 100 {
//                print("[Acv] Will update after: \(achievement!)")
                let progress = (value * 100.0) / total
                achievement!.percentComplete = achievement!.percentComplete + progress
                achievement?.showsCompletionBanner = true
                GKAchievement.report([achievement!], withCompletionHandler: {(error: Error?) in
                    if error != nil {
                        // Handle the error that occurs.
                        print("[Acv] Error on update: \(String(describing: error))")
                    }
                })
            }
        }
        else {
            let newAchievement = GKAchievement(identifier: id)
            let progress = (value * 100.0) / total
            newAchievement.percentComplete = progress
            newAchievement.showsCompletionBanner = true
//            print("[Acv] New achievement: \(newAchievement)")
            self.userAchievements.append(newAchievement)
            GKAchievement.report([newAchievement], withCompletionHandler: {(error: Error?) in
                if error != nil {
                    // Handle the error that occurs.
                    print("[Acv] Error on create: \(String(describing: error))")
                }
            })
        }
    }
}
