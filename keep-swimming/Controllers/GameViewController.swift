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
    private var interstitial: GADInterstitialAd?

    @IBOutlet weak var extraLifeView: UIView!
    @IBOutlet weak var gameOverView: UIView!
    
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
        
        // INTERSTICIAL
        requestIntersticial()
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
    }

    @IBAction func showLeaderoard(_ sender: Any) {
        LeaderboardManager.shared.navigateToLeaderboard(presentingVC: self)
    }
    
    @IBAction func restartGame(_ sender: Any) {
        resetGame()
    }

    func requestIntersticial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func showAd() {
        if interstitial != nil {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        resetGame()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
        // Pause music
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        resetGame()
        requestIntersticial()
        
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
