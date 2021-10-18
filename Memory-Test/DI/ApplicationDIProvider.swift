import UIKit

let applicationDiProvider = ApplicationDIProvider()

class ApplicationDIProvider {
    private let utilityQueue = DispatchQueue(label: "ios.memory.test.Memory-Test", qos: .utility)

    func makeApplicationRootViewController() -> UIViewController {
        return UINavigationController(
            rootViewController: makehomeViewController()
        )
    }

    private func makehomeViewController() -> HomeViewController {
        .init(
            with: makeHomeViewModel(),
            presentationToUiMapper: .init()
        )
    }

    private func makeHomeViewModel() -> HomeViewModelProtocol {
        HomeViewModel(
            dataProvider: makeDataProvider(),
            dataToPresentationMapper: .init()
        )
    }

    private func makeDataProvider() -> DataProviderProtocol {
        DataProvider(
            with: utilityQueue,
            decoder: .init()
        )
    }
}
