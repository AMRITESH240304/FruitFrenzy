import SpriteKit
import SwiftUI

class FruitBounceScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        spawnFruits(count: 5)

        let keepBouncing = SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run { self.reapplyBounce() },
        ])
        run(SKAction.repeatForever(keepBouncing))
    }

    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -10
        background.size = self.size
        background.alpha = 0.8
        addChild(background)
    }

    func spawnFruits(count: Int) {
        let fruitNames = ["strawberry", "apple", "banana", "grapes"]

        for _ in 0..<count {
            let randomFruit = fruitNames.randomElement()!
            let fruitTexture = SKTexture(imageNamed: randomFruit)
            let fruit = SKSpriteNode(texture: fruitTexture)
            fruit.size = CGSize(width: 60, height: 60)
            fruit.position = CGPoint(
                x: CGFloat.random(in: 50...size.width - 50),
                y: CGFloat.random(in: size.height * 0.5...size.height - 50)
            )
            fruit.physicsBody = SKPhysicsBody(
                circleOfRadius: fruit.size.width / 2)
            fruit.physicsBody?.restitution = 1.0
            fruit.physicsBody?.friction = 0.0
            fruit.physicsBody?.linearDamping = 0.0
            fruit.physicsBody?.angularDamping = 0.0
            fruit.physicsBody?.affectedByGravity = true
            fruit.physicsBody?.allowsRotation = true
            fruit.name = "bouncingFruit"
            addChild(fruit)

            let upwardForce = CGVector(dx: CGFloat.random(in: -1...1), dy: 5)
            fruit.physicsBody?.applyImpulse(upwardForce)
        }
    }

    func reapplyBounce() {
        enumerateChildNodes(withName: "bouncingFruit") { node, _ in
            if let physicsBody = node.physicsBody {
                let velocity = physicsBody.velocity
                let speed = sqrt(
                    velocity.dx * velocity.dx + velocity.dy * velocity.dy)
                if speed < 3.0 {
                    let upwardForce = CGVector(
                        dx: CGFloat.random(in: -1...1), dy: 5)
                    physicsBody.applyImpulse(upwardForce)
                }
            }
        }
    }
}
