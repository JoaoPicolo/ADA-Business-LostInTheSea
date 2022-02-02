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
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    var distanceText: SKLabelNode!

    // Managers
    var spawnManager: SpawnManager!
    
    // Control
    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
    var updateScoreCallback: (Int) -> Void = { _ in }
    
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
        spawnManager.updateSpawns(deltaTime: deltaTime)
        distanceText.attributedText = GameManager.updateDistance(deltaTime: deltaTime)
    }
    
    func gameOver() {
        if status == .gameOver {
            return
        }

        updateScoreCallback(Int(GameManager.distance))
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
        GameManager.reset()
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
        let category = other.userData?.value(forKey: "category") as! String
        if  category == "obstacle" {
            gameOver()
        }
    }
}
