import SpriteKit

@MainActor
class PhysicsManager: NSObject, @preconcurrency SKPhysicsContactDelegate {
    let fruitCategory: UInt32 = 0x1 << 0
    let bottomCategory: UInt32 = 0x1 << 1
    weak var scene: SKScene?

    init(scene: SKScene) {
        self.scene = scene
        super.init()
        setupPhysicsWorld()
    }

    private func setupPhysicsWorld() {
        guard let scene = scene else { return }
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -2.5)
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        scene.physicsWorld.contactDelegate = self
    }

    func createBottomBoundary(size: CGSize) {
        let bottom = SKNode()
        bottom.position = CGPoint(x: size.width / 2, y: 10)
        bottom.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: size.width, height: 20))
        bottom.physicsBody?.isDynamic = false
        bottom.physicsBody?.categoryBitMask = bottomCategory
        bottom.physicsBody?.contactTestBitMask = fruitCategory
        scene?.addChild(bottom)
    }

    func updateGravity(for level: Int) {
        switch level {
        case 1: scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -2.5)
        case 2: scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        case 3: scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -3.5)
        case 4: scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -4.0)
        default: scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -2.5)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        if bodyA?.physicsBody?.categoryBitMask == bottomCategory
            || bodyB?.physicsBody?.categoryBitMask == bottomCategory
        {
            bodyA?.removeFromParent()
            bodyB?.removeFromParent()
        } else {
            bodyB?.removeFromParent()
        }
    }
}
