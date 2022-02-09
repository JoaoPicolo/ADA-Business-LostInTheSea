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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameVC.modalTransitionStyle = .crossDissolve
        self.present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func leaderboardClicked(_ sender: Any) {
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
}
