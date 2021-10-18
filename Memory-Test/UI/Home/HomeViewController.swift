import UIKit

private enum Constants {
    static let titleFontSize: CGFloat = 17
    static let refreshText = "home_button_title_refresh".localized
    static let titleText = "home_button_title_test".localized
    static let actionTitle = "home_alert_action_title_ok".localized
    static let headerTitle = "home_cards_section_header".localized
    static let headerHeight: CGFloat = 56
}

class HomeViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: HomeViewModelProtocol
    private let presentationToUiMapper: CardPresentationToUIMapper

    init(
        with viewModel: HomeViewModelProtocol,
        presentationToUiMapper: CardPresentationToUIMapper
    ) {
        self.viewModel = viewModel
        self.presentationToUiMapper = presentationToUiMapper
        super.init(nibName: nil, bundle: .main)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        layoutConstraint()
        setupViewModelBindings()
        viewModel.onViewDdidLoad()
    }

    func setupViewModelBindings() {
        viewModel.onReloadAction = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onErrorAction = { [weak self] error in
            let alert = UIAlertController(title: .init(), message: error, preferredStyle: .alert)
            alert.addAction(.init(title: Constants.actionTitle, style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.removeItemAction = { [weak self] index in
            let indexPath = IndexPath(row: index, section: .zero)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @objc private func onRefreshAction(_: UIBarButtonItem) {
        viewModel.reloadData()
    }
}

// MARK: - UICollectionViewDatasource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CardCell.self), for: indexPath) as! CardCell
        let model = presentationToUiMapper.map(model: viewModel.cards[indexPath.row])
        cell.update(with: model)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let header = SectionHeader()
        header.title = Constants.headerTitle
        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        Constants.headerHeight
    }
}

// MARK: - CardCell Delegate

extension HomeViewController: CardCellDelegate {
    func onDismissed(card id: Int) {
        viewModel.onDismissCardAction(card: id)
    }
}

extension HomeViewController {
    private func initializeViews() {
        view.backgroundColor = UIColor.backgroundPrimary

        setupNavbar()
        setupTableView()
    }

    private func setupNavbar() {
        title = Constants.titleText
        let titleFont = UIFont.primary(weight: .semibold, size: Constants.titleFontSize)
        navigationController?.navigationBar.titleTextAttributes = [.font: titleFont, .foregroundColor: UIColor.textPrimary]
        let refreshBarButton = UIBarButtonItem(title: Constants.refreshText, style: .plain, target: self, action: #selector(onRefreshAction(_:)))
        refreshBarButton.setTitleTextAttributes([.font: titleFont, .foregroundColor: UIColor.darkSkyBlue], for: .normal)
        navigationItem.leftBarButtonItem = refreshBarButton
    }

    private func setupTableView() {
        tableView.register(CardCell.self, forCellReuseIdentifier: String(describing: CardCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }

    func layoutConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
