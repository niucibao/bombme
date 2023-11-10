//
//  PlayerNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 26/09/23.
//

import UIKit
import SpriteKit

class PlayerNode: SKShapeNode {
    
    var isPlayer: Bool = true
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(point: CGPoint, size: CGSize, isPlayer: Bool) {
        
        self.init(rect: CGRect(origin: point, size: size), cornerRadius: 0)
        self.isPlayer = isPlayer
        self.fillColor = isPlayer ? UIColor.blue : UIColor.red
        self.strokeColor = .clear
        self.physicsBody?.isDynamic = true
        self.physicsBody?.mass = 0.01
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.collisionBitMask = CategoryBitMask.floorCategory | (isPlayer ? CategoryBitMask.opponentBombCategory : CategoryBitMask.playerBombCategory)
        self.physicsBody?.categoryBitMask = isPlayer ? CategoryBitMask.playerCategory : CategoryBitMask.opponentCategory
        self.physicsBody?.contactTestBitMask = isPlayer ? CategoryBitMask.opponentBombCategory : CategoryBitMask.playerBombCategory
        
    }
    
    func calculateBombStartPosition() -> CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 2 , y: self.frame.origin.y + self.frame.height + 10)
    }

}
