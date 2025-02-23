import SpriteKit

@MainActor
class CountdownManager {
    private weak var scene: SKScene?
    private let onCountdownComplete: () -> Void
    
    init(scene: SKScene, onComplete: @escaping () -> Void) {
        self.scene = scene
        self.onCountdownComplete = onComplete
    }
    
    func startCountdown() {
        guard let scene = scene else { return }
        
        let countdownLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        countdownLabel.fontSize = 100
        countdownLabel.fontColor = .white
        countdownLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        countdownLabel.zPosition = 20
        scene.addChild(countdownLabel)
        
        let countdownSequence = SKAction.sequence([
            SKAction.run {
                countdownLabel.text = "3"
                scene.run(SKAction.playSoundFileNamed("timer", waitForCompletion: false))
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                countdownLabel.text = "2"
                scene.run(SKAction.playSoundFileNamed("timer", waitForCompletion: false))
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                countdownLabel.text = "1"
                scene.run(SKAction.playSoundFileNamed("timer", waitForCompletion: false))
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                countdownLabel.text = "GO"
                scene.run(SKAction.playSoundFileNamed("timerup", waitForCompletion: false))
            },
            SKAction.wait(forDuration: 1.0),
            SKAction.run {
                countdownLabel.removeFromParent()
                self.onCountdownComplete()
            },
        ])
        
        scene.run(countdownSequence)
    }
}
