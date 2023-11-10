//
//  FreccettaNode.swift
//  BombME
//
//  Created by Nicola Lauritano on 10/11/23.
//

import Foundation
import SpriteKit

class FreccettaNode: SKShapeNode {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(floorPositionY: CGFloat, startPositionX: CGFloat, isPlayer: Bool) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startPositionX, y: floorPositionY + 10))
        path.addLine(to: CGPoint(x: startPositionX - 5, y: floorPositionY))
        path.addLine(to: CGPoint(x: startPositionX + 5, y: floorPositionY))
        path.close()
        
        let shape = SKShapeNode(path: path.cgPath)
        shape.strokeColor = .white
        shape.fillColor = isPlayer ? .blue : .red
        self.init()
        self.addChild(shape)
        
        
    }
}
