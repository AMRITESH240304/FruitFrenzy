import SpriteKit

@MainActor
class FruitSpawner {
    private weak var scene: SKScene?
    private let physicsManager: PhysicsManager

    init(scene: SKScene, physicsManager: PhysicsManager) {
        self.scene = scene
        self.physicsManager = physicsManager
    }

    func spawnFruits(count: Int) {
        guard let scene = scene else { return }

        let fruitNames = ["strawberry", "apple", "banana", "grapes", "bomb"]
        let spawnSequence = SKAction.sequence([
            SKAction.run {
                let randomFruit = fruitNames.randomElement()!
                let fruitTexture = SKTexture(imageNamed: randomFruit)
                let fruit = SKSpriteNode(texture: fruitTexture)
                fruit.size = CGSize(width: 60, height: 60)
                fruit.position = CGPoint(
                    x: CGFloat.random(in: 50...scene.size.width - 50), y: 50)
                fruit.name = randomFruit
                fruit.physicsBody = SKPhysicsBody(
                    circleOfRadius: fruit.size.width / 2)
                fruit.physicsBody?.restitution = 0.4
                fruit.physicsBody?.affectedByGravity = true
                fruit.physicsBody?.allowsRotation = true
                fruit.physicsBody?.categoryBitMask =
                    self.physicsManager.fruitCategory
                fruit.physicsBody?.contactTestBitMask =
                    self.physicsManager.bottomCategory
                fruit.physicsBody?.collisionBitMask =
                    self.physicsManager.bottomCategory
                scene.addChild(fruit)

                let targetHeight = scene.size.height * 1.5
                let gravity = -2.5  // Base gravity for calculation
                let timeToPeak = sqrt(2 * targetHeight / -gravity)
                let initialVelocity = -gravity * timeToPeak
                let upwardForce = CGVector(
                    dx: CGFloat.random(in: -1...2), dy: initialVelocity)
                fruit.physicsBody?.applyImpulse(upwardForce)
            },
            SKAction.wait(forDuration: 0.15),
        ])
        scene.run(SKAction.repeat(spawnSequence, count: count))
    }
}
