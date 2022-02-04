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
    var range: Int = 0
    var damage: CGFloat = 0
    var contactEnabled: Bool = true
    
//    init() {
//            let texture = SKTexture(imageNamed: "jeff")
//        super.init(texture: texture, color: .blue, size: texture.size())
//         // initialize what you need : self. ....
//        }
//    required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)!
//
//        }
       
//        init(frame: CGRect) {
//            super.init
//
//        }
//
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init
//
//        }
    
    
    init(place: ObjectPosition, imageSequence: [String], range: Int = 0, damage: CGFloat) {
     
        self.place = place
        self.imageSequence = imageSequence
        self.range = range
        self.damage = damage
        let texture = SKTexture(imageNamed: "life")
        super.init(texture: texture, color: .blue, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Obstacles {
    static let obstaclesBottom: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .bottom, imageSequence: ["seeweed1", "seeweed2", "seeweed3", "seeweed1"], damage: 100),
        ObstacleSpriteNode(place: .bottom, imageSequence: ["seeweeda1", "seeweeda2", "seeweeda3", "seeweeda1"], damage: 100)
    ]
    
    static let obstaclesTop: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .top, imageSequence:["seeweedb1", "seeweedb2","seeweedb3","seeweedb1"], damage: 100)
    ]
    
    static let obstaclesMiddle: [ObstacleSpriteNode] = [
        ObstacleSpriteNode(place: .middle, imageSequence: ["fish1", "fish2","fish1"], range: 10, damage: 200),
        ObstacleSpriteNode(place: .middle, imageSequence: ["star1", "star2","star3","star1"], range: 5, damage: 100),
        ObstacleSpriteNode(place: .middle, imageSequence: ["whale1", "whale2","whale3","whale1"], range: 5, damage: 800),
        ObstacleSpriteNode(place: .middle, imageSequence: ["turtle1", "turtle2","turtle3","turtle1"], range: 10, damage: 100),
        ObstacleSpriteNode(place: .middle, imageSequence: ["jelly1","jelly2","jelly3","jelly4","jelly1"], range: 10, damage: 200)
    ]
}

