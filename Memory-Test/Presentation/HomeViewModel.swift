import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var cards: [CardPresentationModel] { get }
    var onReloadAction: (() -> Void)? { get set }
    var onErrorAction: ((String) -> Void)? { get set }
    func onViewDdidLoad()
    func reloadData()
    func onDismissCardAction(card id: Int)
    var removeItemAction: ((Int) -> Void)? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    private let dataProvider: DataProviderProtocol
    private let dataToPresentationMapper: CardDataToPresentationMapper
    private let delay = 2

    var cards: [CardPresentationModel] = []
    var onReloadAction: (() -> Void)?
    var onErrorAction: ((String) -> Void)?
    var removeItemAction: ((Int) -> Void)?

    init(
        dataProvider: DataProviderProtocol,
        dataToPresentationMapper: CardDataToPresentationMapper
    ) {
        self.dataProvider = dataProvider
        self.dataToPresentationMapper = dataToPresentationMapper
    }

    func onViewDdidLoad() {
        fetchData()
    }

    func reloadData() {
        fetchData()
    }

    func onDismissCardAction(card id: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            guard let index = (self.cards.firstIndex { $0.id == id }) else { return }
            self.cards.remove(at: index)
            self.removeItemAction?(index)
        }
    }

    private func fetchData() {
        dataProvider.loadData { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(value):
                let cards = self.dataToPresentationMapper.map(model: value)
                self.cards = cards
                DispatchQueue.main.async { self.onReloadAction?() }
            case let .failure(error):
                DispatchQueue.main.async { self.onErrorAction?(error.description) }
            }
        }
    }
}
