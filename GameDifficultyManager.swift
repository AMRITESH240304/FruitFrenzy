import SpriteKit

@MainActor
class GameDifficultyManager {
    private weak var scene: GameScene?
    private let fruitSpawner: FruitSpawner
    private var spawnActionKey = "spawnAction"

    var currentLevel: Int = 0 {
        didSet {
            if currentLevel != oldValue {
                notifyLevelChange()
                applyLevelSettings()
            }
        }
    }

    init(scene: GameScene, fruitSpawner: FruitSpawner) {
        self.scene = scene
        self.fruitSpawner = fruitSpawner
    }

    func updateDifficulty(basedOnScore score: Int) {
        let newLevel: Int
        switch score {
        case 0..<5: newLevel = 1
        case 5..<10: newLevel = 2
        case 10..<15: newLevel = 3
        case 15...Int.max: newLevel = 4
        default: newLevel = 1
        }

        if newLevel != currentLevel {
            currentLevel = newLevel
        }
    }

    private func notifyLevelChange() {
        guard let scene = scene else { return }

        let levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        levelLabel.fontSize = 100
        levelLabel.fontColor = .white
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.position = CGPoint(
            x: scene.size.width / 2, y: scene.size.height / 2)
        levelLabel.zPosition = 20
        scene.addChild(levelLabel)

        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut, remove])
        levelLabel.run(sequence)
    }

    private func applyLevelSettings() {
        guard let scene = scene else { return }

        scene.updateGravity(for: currentLevel)
        scene.removeAction(forKey: spawnActionKey)

        let spawnAction: SKAction
        switch currentLevel {
        case 1:
            spawnAction = SKAction.sequence([
                SKAction.run { self.fruitSpawner.spawnFruits(count: 5) },
                SKAction.wait(forDuration: 2.0),
            ])
        case 2:
            let sound = SKAction.playSoundFileNamed(
                "levelUp.wav", waitForCompletion: false)
            scene.run(sound)
            spawnAction = SKAction.sequence([
                SKAction.run { self.fruitSpawner.spawnFruits(count: 6) },
                SKAction.wait(forDuration: 1.8),
            ])
        case 3:
            let sound = SKAction.playSoundFileNamed(
                "levelUp.wav", waitForCompletion: false)
            scene.run(sound)
            spawnAction = SKAction.sequence([
                SKAction.run { self.fruitSpawner.spawnFruits(count: 7) },
                SKAction.wait(forDuration: 1.5),
            ])
        case 4:
            let sound = SKAction.playSoundFileNamed(
                "levelUp.wav", waitForCompletion: false)
            scene.run(sound)
            spawnAction = SKAction.sequence([
                SKAction.run { self.fruitSpawner.spawnFruits(count: 8) },
                SKAction.wait(forDuration: 1.2),
            ])
        default:
            spawnAction = SKAction.sequence([
                SKAction.run { self.fruitSpawner.spawnFruits(count: 5) },
                SKAction.wait(forDuration: 2.0),
            ])
        }

        scene.run(SKAction.repeatForever(spawnAction), withKey: spawnActionKey)
    }
}
