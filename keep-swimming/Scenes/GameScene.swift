//
//  GameScene.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import SpriteKit
import GameplayKit

import FirebaseAnalytics


class GameScene: SKScene {
    // Nodes
    var player: Player!
    var ground: Limit!
    var ceil: Limit!
    var lifebar: Lifebar!
    var introNode: SKSpriteNode!
    var distanceText: SKLabelNode!
    var scenery: Scenery!
    var limitCollisionEnabled = true
    
    // Managers
    var spawnManager: SpawnManager!
    var cameraManager: CameraManager!
    var hapticsManeger = HapticsManager()
    
    // Control
    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
    // Double reference, thus weak
    weak var gameVC: GameViewController!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Player Node
        let playerNode = childNode(withName: "player") as! SKSpriteNode
        player = Player(node: playerNode)
        
        // Ground Node
        let groundNode = childNode(withName: "ground") as! SKSpriteNode
        ground = Limit(node: groundNode)
        
        // Ceil Node
        let ceilNode = childNode(withName: "ceil") as! SKSpriteNode
        ceil = Limit(node: ceilNode)
        
        
        // LifeBar Node
        let lifeBarParent = childNode(withName: "lifeBar")!
        let lifeBarNode = lifeBarParent.childNode(withName: "life") as! SKSpriteNode
        lifebar = Lifebar(lifeNode: lifeBarNode)
        
        // Background Node
        let backgroundNodes = [
            self.childNode(withName: "1") as! SKSpriteNode,
            self.childNode(withName: "2") as! SKSpriteNode,
            self.childNode(withName: "3") as! SKSpriteNode,
            self.childNode(withName: "4") as! SKSpriteNode,
            self.childNode(withName: "5") as! SKSpriteNode,
            self.childNode(withName: "6") as! SKSpriteNode,
            self.childNode(withName: "7") as! SKSpriteNode
        ]
        scenery = Scenery(nodes: backgroundNodes)
        
        
        // Intro Node
        introNode = childNode(withName: "intro") as? SKSpriteNode
        
        // Distance text
        distanceText = childNode(withName: "distanceText") as? SKLabelNode
        resetDistanceText()
        
        // Spawn Manager
        spawnManager = SpawnManager(parent: self)
        
        // Camera Manager
        cameraManager = CameraManager(parent: self)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            start()
        case .playing:
            player.jump()
        case .adChoice:
            print("Can see ad")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered - 60x/second
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        var deltaTime = currentTime - lastUpdate
        // Minimized app increases delta time, limits to 100 ms
        deltaTime = min(deltaTime, 0.1)
        lastUpdate = currentTime
        
        switch status {
        case .intro:
            playIntro(deltaTime: deltaTime)
        case .playing:
            playingUpdate(deltaTime: deltaTime)
        case .adChoice:
            break
        }
    }
    
    func playIntro(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        ceil.update(deltaTime: deltaTime)
        scenery.update(deltaTime: deltaTime)
    }
    
    
    func start() {
        status = .playing
        introNode.removeFromParent()
        player.start()
        Analytics.logEvent("level_start", parameters: nil)
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        ceil.update(deltaTime: deltaTime)
        scenery.update(deltaTime: deltaTime)
        spawnManager.updateObjects(deltaTime: deltaTime)
        distanceText.attributedText = GameManager.shared.updateDistance(deltaTime: deltaTime)
    }
    
    func adChoice() {
        if status == .adChoice {
            return
        }
        
        status = .adChoice
        gameVC.adChoice()

        player.die()
        LeaderboardManager.shared.updateScore(with: Int(GameManager.shared.distance))
        Analytics.logEvent("level_end", parameters: nil)
        Analytics.setUserProperty(GameManager.shared.distanceDisplayed.description, forName: "player_distance")
    }

    func rewardUser() {
        addChild(introNode)
        
        status = .intro
        player.reset(lifePoints: 50)
        lifebar.lifeUpdate(life: player.life)
    }
    
    func reset() {
        addChild(introNode)

        status = .intro
        spawnManager.resetSpawns()
        GameManager.shared.reset()
        resetDistanceText()
        player.reset(lifePoints: 100)
        lifebar.lifeUpdate(life: player.life)
        Analytics.logEvent("level_reset", parameters: nil)
    }
    
    func resetDistanceText() {
        let value = "0 m"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "SingleDay-Regular", size: 16)!]
        let finalString = NSAttributedString(string: value, attributes: attributes)
        distanceText.attributedText = finalString
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Pass which object colided with which object
        if contact.bodyA.node?.name == "player" {
            hasColided(other: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "player" {
            hasColided(other: contact.bodyA.node!)
        }
    }
    
    func hasColided(other: SKNode) {
        if status != .adChoice {
            let category = other.userData?.value(forKey: "category") as! String
            if  category == "obstacle" {
                obstacleCollision(node: other)
            } else if category == "life" {
                lifeCollision(node: other)
            }
            
            lifebar.lifeUpdate(life: player.life)
        }
    }
    
    private func obstacleCollision(node: SKNode) {
        guard let damage = spawnManager.getDamage(node: node),
              damage > 0 else {
                  return
              }

        AudioManager.shared.play(effect: Audio.EffectFiles.tum)
        hapticsManeger.vibrateByImpact(intensity: CGFloat(15))
        cameraManager.cameraShake(duration: 0.2)
        
        player.updateLife(points: -damage)
        
        if player.life == 0 {
            adChoice()
        }
    }
    
    private func lifeCollision(node: SKNode) {
        AudioManager.shared.play(effect: Audio.EffectFiles.life)
        hapticsManeger.vibrateByImpact(intensity: CGFloat(8))
        player.updateLife(points: 10)
        
        node.alpha = 0
    }
}
