//
//  GameScene.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    // Nodes
    var player: Player!
    var ground: Limit!
    var ceil: Limit!
    var lifebar: Lifebar!
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    var distanceText: SKLabelNode!
    
    
    // Managers
    var spawnManager: SpawnManager!
    var cameraManager: CameraManager!
    var hapticsManeger = HapticsManager()
    
    // Control
    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
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
        
        
        // Intro Node
        introNode = childNode(withName: "intro") as? SKSpriteNode
        
        // Game over Node
        gameOverNode = childNode(withName: "gameOver") as? SKSpriteNode
        gameOverNode.removeFromParent()
        
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
        case .gameOver:
            reset()
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
        case .gameOver:
            break
        }
    }
    
    func playIntro(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        ceil.update(deltaTime: deltaTime)
    }
    
    
    func start() {
        status = .playing
        introNode.removeFromParent()
        player.start()
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        ceil.update(deltaTime: deltaTime)
        spawnManager.updateObjects(deltaTime: deltaTime)
        distanceText.attributedText = GameManager.shared.updateDistance(deltaTime: deltaTime)
    }
    
    func gameOver() {
        if status == .gameOver {
            return
        }
        
        LeaderboardManager.shared.updateScore(with: Int(GameManager.shared.distance))
        addChild(gameOverNode)
        player.die()
        status = .gameOver
    }
    
    func reset() {
        gameOverNode.removeFromParent()
        addChild(introNode)
        
        status = .intro
        
        player.reset()
        spawnManager.resetSpawns()
        resetDistanceText()
        GameManager.shared.reset()
        lifebar.lifeUpdate(life: player.life)
    }
    
    func resetDistanceText() {
        let value = "0 m"
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
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
        if status != .gameOver {
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
        AudioManager.shared.play(effect: Audio.EffectFiles.tum)
        hapticsManeger.vibrateByImpact(intensity: CGFloat(15))
        cameraManager.cameraShake(duration: 0.2)

        let damage = spawnManager.getDamage(node: node)
        player.updateLife(points: -damage)
        
        if player.life == 0 {
            gameOver()
        }
    }
    
    private func lifeCollision(node: SKNode) {
        AudioManager.shared.play(effect: Audio.EffectFiles.life)
        hapticsManeger.vibrateByImpact(intensity: CGFloat(8))
        player.updateLife(points: 10)

        node.alpha = 0
    }
    
}
