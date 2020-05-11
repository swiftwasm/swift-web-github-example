import UIKit
import SwiftUI
import GitHubExample

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let networkSession = NativeNetworkSession()
    lazy var app = GitHubExampleApp(networkSession: self.networkSession)
    lazy var viewModel = ContentViewModel(app: app)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView(viewModel: viewModel)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
