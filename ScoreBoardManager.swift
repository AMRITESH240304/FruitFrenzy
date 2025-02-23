import SpriteKit
import SwiftUI

@MainActor
class ScoreboardManager {
    private weak var scene: GameScene?

    var scoreLabel: SKLabelNode!
    var shadowLabel: SKLabelNode!
    var targetFruitLabel: SKSpriteNode!

    init(scene: GameScene) {
        self.scene = scene
    }

    func setupScoreBoard(size: CGSize, view: SKView?) {
        guard let scene = scene else { return }

        let scoreboardWidth = size.width * 0.9
        let scoreBoardImage = SKSpriteNode(imageNamed: "scoreBoard")
        scoreBoardImage.size = CGSize(width: scoreboardWidth, height: 80)

        if let view = view {
            let safeAreaTop = view.safeAreaInsets.top
            scoreBoardImage.position = CGPoint(
                x: size.width / 2,
                y: size.height - safeAreaTop - scoreBoardImage.size.height / 2
            )
        } else {
            scoreBoardImage.position = CGPoint(
                x: size.width / 2,
                y: size.height - scoreBoardImage.size.height / 2
            )
        }

        scoreBoardImage.zPosition = 10
        scene.addChild(scoreBoardImage)

        let labelOffset = scoreboardWidth / 4

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .yellow
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: -labelOffset, y: -10)
        scoreLabel.zPosition = 11

        shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        shadowLabel.fontSize = scoreLabel.fontSize
        shadowLabel.fontColor = .black.withAlphaComponent(0.7)
        shadowLabel.text = scoreLabel.text
        shadowLabel.position = CGPoint(x: -labelOffset + 2, y: -11)
        shadowLabel.zPosition = 10

        scoreBoardImage.addChild(shadowLabel)
        scoreBoardImage.addChild(scoreLabel)

        let clickLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        clickLabel.fontSize = 40
        clickLabel.fontColor = .white
        clickLabel.text = "Click: "
        clickLabel.horizontalAlignmentMode = .right
        clickLabel.position = CGPoint(x: labelOffset + 20, y: -10)
        clickLabel.zPosition = 11
        scoreBoardImage.addChild(clickLabel)

        targetFruitLabel = SKSpriteNode()
        let isIphone = UIDevice.current.userInterfaceIdiom == .phone
        targetFruitLabel.size =
            isIphone
            ? CGSize(width: 40, height: 40) : CGSize(width: 70, height: 70)
        targetFruitLabel.position = CGPoint(x: labelOffset + 50, y: 0)
        targetFruitLabel.zPosition = 11
        scoreBoardImage.addChild(targetFruitLabel)

        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let pulseSequence = SKAction.sequence([scaleUp, scaleDown])
        targetFruitLabel.run(SKAction.repeatForever(pulseSequence))
    }
}
