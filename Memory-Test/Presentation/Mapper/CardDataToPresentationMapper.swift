import Foundation

private enum Constants {
    static let minimumNumberOfColors = 4
}

class CardDataToPresentationMapper {
    func map(model: CardDataModel) -> [CardPresentationModel] {
        model.cells.map { map(cell: $0, colors: model.colors) }
    }

    private func map(cell: CellDataModel, colors: [ColorDataModel]) -> CardPresentationModel {
        var cellColors = cell.colors.map { value in
            colors.first { $0.id == value && $0.color != nil }
        }
        if cellColors.endIndex < Constants.minimumNumberOfColors {
            let difference = Constants.minimumNumberOfColors - cellColors.count
            cellColors.append(contentsOf: Array(repeating: nil, count: difference))
        }
        let missingIndices = cellColors.indices.filter { cellColors[$0] == nil }
        missingIndices.enumerated().forEach {
            cellColors[$0.element] = colors[$0.offset]
        }
        let colors = cellColors.compactMap { $0 }.sorted()
        return .init(id: cell.id, name: cell.name ?? .init(), description: cell.description ?? .init(), iconURL: cell.iconURL, colors: colors.map(map(model:)), popularColor: map(model: colors.last!))
    }

    private func map(model: ColorDataModel) -> ColorPresentationModel {
        .init(id: model.id, color: model.color!, name: model.name ?? .init())
    }
}
