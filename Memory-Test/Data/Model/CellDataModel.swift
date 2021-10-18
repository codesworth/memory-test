import Foundation

struct CellDataModel {
    let id: Int
    let name: String?
    let description: String?
    let iconURL: String?
    let colors: [Int]
}

extension CellDataModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case iconURL = "icon_url"
        case colors = "color_ids"
    }
}
