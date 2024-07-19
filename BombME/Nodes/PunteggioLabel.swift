//
//  PunteggioLabel.swift
//  BombME
//
//  Created by Nicola Lauritano on 19/07/24.
//

import Foundation
import SpriteKit

class PunteggioLabel: SKLabelNode {
    
    var points: Int = 0 {
        didSet {
            self.text = "\(points)"
        }
    }
    
    init(sceneSize: CGSize) {
        super.init()

        fontColor = .white
        fontName = "menlo-Bold"
        fontSize = 75
        position = CGPoint(x: 0, y: 170)
        zPosition = -99
        text = "0"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPoints(scene: SKScene, points: Int, multiplier: Int) {
        let labelNode = SKLabelNode()
        labelNode.fontColor = points > 0 ? .blue : .red
        labelNode.fontName = "menlo-Bold"
        labelNode.fontSize = points > 0 ? 55 : 45
        labelNode.position = CGPoint(x: 0, y: points > 0 ? 115 : 125)
        labelNode.zPosition = -99
        labelNode.text = "\(points/multiplier)"
        
        scene.addChild(labelNode)
        let quarterWaitAction = SKAction.wait(forDuration: 0.25)
        let waitAction = SKAction.wait(forDuration: 1.0)
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: 170), duration: 0.2)
        let scaleAction = SKAction.scale(to: 0.6, duration: 0.2)
        let disappearAction = SKAction.group([moveAction, scaleAction])
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
        let changeTextAction: (String, UIColor) -> (SKAction) = { (text, color) in
            return SKAction.run {
                labelNode.fontColor = color
                labelNode.text = text
            }
        }
                                            
        
        var sequence: SKAction
        if multiplier < 2 {
            sequence = SKAction.sequence([waitAction, disappearAction])
        } else {
            sequence = SKAction.sequence([quarterWaitAction,
                                          fadeOutAction,
                                          changeTextAction("X\(multiplier)", .red),
                                          fadeInAction,
                                          quarterWaitAction,
                                          fadeOutAction,
                                          changeTextAction("\(points)", .blue),
                                          fadeInAction,
                                          waitAction,
                                          disappearAction
                                         ])
        }
        
        labelNode.run(sequence) {
            self.points += points
            self.blink(color: points > 0 ? .blue : .red)
            labelNode.removeFromParent()
        }
    }
    
    func blink(color: UIColor) {
        let sizeAction = SKAction.scale(to: 1.4, duration: 0.2)
        let resizeAction = SKAction.scale(to: 1, duration: 0.2)
        let colorifyActionBlue = SKAction.group([SKAction.wait(forDuration: 0.2) , SKAction.run {
            self.fontColor = color
        }])
        let colorifyActionWhite = SKAction.group([SKAction.wait(forDuration: 0.2) , SKAction.run {
            self.fontColor = .white
        }])
        
        let firstGroup = SKAction.group([sizeAction, colorifyActionBlue])
        let secondGroup = SKAction.group([resizeAction, colorifyActionWhite])
        
        let repeatAction = SKAction.sequence([firstGroup, secondGroup])
        self.run(repeatAction)
    }
    
}
