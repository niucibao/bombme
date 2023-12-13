//
//  GameScene.swift
//  BombME
//
//  Created by Nicola Lauritano on 08/09/23.
//

import SpriteKit
import GameplayKit

class CategoryBitMask {
    static let borderCategory:       UInt32 = 0x1 << 0    // 0x0000001 1
    static let playerCategory:       UInt32 = 0x1 << 1    // 0x0000010 2
    static let opponentCategory:     UInt32 = 0x1 << 2    // 0x0000100 4
    static let floorCategory:        UInt32 = 0x1 << 3    // 0x0001000 8
    static let playerBombCategory:   UInt32 = 0x1 << 4    // 0x0010000 16
    static let opponentBombCategory: UInt32 = 0x1 << 5    // 0x0100000 32
}

class GameScene: SKScene {
    
    var player: PlayerNode?
    var opponent: PlayerNode?
    var cursonNode: CursorNode?
    var throwingNode: ThrowingNode?
    var paviments: [PavimentNode] = []
    var borderNode: BorderNode!
    
    var bombs: [BombNode] = []
    
    var lastTimeOpponentBomb: TimeInterval?
    
    let cropNode: SKCropNode! = SKCropNode()
    
    var numberOfSections = 2
    var sceneSize: CGSize { return CGSize(width: self.size.width - 200, height: self.size.height) }
    var rectWidth: CGFloat { return (sceneSize.width) / CGFloat(numberOfSections) }
    
    var viewController: GameViewController!
   
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        borderNode = BorderNode(color: .clear, size: self.size)
        borderNode.drawBorder(rectWidth: rectWidth)
        self.addChild(borderNode)
        
        startGame()
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        self.cursonNode = CursorNode(atPoint: pos, scene: self)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        guard let cursonNode = cursonNode else { return }
        removeThrowing()
        cursonNode.moveTo(point: pos)
        
        let cursorVector = cursonNode.getVector()
        self.throwingNode = ThrowingNode(startPosition: calculateBombStartPosition(isPlayer: true), lastPositionVector: cursorVector, scene: self)
        
        guard let throwingNode = throwingNode else { return }
        self.addChild(throwingNode)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        guard let cursonNode = cursonNode else { return }
        
        cursonNode.removeFromParent()
        removeThrowing()
        
        let impulse = cursonNode.getImpulse()
        
        
        guard !((impulse.dx < 0.2 && impulse.dx > -0.2) && (impulse.dy < 0.2 && impulse.dy > -0.2)) else {
            
            print(impulse)
            return
        }
        
        let bomb = BombNode(startPosition: calculateBombStartPosition(isPlayer: true), isPlayer: true)
        bombs.append(bomb)
        bomb.playThwowingSound()
        self.addChild(bomb)
        
        bomb.physicsBody?.applyImpulse(impulse)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = player, let _ = opponent else { return }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = player, let _ = opponent else { return }
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = player, let _ = opponent else { return }
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = player, let _ = opponent else { return }
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if opponent != nil {
            if let lastTimeOpponentBomb = lastTimeOpponentBomb {
                let delta = min(CGFloat(numberOfSections) / 10.0, 2.5)
                if currentTime - lastTimeOpponentBomb > 3.0 - delta {
                    
                    let bomb = BombNode(startPosition: calculateBombStartPosition(isPlayer: false), isPlayer: false)
                    bomb.playThwowingSound()
                    bombs.append(bomb)
                    self.addChild(bomb)
                    
                    let impulse = CGVector(dx: CGFloat.random(in: -4.0 ... -1), dy: CGFloat.random(in: 1.0 ... 4.0))
                
                    bomb.physicsBody?.applyImpulse(impulse)
                    
                    self.lastTimeOpponentBomb = nil
                }
            } else {
                lastTimeOpponentBomb = currentTime
            }
        } else {
            self.lastTimeOpponentBomb = nil
        }
        
