import UIKit

class AppButton: UIButton {
    
    private var hasAddedAnimation = false

    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        super.addTarget(target, action: action, for: controlEvents)

        if controlEvents.contains(.touchUpInside) && !hasAddedAnimation {
            hasAddedAnimation = true
            self.enablePressAnimation()
        }
    }

    private func enablePressAnimation() {
        self.addTarget(self, action: #selector(pressDown), for: .touchDown)
        self.addTarget(self, action: #selector(pressUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func pressDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    @objc private func pressUp() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction]) {
            self.transform = .identity
        }
    }
}
