//
//  SpawnManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 28/01/22.
//

import Foundation
import SpriteKit

enum ObjectPosition: CaseIterable {
    case bottom
    case middle
    case top
}

struct ObjectType {
    var bottom = "bottomObstacle"
    var middle = "middleObstacle"
    var top = "topObstacle"
}


class SpawnManager {
    private var parent: SKNode!
    private var bottomObstacle: ObstacleSpawner!
    private var middleObstacle: ObstacleSpawner!
    private var topObstacle: ObstacleSpawner!
    private var types = ObjectType()
    
    private var life: Life!
    
    init(parent: SKNode) {
        self.parent = parent
        setSpawnObstacles()
    }
    
    func setSpawnObstacles() {
        let bottomNode = parent.childNode(withName: types.bottom) as! SKSpriteNode
        bottomObstacle = ObstacleSpawner(node: bottomNode, position: .bottom, parent: parent, upperInterval: CGFloat(5))
        
        let middleNode = parent.childNode(withName: types.middle) as! SKSpriteNode
        middleObstacle = ObstacleSpawner(node: middleNode, position: .middle, parent: parent, upperInterval: CGFloat(3))
        
        let topNode = parent.childNode(withName: types.top) as! SKSpriteNode
        topObstacle = ObstacleSpawner(node: topNode, position: .top, parent: parent, upperInterval: CGFloat(4))
        
        let lifeNode = parent.childNode(withName: "life") as! SKSpriteNode
        life = Life(node: lifeNode, position: .middle, parent: parent, upperInterval: CGFloat(25))
    }
    
    func updateSpawns(deltaTime: TimeInterval) {
        bottomObstacle.update(deltaTime: deltaTime)
        middleObstacle.update(deltaTime: deltaTime)
        topObstacle.update(deltaTime: deltaTime)
        life.update(deltaTime: deltaTime)
    }
    
    func getDamage(node: SKNode) -> CGFloat {
        guard let obstacle = node as? ObstacleSpriteNode else {
            return 20
        }
        return obstacle.damage
    }
    
    func resetSpawns() {
        bottomObstacle.reset()
        middleObstacle.reset()
        topObstacle.reset()
        life.reset()
    }
}
