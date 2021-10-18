import UIKit

extension UIFont {
    class func primary(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "", size: size)!
        case .semibold:
            return UIFont(name: "AvenirNext-DemiBold", size: size)!
        case .bold:
            return UIFont(name: "AvenirNext-Bold", size: size)!
        case .medium:
            return UIFont(name: "AvenirNext-Medium", size: size)!
        case .light:
            return UIFont(name: "", size: size)!
        case .heavy:
            return UIFont(name: "", size: size)!
        case .thin:
            return UIFont(name: "", size: size)!
        default: fatalError("No Fonts for \(weight) found")
        }
    }
}
