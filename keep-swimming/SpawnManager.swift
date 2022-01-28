//
//  SpawnManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 28/01/22.
//

import Foundation
import SpriteKit

enum ObstaclePosition: CaseIterable {
    case bottom
    case middle
    case top
}

class SpawnManager {
    private var parent: SKNode!
    private var spawnBottom: ObstacleSpawner!
    private var spawnMiddle: ObstacleSpawner!
    private var spawnTop: ObstacleSpawner!

    init(parent: SKNode) {
        self.parent = parent
        setSpawnObstacles()
    }
    
    func setSpawnObstacles() {
        let bottomNode = parent.childNode(withName: "bottomObstacle") as! SKSpriteNode
        spawnBottom = ObstacleSpawner(obstacleNode: bottomNode, obstaclePos: .bottom, parent: parent, interval: TimeInterval(2))
        
        let middleNode = parent.childNode(withName: "middleObstacle") as! SKSpriteNode
        spawnMiddle = ObstacleSpawner(obstacleNode: middleNode, obstaclePos: .middle, parent: parent, interval: TimeInterval(1.5))
        
        let topNode = parent.childNode(withName: "topObstacle") as! SKSpriteNode
        spawnTop = ObstacleSpawner(obstacleNode: topNode, obstaclePos: .top, parent: parent, interval: TimeInterval(2))
    }
    
    func updateSpawns(deltaTime: TimeInterval) {
        spawnBottom.update(deltaTime: deltaTime)
        spawnMiddle.update(deltaTime: deltaTime)
        spawnTop.update(deltaTime: deltaTime)
    }
    
    func resetSpawns() {
        spawnBottom.reset()
        spawnMiddle.reset()
        spawnTop.reset()
    }
}
