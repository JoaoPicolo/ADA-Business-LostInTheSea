//
//  GameScene.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 27/01/22.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: Player!
    var ground: Ground!
    var ceil: Ground!
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    var spawnManager: SpawnManager!
    
    var distanceText: SKLabelNode!

    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
   override func didMove(to view: SKView) {
       physicsWorld.contactDelegate = self
       
       // Player Node
       let playerNode = childNode(withName: "player") as! SKSpriteNode
       player = Player(node: playerNode)

       // Ground Node
       let groundNode = childNode(withName: "ground") as! SKSpriteNode
       ground = Ground(node: groundNode)
       
       // Ceil Node
       let ceilNode = childNode(withName: "ceil") as! SKSpriteNode
       ceil = Ground(node: ceilNode)
       
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
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        switch status {
        case .intro:
            ground.update(deltaTime: deltaTime)
            ceil.update(deltaTime: deltaTime)
        case .playing:
            playingUpdate(deltaTime: deltaTime)
        case .gameOver:
            break
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        ceil.update(deltaTime: deltaTime)
        spawnManager.updateSpawns(deltaTime: deltaTime)
        distanceText.attributedText = GameManager.updateDistance(deltaTime: deltaTime)
    }
    
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
    
    func start() {
        status = .playing
        introNode.removeFromParent()
        player.start()
    }
    
    func gameOver() {
        if status == .gameOver {
            return
        }

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
