import Foundation

struct ColorDataModel {
    let id: Int
    let color: String?
    let name: String?
    var mentions: Int = .zero
}

extension ColorDataModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, color, name
    }
}

extension ColorDataModel: Comparable {
    static func < (lhs: ColorDataModel, rhs: ColorDataModel) -> Bool {
        return lhs.mentions < rhs.mentions
    }
}
