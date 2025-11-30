import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let vc = UIViewController()
        vc.view.backgroundColor = .systemRed   // 🔴 TEST

        window.rootViewController = vc
        window.makeKeyAndVisible()

        self.window = window
    }
}
