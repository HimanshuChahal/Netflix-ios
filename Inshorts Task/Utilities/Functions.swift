import UIKit

func showToast(message: String, in view: UIView, duration: TimeInterval = 2.0) {
    let toastLabel = UILabel()
    toastLabel.text = message
    toastLabel.font = .systemFont(ofSize: 14)
    toastLabel.textColor = .white
    toastLabel.backgroundColor = .blackVelvet
    toastLabel.textAlignment = .center
    toastLabel.numberOfLines = 0
    toastLabel.alpha = 0.0
    toastLabel.layer.cornerRadius = 8
    toastLabel.clipsToBounds = true

    let padding: CGFloat = 16
    let maxWidth = view.frame.width - (padding * 2)
    let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
    toastLabel.frame = CGRect(
        x: padding,
        y: view.frame.height - textSize.height - 60,
        width: maxWidth,
        height: textSize.height + 20
    )

    view.addSubview(toastLabel)

    UIView.animate(withDuration: 0.4, animations: {
        toastLabel.alpha = 1.0
    }) { _ in
        UIView.animate(withDuration: 0.4, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}

func formatDateWithSuffix(from dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    guard let date = inputFormatter.date(from: dateString) else {
        return nil
    }

    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)

    let suffix: String
    switch day {
    case 11, 12, 13:
        suffix = "th"
    default:
        switch day % 10 {
        case 1: suffix = "st"
        case 2: suffix = "nd"
        case 3: suffix = "rd"
        default: suffix = "th"
        }
    }

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMMM yyyy"

    let formattedDate = outputFormatter.string(from: date)
    return "\(day)\(suffix) \(formattedDate)"
}

func isDateInFuture(_ dateString: String) -> Bool? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    guard let date = formatter.date(from: dateString) else {
        return nil  // Invalid date format
    }
    
    let today = Calendar.current.startOfDay(for: Date())
    let inputDate = Calendar.current.startOfDay(for: date)
    
    return inputDate > today
}
