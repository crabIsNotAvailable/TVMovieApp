import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        print("✅ AppDelegate didFinishLaunching")

        let window = UIWindow(frame: UIScreen.main.bounds)

        // ✅ HOST YOUR APP HERE
        let listVC = ListViewController()
        let nav = UINavigationController(rootViewController: listVC)

        window.rootViewController = nav
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}
