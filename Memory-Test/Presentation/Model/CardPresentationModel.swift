import Foundation

struct CardPresentationModel {
    let id: Int
    let name: String
    let description: String
    let iconURL: String?
    let colors: [ColorPresentationModel]
    let popularColor: ColorPresentationModel
}
