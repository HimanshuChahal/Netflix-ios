import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("Scene connected")
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window!.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("Scene disconnected")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene resign active")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("Scene foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("Scene background")
    }

}

