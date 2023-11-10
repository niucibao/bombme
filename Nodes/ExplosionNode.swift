//
//  ExplosionNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 27/09/23.
//

import UIKit
import SpriteKit

class ExplosionNode: SKShapeNode {

    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(startPosition: CGPoint, fakeExplosion: Bool) {
        self.init(circleOfRadius: 20)
        self.position = startPosition
        self.fillColor = .lightGray
        self.strokeColor = .clear
        self.zPosition = 2
    
//        if fakeExplosion {
//            let fakeExplosion = SKShapeNode(circleOfRadius: 20)
//            fakeExplosion.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//            fakeExplosion.setScale(0)
//            fakeExplosion.physicsBody?.mass = 10000
//            fakeExplosion.physicsBody?.isDynamic = false
//            self.addChild(fakeExplosion)
//            
//            fakeExplosion.run(SKAction.sequence([
//                SKAction.fadeOut(withDuration: 0.0),
//                SKAction.scale(to: 20, duration: 0.5),
//                SKAction.removeFromParent()
//            ]))
//        }
        
        explode()
    }
    
    func explode() {
        self.setScale(0.0)
        let grow = SKAction .scale(to: 1, duration: 0.1)
        let fade = SKAction.fadeAlpha(to: 0, duration: 1.0)
        
        self.run (grow)
        self.run(fade) {
            self.removeFromParent()
        }
        
        
    }
}
