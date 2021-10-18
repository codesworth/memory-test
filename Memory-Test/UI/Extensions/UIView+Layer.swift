import UIKit

public extension UIView {
    func dropShadow(_ radius: CGFloat = 2.0, color: UIColor = .black, _ opacity: Float = 0.4, _ offset: CGSize = .init(width: .zero, height: 4)) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }

    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { layer.cornerRadius }
    }

    func setBorder(width: CGFloat = 1, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
