import SpriteKit
import SwiftUI

struct ContentView: View {
    @State private var gameStarted: Bool = false
    @State private var gameScene: GameScene? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if gameStarted {
                    SpriteView(
                        scene: gameScene ?? createGameScene(size: geometry.size)
                    )
                    .ignoresSafeArea()
                    .onAppear {
                        if gameScene == nil {
                            gameScene = createGameScene(size: geometry.size)
                        }
                    }
                } else {
                    SpriteView(
                        scene: createFruitBounceScene(size: geometry.size)
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 40) {
                        Text("Fruit Frenzy")
                            .font(.custom("AvenirNext-Bold", size: 60))
                            .foregroundColor(.white)
                            .shadow(
                                color: .black.opacity(0.5), radius: 5, x: 2,
                                y: 2)

                        Button(action: {
                            withAnimation {
                                // Ensure gameScene is initialized before transitioning
                                gameScene = createGameScene(size: geometry.size)
                                gameStarted = true
                            }
                        }) {
                            Text("Start Game")
                                .font(.custom("AvenirNext-Bold", size: 30))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 60)
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(
                                    color: .black.opacity(0.5), radius: 5, x: 2,
                                    y: 2)
                        }
                    }
                }
            }
        }
    }

    func createGameScene(size: CGSize) -> GameScene {
        let scene = GameScene()
        scene.size = size
        scene.scaleMode = .aspectFill
        return scene
    }

    func createFruitBounceScene(size: CGSize) -> FruitBounceScene {
        let scene = FruitBounceScene()
        scene.size = size
        scene.scaleMode = .aspectFill
        return scene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
