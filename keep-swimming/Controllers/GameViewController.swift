//
//  GameViewController.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADFullScreenContentDelegate {
    private var scene: GameScene!
    private var rewardedAd: GADRewardedAd?
    
    @IBOutlet weak var extraLifeView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var finalDistance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene") as? GameScene
            scene.gameVC = self
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        // Rewarded
        loadRewardedAd()
    }
    
    private func loadRewardedAd() {
        GADRewardedAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded")
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    func gameOver() {
        extraLifeView.isHidden = false
    }
    
    func resetGame() {
        scene.reset()
        extraLifeView.isHidden = true
        gameOverView.isHidden = true
    }
    
    @IBAction func playAd(_ sender: Any) {
        showAd()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        extraLifeView.isHidden = true
        gameOverView.isHidden = false
//        GameManager.shared.distanceDisplayed
    }
    
    @IBAction func showLeaderoard(_ sender: Any) {
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
    
    @IBAction func restartGame(_ sender: Any) {
        resetGame()
    }
    
    private func showAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                // TODO: Reward the user
                self.loadRewardedAd()
                self.resetGame()
                print("[Add] did show \(reward)")
            }
        } else {
            resetGame()
        }
    }
    
    // MARK: GADFullScreenContentDelegate
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
        resetGame()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
