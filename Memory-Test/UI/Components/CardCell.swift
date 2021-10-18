import UIKit

protocol CardCellDelegate: AnyObject {
    func onDismissed(card id: Int)
}

private enum Constants {
    static let iconImageViewCornerRadius: CGFloat = 6
    static let borderColorAlphaComponent: CGFloat = 0.08
    static let containerBorderColorAlphaComponent: CGFloat = 0.05
    static let fontSize: CGFloat = 15
    static let containerCornerRadius: CGFloat = 10
    static let dismissButtonText = "cells_card_button_title_dismiss".localized
    static let colorAlphaValue: CGFloat = 0.07
    static let shadowRadius: CGFloat = 5
    static let shadowOffset = CGSize(width: .zero, height: 2)
    static let buttonFontSize: CGFloat = 17
    static let containerViewInset: CGFloat = 8
    static let containerViewTopInset: CGFloat = 10
    static let containerViewBottomInset: CGFloat = 8
    static let horizontalInset: CGFloat = 14
    static let iconImageViewSize = CGSize(width: 30, height: 30)
    static let nameLabelTopInset: CGFloat = 12
    static let multiplier = CGFloat(1)
    static let descriptionLabelTopInset: CGFloat = 8
    static let separatorTopInset: CGFloat = 16
    static let separatorHeight: CGFloat = 1
    static let bottomSeparatorBottomInset: CGFloat = 54
}

class CardCell: UITableViewCell {
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let containerView = UIView()
    private let dismissButton = UIButton()
    private let topSeparator = UIView()
    private let bottomSeparator = UIView()
    private let colorsView = ColorsView()
    private var uiModel: UIModel?
    private var handle: ImageProvider.Handle?

    weak var delegate: CardCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
        layoutConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        ImageProvider.shared.cancel(handle: handle)
    }

    func update(with model: UIModel) {
        uiModel = model
        nameLabel.text = model.titleText
        descriptionLabel.text = model.description
        colorsView.update(with: model.colors)
        selectedBackgroundView?.backgroundColor = model.designatedColor
        colorsView.onColorCellSelected = { [weak self] index in
            guard let self = self else { return }
            self.selectedBackgroundView?.backgroundColor = self.uiModel?.colors[index].color
        }
        handle = ImageProvider.shared.getImage(for: model.iconImageUrl) { [weak self] image in
            self?.iconImageView.image = image
        }
    }

    @objc private func dismissedAction() {
        guard let model = uiModel else { return }
        delegate?.onDismissed(card: model.id)
    }
}

extension CardCell {
    private func initializeView() {
        backgroundColor = .clear
        selectedBackgroundView = UIView()

        iconImageView.cornerRadius = Constants.iconImageViewCornerRadius
        iconImageView.setBorder(
            color: .black.withAlphaComponent(Constants.borderColorAlphaComponent)
        )
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .primary(weight: .semibold, size: Constants.fontSize)
        nameLabel.textColor = .textPrimary
        nameLabel.numberOfLines = .zero
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = .primary(weight: .medium, size: Constants.fontSize)
        descriptionLabel.textColor = .textSecondary
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = .white
        containerView.setBorder(
            color: .black.withAlphaComponent(Constants.containerBorderColorAlphaComponent)
        )
        containerView.cornerRadius = Constants.containerCornerRadius
        containerView.dropShadow(
            Constants.shadowRadius,
            color: .black, Float(Constants.colorAlphaValue),
            Constants.shadowOffset
        )

        containerView.translatesAutoresizingMaskIntoConstraints = false

        topSeparator.backgroundColor = .black.withAlphaComponent(Constants.colorAlphaValue)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false

        colorsView.translatesAutoresizingMaskIntoConstraints = false

        bottomSeparator.backgroundColor = .black.withAlphaComponent(Constants.colorAlphaValue)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false

        dismissButton.setTitle(Constants.dismissButtonText, for: .normal)
        dismissButton.setTitleColor(.darkSkyBlue, for: .normal)
        dismissButton.titleLabel?.font = .primary(
            weight: .semibold,
            size: Constants.buttonFontSize
        )

        dismissButton.addTarget(self, action: #selector(dismissedAction), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(topSeparator)
        containerView.addSubview(colorsView)
        containerView.addSubview(bottomSeparator)
        containerView.addSubview(dismissButton)
    }

    private func layoutConstraint() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.containerViewInset),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.containerViewInset),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.containerViewTopInset),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.containerViewBottomInset),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalInset),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.horizontalInset),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconImageViewSize.height),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconImageViewSize.width),

            nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.nameLabelTopInset),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalInset),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualTo: iconImageView.heightAnchor, multiplier: Constants.multiplier),

            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.descriptionLabelTopInset),

            topSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topSeparator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.separatorTopInset),
            topSeparator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),

            colorsView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor),
            colorsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            colorsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            colorsView.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor),

            bottomSeparator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.bottomSeparatorBottomInset),
            bottomSeparator.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dismissButton.topAnchor.constraint(equalTo: bottomSeparator.bottomAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

        ])
    }
}

extension CardCell {
    struct UIModel {
        let id: Int
        let iconImageUrl: String?
        let titleText: String
        let description: String
        var designatedColor: UIColor
        let colors: [ColorCell.UIModel]
    }
}
