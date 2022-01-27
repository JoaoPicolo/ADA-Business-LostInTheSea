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
    var introNode: SKSpriteNode!
    var gameOverNode: SKSpriteNode!
    var spawner: PipeSpawner!

    var lastUpdate = TimeInterval(0)
    var status: GameStatus = .intro
    
   override func didMove(to view: SKView) {
       physicsWorld.contactDelegate = self
       
       // Player Node
       let playerNode = childNode(withName: "Player") as! SKSpriteNode
       player = Player(node: playerNode)
       
       // Ground Node
       let groundNode = childNode(withName: "Ground") as! SKSpriteNode
       ground = Ground(node: groundNode)
       
       // Intro Node
       introNode = childNode(withName: "Intro") as? SKSpriteNode
       
       // Game over Node
       gameOverNode = childNode(withName: "GameOver") as? SKSpriteNode
       gameOverNode.removeFromParent()
       
       // Pipes spawner - Treat possible error later
       let pipesNode = childNode(withName: "Pipes")!
       spawner = PipeSpawner(pipesModel: pipesNode, parent: self)
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
    
    func start() {
        status = .playing
        introNode.removeFromParent()
        player.start()
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
        case .playing:
            playingUpdate(deltaTime: deltaTime)
        case .gameOver:
            break
        }
    }
    
    func playingUpdate(deltaTime: TimeInterval) {
        ground.update(deltaTime: deltaTime)
        spawner.update(deltaTime: deltaTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Pass which object colided with which object
        gameOver()
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
        spawner.reset()
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
