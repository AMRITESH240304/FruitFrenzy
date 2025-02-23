import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var baseShape: SKShapeNode!
    var touchOffset: CGPoint = .zero

    private var physicsManager: PhysicsManager!
    private var difficultyManager: GameDifficultyManager!
    private var animationManager: AnimationManager!
    private var scoreboardManager: ScoreboardManager!
    private var fruitSpawner: FruitSpawner!
    private var countdownManager: CountdownManager!

    var score: Int = 0 {
        didSet {
            scoreboardManager.scoreLabel.text = "Score: \(score)"
            scoreboardManager.shadowLabel.text =
                scoreboardManager.scoreLabel.text
            if score >= 5 {
                difficultyManager.updateDifficulty(basedOnScore: score)
            }
        }
    }
    var targetFruit: String = ""
    var gamePaused: Bool = false

    override func didMove(to view: SKView) {
        if let window = view.window {
            _ = window.safeAreaInsets
            setupBackground()
            backgroundColor = .black

            physicsManager = PhysicsManager(scene: self)
            physicsManager.createBottomBoundary(size: size)

            fruitSpawner = FruitSpawner(
                scene: self, physicsManager: physicsManager)
            difficultyManager = GameDifficultyManager(
                scene: self, fruitSpawner: fruitSpawner)
            animationManager = AnimationManager(scene: self)
            scoreboardManager = ScoreboardManager(scene: self)
            countdownManager = CountdownManager(scene: self) {
                self.startGame()
            }

            scoreboardManager.setupScoreBoard(size: size, view: view)
            countdownManager.startCountdown()
        }
    }

    func updateGravity(for level: Int) {
        physicsManager.updateGravity(for: level)
    }

    func startGame() {
        let spawnAction = SKAction.sequence([
            SKAction.run { self.fruitSpawner.spawnFruits(count: 5) },
            SKAction.wait(forDuration: 2.0),
        ])
        run(SKAction.repeatForever(spawnAction), withKey: "spawnAction")
        startNewRound()
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if let fruit = node as? SKSpriteNode,
                fruit.name == "strawberry" || fruit.name == "apple"
                    || fruit.name == "banana" || fruit.name == "grapes"
                    || fruit.name == "bomb"
            {
                if fruit.position.y < -700 {
                    fruit.removeFromParent()
                    print("Fruit removed: \(fruit.name ?? "unknown")")
                }
            }
        }
    }

    func startNewRound() {
        let fruitNames = ["strawberry", "apple", "banana", "grapes"]
        targetFruit = fruitNames.randomElement()!
        let fruitTexture = SKTexture(imageNamed: targetFruit)
        scoreboardManager.targetFruitLabel?.texture = fruitTexture

        gamePaused = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.gamePaused = false
            self.unpauseFruits()
            self.scoreboardManager.targetFruitLabel?.texture = nil
            self.startNewRound()
        }
    }

    func pauseFruits() {
        enumerateChildNodes(withName: "*") { node, _ in
            node.physicsBody?.isDynamic = false
        }
    }

    func unpauseFruits() {
        enumerateChildNodes(withName: "*") { node, _ in
            node.physicsBody?.isDynamic = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let touchedNode = nodes(at: location).first as? SKSpriteNode,
            let fruitName = touchedNode.name
        {

            if gamePaused {
                if fruitName == targetFruit {
                    let sound = SKAction.playSoundFileNamed(
                        "timerup.wav", waitForCompletion: false)
                    run(sound)
                    score += 1
                    animationManager.showScoreAnimation(
                        from: touchedNode.position, scoreChange: "+1",
                        color: .yellow)
                    animationManager.showPartyEmoji(from: touchedNode.position)
                } else {
                    if fruitName != "bomb" {
                        score -= 1
                        animationManager.showScoreAnimation(
                            from: touchedNode.position, scoreChange: "-1",
                            color: .red)
                        animationManager.showLaughEmoji(
                            from: touchedNode.position)
                    } else {
                        score = 0
                        difficultyManager.currentLevel = 0
                        triggerBombBlast(
                            at: touchedNode.position, node: touchedNode)
                    }
                }
            }

            let highlightColor: UIColor
            switch fruitName {
            case "strawberry": highlightColor = .red
            case "apple": highlightColor = .green
            case "banana": highlightColor = .yellow
            case "grapes": highlightColor = .purple
            default: highlightColor = .white
            }
            touchedNode.color = highlightColor
            touchedNode.colorBlendFactor = 0.5

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let scaleUp = SKAction.scale(to: 1.3, duration: 0.1)
                let scaleDown = SKAction.scale(to: 0.8, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let remove = SKAction.removeFromParent()
                let animationSequence = SKAction.sequence([
                    scaleUp, scaleDown, fadeOut, remove,
                ])
                touchedNode.run(animationSequence)
            }
        }
    }

    func triggerBombBlast(at position: CGPoint, node: SKSpriteNode) {
        let explosionSound = SKAction.playSoundFileNamed(
            "explosion.mp3", waitForCompletion: false)
        run(explosionSound)

        node.physicsBody?.isDynamic = false

        let scaleUp = SKAction.scale(to: 2.0, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let bombSequence = SKAction.sequence([scaleUp, fadeOut, remove])

        node.run(bombSequence)

        let blastEmitter = SKEmitterNode()
        blastEmitter.position = position
        blastEmitter.zPosition = 10

        blastEmitter.particleTexture = SKTexture(imageNamed: "spark")
        blastEmitter.particleBirthRate = 200
        blastEmitter.numParticlesToEmit = 100
        blastEmitter.particleLifetime = 0.5
        blastEmitter.emissionAngleRange = 360
        blastEmitter.particleSpeed = 150
        blastEmitter.particleScale = 0.2
        blastEmitter.particleScaleRange = 0.1
        blastEmitter.particleAlpha = 1.0
        blastEmitter.particleAlphaRange = 0.5
        blastEmitter.particleColor = .orange
        blastEmitter.particleColorBlendFactor = 1.0

        addChild(blastEmitter)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            blastEmitter.removeFromParent()
        }
    }

    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
    }
}
