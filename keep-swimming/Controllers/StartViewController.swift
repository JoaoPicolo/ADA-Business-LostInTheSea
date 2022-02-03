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
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.shared.play(music: Audio.MusicFiles.background)
        LeaderboardManager.shared.authenticateLocalPlayer(presentingVC: self)
    }
    
    @IBAction func gameClicked(_ sender: Any) {
        LeaderboardManager.shared.navigateToGame(presentingVC: self)
    }
    
    @IBAction func leaderBoardClicked(_ sender: Any) {
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
    
}
