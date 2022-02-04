//
//  Obstacles.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 03/02/22.
//

import SpriteKit

class ObstacleSpriteNode: SKSpriteNode {
    var place: ObjectPosition = .bottom
    var imageSequence: [String] = []
    var range: CGFloat = 0
    var damage: CGFloat = 0
    var scale: CGFloat = 1
    var contactEnabled: Bool = true
    
    init(place: ObjectPosition, imageSequence: [String], range: CGFloat = 0, damage: CGFloat, scale: CGFloat = 1) {
        self.place = place
        self.imageSequence = imageSequence
        self.range = range
        self.damage = damage
        self.scale = scale
        let texture = SKTexture(imageNamed: "life")
        super.init(texture: texture, color: .blue, size: texture.size())
        self.userData = NSMutableDictionary()
        self.userData?.setValue("obstacle", forKey: "category")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func copy() -> ObstacleSpriteNode {
        let obstacle = ObstacleSpriteNode(place: place, imageSequence: imageSequence, range: range, damage: damage)
        obstacle.yScale = scale
        obstacle.xScale = scale
        return obstacle
    }
}

struct Obstacles {
    static let obstaclesBottom: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .bottom, imageSequence: ["seeweed1", "seeweed2", "seeweed3", "seeweed1"], damage: 10),
        ObstacleSpriteNode(place: .bottom, imageSequence: ["seeweeda1", "seeweeda2", "seeweeda3", "seeweeda1"], damage: 10)
    ]
    
    static let obstaclesTop: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .top, imageSequence:["seeweedb1", "seeweedb2","seeweedb3","seeweedb1"], damage: 10)
    ]
    
    static let obstaclesMiddle: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .middle, imageSequence: ["fish1", "fish2","fish1"], range: 10, damage: 20),
        ObstacleSpriteNode(place: .middle, imageSequence: ["star1", "star2","star3","star1"], range: 5, damage: 10),
        ObstacleSpriteNode(place: .middle, imageSequence: ["whale1", "whale2","whale3","whale1"], range: 5, damage: 80, scale: 0.5),
        ObstacleSpriteNode(place: .middle, imageSequence: ["turtle1", "turtle2","turtle3","turtle1"], range: 10, damage: 10),
        ObstacleSpriteNode(place: .middle, imageSequence: ["jelly1","jelly2","jelly3","jelly4","jelly1"], range: 10, damage: 20)
    ]
}