        for bomb in bombs {
            if bomb.position.y > self.size.height / 2 {
                if let freccetta = bomb.freccetta {
                    freccetta.position.x = bomb.position.x
                    freccetta.isHidden = false
                } else {
                    bomb.createFreccette(initialX: bomb.position.x, floorPositionY: self.size.height / 2 - 80)
                    bomb.freccetta?.isHidden = true
                    self.addChild(bomb.freccetta!)
                }
            } else {
                bomb.deleteFreccetta()
            }
        }
    }
    
    func createPaviments() -> [PavimentNode] {
        var paviments = [PavimentNode]()
        for i in 0..<numberOfSections {
            
            let xPosition = -sceneSize.width/2 + rectWidth/2  + rectWidth * CGFloat(i)
//            let xPosition = (i+1) * ((sceneSize.width - 100.0) / CGFloat(numberOfSections + 2) )
            let height = CGFloat.random(in: sceneSize.height * 0.3 ... sceneSize.height * 0.6 )
            
            let rectangle = PavimentNode(color: .red, size: CGSize(width: rectWidth, height: height))
            rectangle.position = CGPoint(x: xPosition, y: (sceneSize.height - height) / -2 )
            rectangle.setup()
            
//            self.addChild(rectangle)
            
            paviments.append(rectangle)
        }
        
        return paviments
    }
    
    fileprivate func createPlayers() {
        let playerWidth = min(50, rectWidth / 4)
        let playerHeight = min(150, playerWidth * 3)
        let playerSize = CGSize(width: playerWidth, height: playerHeight)
        
        let randomIndex = Int.random(in: 0...min(2, numberOfSections/4))
        let effectivePosition = sceneSize.width / CGFloat(2 * numberOfSections)
        let playerX = sceneSize.width/2 - effectivePosition - (CGFloat(randomIndex) * rectWidth)
        let playerY = sceneSize.height / 2 - playerHeight*2 - 2
        self.player = PlayerNode(point: CGPoint(x: -playerX - (playerWidth/2) , y: playerY), size: playerSize, isPlayer: true)
        self.opponent = PlayerNode(point: CGPoint(x: playerX - (playerWidth/2), y: playerY), size: playerSize, isPlayer: false)
    }
    
    fileprivate func removeThrowing() {
        guard let throwingNode else { return }
        throwingNode.removeFromParent()
    }
    
    fileprivate func calculateBombStartPosition(isPlayer: Bool) -> CGPoint {
        guard let player = self.player, let opponent = self.opponent else { return .zero}
        
        return isPlayer ? player.calculateBombStartPosition() : opponent.calculateBombStartPosition()
    }
    
    fileprivate func appearWithTimer(timer: CGFloat, array: [PavimentNode], completion: (() -> ())?) {
        if array.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + timer * 10) {
                completion?()
            }
        } else {
            
            var tempArray = Array(array)
            let paviment = tempArray.removeFirst()
            
            paviment.appearOnSceneWithRandomAnimation(duration: 0.8, scene: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timer) {
                self.appearWithTimer(timer: timer, array: tempArray, completion: completion)
            }
        }
    }
    
    func restartGame(numberOfSections: Int) {
        var color: UIColor
        if numberOfSections == 2 {
            color = .red
        } else {
            color = .blue
        }
        
        let node = SKSpriteNode(color: color, size: self.size)
        node.position = .zero
        node.zPosition = 19
        node.alpha = 0
        let sequence = SKAction.sequence([SKAction.fadeAlpha(to: 0.9, duration: 0.3), SKAction.fadeAlpha(to: 0, duration: 0.3)])
        node.run(sequence) {
            node.removeFromParent()
        }
        self.addChild(node)
        
        self.numberOfSections = numberOfSections
        
        self.player = nil
        self.opponent = nil
        
        self.cursonNode?.removeFromParent()
        self.throwingNode?.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.disappearWithTimer(timer: 0.2, array: self.paviments) {
                self.children.forEach({$0.removeFromParent()})
                self.bombs = []
                self.startGame()
            }
        }
        
    }
    
    fileprivate func disappearWithTimer(timer: CGFloat, array: [PavimentNode], completion: (() -> ())?) {
        if array.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + timer * 10) {
                self.paviments.forEach({$0.removeFromParent()})
                self.paviments = []
                completion?()
            }
        } else {
            
            var tempArray = Array(array.shuffled())
            let paviment = tempArray.removeFirst()
            
            paviment.disappearFromSceneWithRandomAnumation(duration: 0.3)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timer) {
                self.disappearWithTimer(timer: timer, array: tempArray, completion: completion)
            }
        }
    }
    
    func startGame() {
        self.paviments = createPaviments()
        
        appearWithTimer(timer: 0.1, array: paviments) {
            self.createPlayers()
            
            guard let player = self.player, let opponent = self.opponent else { return }
            
            self.addChild(player)
            self.addChild(opponent)
        }
    }
    
    
}

extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let _ = player, let _ = opponent else { return }
        
        var nodeA: SKNode!
        var nodeB: SKNode!
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            nodeA = contact.bodyA.node
            nodeB = contact.bodyB.node
        } else if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            nodeB = contact.bodyA.node
            nodeA = contact.bodyB.node
        } else {
            print("CHIST E' O MUMENT, VUO VRE!?")
        }
        
        guard let nodeA = nodeA, let nodeB = nodeB else { return }
        
        switch nodeA.physicsBody?.categoryBitMask {
        case CategoryBitMask.borderCategory:
            if let _ = nodeA as? BorderNode, let player = nodeB as? PlayerNode {
                player.removeFromParent()
                self.restartGame(numberOfSections: player == opponent ? self.numberOfSections + 2 : 2 )
            } else if let _ = nodeA as? BorderNode, let bomb = nodeB as? BombNode {
                bomb.removeFromParent()
                bombs.removeAll(where: {$0 == bomb})
            }
        case CategoryBitMask.playerCategory:
            if let _ = nodeA as? PlayerNode, let bomb = nodeB as? BombNode {
                bomb.explode(scene: self, fakeExplosion: false)
                bombs.removeAll(where: {$0 == bomb})
                if bomb.physicsBody?.categoryBitMask == CategoryBitMask.opponentBombCategory {
                    restartGame(numberOfSections: 2)
                }
            }
        case CategoryBitMask.opponentCategory:
            if let _ = nodeA as? PlayerNode, let bomb = nodeB as? BombNode {
                bomb.explode(scene: self, fakeExplosion: true)
                bombs.removeAll(where: {$0 == bomb})
                if bomb.physicsBody?.categoryBitMask == CategoryBitMask.playerBombCategory {
                    restartGame(numberOfSections: self.numberOfSections + 2)
                }
            }
        case CategoryBitMask.floorCategory:
            if let floor = nodeA as? PavimentNode, let bomb = nodeB as? BombNode {
                
                let buildingPoint = convert(contact.contactPoint, to: floor)
                bomb.explode(scene: self, fakeExplosion: false)
                bombs.removeAll(where: {$0 == bomb})
                floor.pertosa(at: buildingPoint)
            }
        default:
            print("ESTIQUARTZI")
        }
    
        
        
    }
    
}
