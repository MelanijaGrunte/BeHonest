import UIKit
import Utility

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark

        let navigationController = UINavigationController()
        let feedViewController = FriendsFeedHostingViewController(
            onAnswersTapped: {
                let viewController = ShareHonestyHostingViewController(
                    onClose: { input in
                        UserDefaultsManager.shared.set(input, forKey: .firstQuestionAnswer)
                        navigationController.popViewController(animated: true)
                    }
                )
                navigationController.pushViewController(viewController, animated: true)
            }
        )

        navigationController.viewControllers = [feedViewController]
        window.rootViewController = navigationController

        self.window = window
        window.makeKeyAndVisible()
    }
}
