import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("✅ SceneDelegate willConnectTo")

        guard let windowScene = scene as? UIWindowScene else {
            fatalError("❌ Not a UIWindowScene")
        }

        let window = UIWindow(windowScene: windowScene)

        // ✅ HOST YOUR APP HERE
        let listVC = ListViewController()
        let nav = UINavigationController(rootViewController: listVC)

        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
    }
}
