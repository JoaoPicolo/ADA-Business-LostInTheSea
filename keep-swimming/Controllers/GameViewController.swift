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
import Lottie

class GameViewController: UIViewController {
    private var scene: GameScene!
    
    private var rewardedAd: GADRewardedAd?
    private var canViewAd = true
    
    @IBOutlet weak var extraLifeView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var finalDistance: UILabel!
    
    @IBOutlet weak var animationView: AnimationView!
    
    
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
        loadRewardAd()
        
    }
    
    func lottieAnimation() {
        
        let animationview = AnimationView(name: "heartAnimation")
        animationview.frame = CGRect(x: 347, y: 35, width: 150, height: 150)
      //  animationview.center = self.view.center
        animationview.contentMode = .scaleAspectFit
        view.addSubview(animationview)
        animationview.play()
        animationview.loopMode = .loop
    }
    
    func adChoice() {
        if canViewAd {
            showExtraLifeView()
        } else {
            showGameOverView()
        }
    }
    
    func rewardUser() {
        extraLifeView.isHidden = true
        scene.rewardUser()
    }
    
    @IBAction func playAd(_ sender: Any) {
        showAd()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        showGameOverView()
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
                self.loadRewardAd()
                self.rewardUser()
            }
        } else {
            resetGame()
        }
    }
    
    func resetGame() {
        scene.reset()
        gameOverView.isHidden = true
        extraLifeView.isHidden = true
    }
    
    private func showExtraLifeView() {
        canViewAd = false
        gameOverView.isHidden = true
        extraLifeView.isHidden = false
        
        // Do animation
        lottieAnimation()
    }
    
    private func showGameOverView() {
        canViewAd = true
        gameOverView.isHidden = false
        extraLifeView.isHidden = true
        finalDistance.text = GameManager.shared.distanceDisplayed.description + " m"
        
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

// MARK: Ads extension
extension GameViewController: GADFullScreenContentDelegate {
    private func loadRewardAd() {
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
    
    /// GADFullScreenContentDelegate
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
}
