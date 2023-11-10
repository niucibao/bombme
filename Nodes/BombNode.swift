//
//  BombNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 26/09/23.
//

import UIKit
import SpriteKit

class BombNode: SKShapeNode {
    
    var freccetta: FreccettaNode?
    var isPlayer: Bool = false
    
    convenience init(startPosition: CGPoint, isPlayer: Bool) {
        self.init(circleOfRadius: 5)
        self.isPlayer = isPlayer
        self.fillColor = isPlayer ? .cyan : .orange
        self.position = startPosition
        self.physicsBody = SKPhysicsBody(circleOfRadius: 5)
//        self.physicsBody?.mass = 1
        self.physicsBody?.affectedByGravity = true
        self.strokeColor = .clear
        self.physicsBody?.categoryBitMask = isPlayer ? CategoryBitMask.playerBombCategory : CategoryBitMask.opponentBombCategory
        self.physicsBody?.collisionBitMask = CategoryBitMask.floorCategory
        self.physicsBody?.contactTestBitMask = (isPlayer ? CategoryBitMask.opponentCategory : CategoryBitMask.playerCategory) | CategoryBitMask.floorCategory
    }
    
    func explode(scene: SKScene, at point: CGPoint? = nil, fakeExplosion: Bool) {
        let explosion = ExplosionNode(startPosition: point ?? self.position, fakeExplosion: fakeExplosion)
        scene.addChild(explosion)
        explosion.explode()
        
        self.physicsBody?.collisionBitMask = 0
        self.removeFromParent()
    }
    
    func createFreccette(initialX: CGFloat, floorPositionY: CGFloat) {
        self.freccetta = FreccettaNode(floorPositionY: floorPositionY, startPositionX: 0, isPlayer: self.isPlayer)
    }
    
    func deleteFreccetta() {
        if freccetta != nil {
            self.freccetta?.removeFromParent()
            self.freccetta = nil
        }
    }

}
