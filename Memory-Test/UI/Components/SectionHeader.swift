import UIKit

private enum Constants {
    static let fontSize: CGFloat = 17
    static let leadingInset: CGFloat = 25
    static let centerYOffset: CGFloat = 12
}

class SectionHeader: UIView {
    private let titleLabel = UILabel()

    var title: String = .init() {
        didSet { titleLabel.text = title }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        layoutConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension SectionHeader {
    private func initializeView() {
        backgroundColor = .clear

        titleLabel.font = .primary(weight: .bold, size: Constants.fontSize)
        titleLabel.textColor = .textPrimary
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
    }

    private func layoutConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.centerYOffset),
        ])
    }
}
