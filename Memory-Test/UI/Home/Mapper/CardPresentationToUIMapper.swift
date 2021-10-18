import UIKit

private enum Constants {
    static let fontSize: CGFloat = 15
}

class CardPresentationToUIMapper {
    func map(model: CardPresentationModel) -> CardCell.UIModel {
        return .init(
            id: model.id,
            iconImageUrl: model.iconURL,
            titleText: model.name,
            description: model.description,
            designatedColor: .init(hex: model.popularColor.color) ?? .black,
            colors: model.colors.map(map(model:))
        )
    }

    private func map(model: ColorPresentationModel) -> ColorCell.UIModel {
        .init(
            color: .init(hex: model.color) ?? .black,
            colorName: attributedString(
                for: model.name,
                trailing: model.color.uppercased()
            )
        )
    }

    private func attributedString(for leading: String, trailing: String) -> NSAttributedString {
        let font = UIFont.primary(weight: .semibold, size: Constants.fontSize)
        let text = NSMutableAttributedString(string: "\(leading) ", attributes: [.font: font, .foregroundColor: UIColor.textPrimary])
        text.append(.init(string: "(\(trailing))", attributes: [.font: font, .foregroundColor: UIColor.textSecondary]))
        return text
    }
}
