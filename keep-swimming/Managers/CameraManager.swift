//
//  CameraManager.swift
//  keep-swimming
//
//  Created by João Pedro Picolo on 05/02/22.
//

import Foundation
import SpriteKit

class CameraManager {
    private var parent: GameScene
    
    init(parent: GameScene) {
        self.parent = parent
    }
    
    func cameraShake(duration: CGFloat) {
        let size = CGFloat(5)
        
        var currentDuration = CGFloat(0)
        let iterationDuration = TimeInterval(0.07)
        
        let originalPosition = parent.camera?.position ?? CGPoint.zero
        
        _ = Timer.scheduledTimer(withTimeInterval: iterationDuration, repeats: true, block: { (timer) in
            if currentDuration > duration {
                timer.invalidate()
                self.parent.camera?.position = originalPosition
                return
            }
            
            let randomX = CGFloat.random(in: -size...size)
            let randomY = CGFloat.random(in: -size...size)
            
            self.parent.camera?.position = originalPosition + CGPoint(x: randomX, y: randomY)
            
            currentDuration += CGFloat(iterationDuration)
        })
    }
}
