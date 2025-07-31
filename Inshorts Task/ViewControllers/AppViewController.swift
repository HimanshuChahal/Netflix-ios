import UIKit

class AppViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInteraction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setInteraction()
    }
    
    private func setInteraction() {
        if let navController = self.navigationController,
           navController.viewControllers.count > 1 {
            navController.interactivePopGestureRecognizer?.delegate = self
        }

        self.navigationItem.hidesBackButton = true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}
