import UIKit

extension UIColor {
    static let velvet = UIColor(red: 204/255, green: 39/255, blue: 50/255, alpha: 1)
    static let blackVelvet = UIColor(red: 36/255, green: 31/255, blue: 32/255, alpha: 1)
}

extension String {
    static let regular = "Futura-Medium"
    static let bold = "Futura-Bold"
    
    static let posterBaseUrl = "https://image.tmdb.org/t/p/w500/"
}


extension UIView {
    func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            responder = nextResponder
        }
        return nil
    }
}
