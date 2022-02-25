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
    
    private var interstitial: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?
    private var canViewAd = true
    private var playWithoutAds = 0
    
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
        loadInterstitialAd()
        setLottieAnimation()
    }
    
    func setLottieAnimation() {
        animationView.animation = Animation.named("heartAnimationOfficial3")
    }
    
    func playAnimation() {
        animationView.play()
        animationView.loopMode = .loop
    }
    
    func stopAnimation() {
        animationView.stop()
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
        
        stopAnimation()
    }
    
    @IBAction func playAd(_ sender: Any) {
        showAd()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        if playWithoutAds >= 2 {
            // Show Intersectial
            interstitial?.present(fromRootViewController: self)
            showGameOverView()
            loadInterstitialAd()
        }
        else {
            playWithoutAds += 1
            showGameOverView()
        }
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
        
        stopAnimation()
    }
    
    private func showExtraLifeView() {
        canViewAd = false
        gameOverView.isHidden = true
        extraLifeView.isHidden = false
        
        // Do animation
        playAnimation()
    }
    
    private func showGameOverView() {
        canViewAd = true
        gameOverView.isHidden = false
        extraLifeView.isHidden = true
        finalDistance.text = GameManager.shared.distanceDisplayed.description + " m"
        
        stopAnimation()
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
            withAdUnitID: "ca-app-pub-5811792341403548/1897204328", request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                print("[Ads] Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded")
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-5811792341403548/7840069213",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("[Ads] Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        })
    }
    
    /// GADFullScreenContentDelegate
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        playWithoutAds = 0
        print("[Ads] Ad presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        playWithoutAds = 0
        print("[Ads] Ad dismissed.")
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        resetGame()
        playWithoutAds = 0
        print("[Ads] Ad failed to present with error: \(error.localizedDescription).")
    }
}
