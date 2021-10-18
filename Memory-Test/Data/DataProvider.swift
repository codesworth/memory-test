import Foundation
import os.log

protocol DataProviderProtocol {
    func loadData(with completion: @escaping (Result<CardDataModel, DataError>) -> Void)
}

class DataProvider: DataProviderProtocol {
    private let utilityQueue: DispatchQueue
    private let decoder: JSONDecoder

    init(
        with queue: DispatchQueue,
        decoder: JSONDecoder
    ) {
        utilityQueue = queue
        self.decoder = decoder
    }

    func loadData(with completion: @escaping (Result<CardDataModel, DataError>) -> Void) {
        utilityQueue.async {
            guard let cellFile = Bundle.main.url(forResource: "Data", withExtension: "json"), let colorsFile = Bundle.main.url(forResource: "Colors", withExtension: "json") else {
                completion(.failure(.init(description: "Resource files not found")))
                return
            }
            do {
                let cellData = try Data(contentsOf: cellFile)
                let cellsModel = try self.decoder.decode([CellDataModel].self, from: cellData)

                let colorsData = try Data(contentsOf: colorsFile)
                let colorsModel = try self.decoder.decode([ColorDataModel].self, from: colorsData)
                let result = self.updateColorMentions(
                    data: CardDataModel(cells: cellsModel, colors: colorsModel)
                )
                completion(.success(result))
                print(result)
            } catch let err {
                let err = err as NSError
                os_log("Error occurred loading data with description: %s", log: .default, type: .error, err.debugDescription)
                completion(.failure(.init(description: err.localizedDescription)))
            }
        }
    }

    private func updateColorMentions(data: CardDataModel) -> CardDataModel {
        var colors = data.colors
        for (index, color) in colors.enumerated() {
            let mentions = data.cells.filter { $0.colors.contains(color.id) }.count
            colors[index].mentions = mentions
        }
        colors.sort()
        return .init(cells: data.cells, colors: colors)
    }
}
