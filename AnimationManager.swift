import SpriteKit

@MainActor
class AnimationManager {
    private weak var scene: SKScene?

    init(scene: SKScene) {
        self.scene = scene
    }

    func showPartyEmoji(from position: CGPoint) {
        guard let scene = scene else { return }

        let emojiNode = SKLabelNode()
        emojiNode.text = "🥳"
        emojiNode.fontSize = 50
        emojiNode.position = CGPoint(x: position.x - 20, y: position.y + 20)
        emojiNode.zPosition = 15
        scene.addChild(emojiNode)

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let bounceSequence = SKAction.sequence([scaleUp, scaleDown])
        let animationGroup = SKAction.group([moveUp, fadeOut])
        let fullSequence = SKAction.sequence([
            bounceSequence, animationGroup, SKAction.removeFromParent(),
        ])

        emojiNode.run(fullSequence)
    }

    func showLaughEmoji(from position: CGPoint) {
        guard let scene = scene else { return }

        let emojiNode = SKLabelNode()
        emojiNode.text = "😂"
        emojiNode.fontSize = 50
        emojiNode.position = CGPoint(x: position.x + 20, y: position.y + 20)
        emojiNode.zPosition = 15
        scene.addChild(emojiNode)

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let bounceSequence = SKAction.sequence([scaleUp, scaleDown])
        let animationGroup = SKAction.group([moveUp, fadeOut])
        let fullSequence = SKAction.sequence([
            bounceSequence, animationGroup, SKAction.removeFromParent(),
        ])

        emojiNode.run(fullSequence)
    }

    func showScoreAnimation(
        from position: CGPoint, scoreChange: String, color: UIColor
    ) {
        guard let scene = scene else { return }

        let scoreNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreNode.text = scoreChange
        scoreNode.fontSize = 50
        scoreNode.fontColor = color
        scoreNode.position = position
        scoreNode.zPosition = 15
        scene.addChild(scoreNode)

        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 0.8)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.8)
        let animationGroup = SKAction.group([moveUp, fadeOut, scaleUp])
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([animationGroup, remove])

        scoreNode.run(sequence)
    }
}
