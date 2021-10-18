import UIKit

private enum Constants {
    static let cornerRadius: CGFloat = 4
    static let horizontalInset: CGFloat = 15
    static let colorViewSize = CGSize(width: 20, height: 20)
    static let colorLabelLeadingInset: CGFloat = 12
}

class ColorCell: UITableViewCell {
    private let colorView = UIView()
    private let colorNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        layoutConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: UIModel) {
        colorView.backgroundColor = model.color
        colorNameLabel.attributedText = model.colorName
    }
}

extension ColorCell {
    private func initializeView() {
        backgroundColor = .clear

        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.cornerRadius = Constants.cornerRadius
        colorView.backgroundColor = .clear

        colorNameLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(colorView)
        contentView.addSubview(colorNameLabel)
    }

    private func layoutConstraint() {
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: Constants.colorViewSize.width),
            colorView.heightAnchor.constraint(equalToConstant: Constants.colorViewSize.height),

            colorNameLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: Constants.colorLabelLeadingInset),
            colorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset),
            colorNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

extension ColorCell {
    struct UIModel {
        let color: UIColor
        let colorName: NSAttributedString
    }
}
