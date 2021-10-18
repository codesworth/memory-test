import UIKit

private enum Constants {
    static let fontSize: CGFloat = 13
    static let titleText = "cells_color_section_header".localized
    static let rowHeight: CGFloat = 53
    static let sectionCount = 1
    static let cornerRadius: CGFloat = 6
    static let borderColor: CGFloat = 0.08
    static let titleLabelHeight: CGFloat = 17
    static let horizontalInset: CGFloat = 16
    static let titleLabelTopInset: CGFloat = 19
    static let tableViewTopInset: CGFloat = 12
}

class ColorsView: UIView {
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private var heightConstraint: NSLayoutConstraint!
    private var uiModels: [ColorCell.UIModel] = []

    var onColorCellSelected: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        layoutConstraint()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with models: [ColorCell.UIModel]) {
        uiModels = models
        let tableHeight = CGFloat(models.count) * Constants.rowHeight
        heightConstraint.constant = tableHeight
        tableView.reloadData()
    }
}

extension ColorsView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        Constants.sectionCount
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        uiModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ColorCell.self), for: indexPath) as! ColorCell
        cell.update(with: uiModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onColorCellSelected?(indexPath.row)
    }
}

extension ColorsView {
    private func initializeView() {
        backgroundColor = .clear

        titleLabel.font = .primary(weight: .medium, size: Constants.fontSize)
        titleLabel.textColor = .textSecondary
        titleLabel.textAlignment = .left
        titleLabel.text = Constants.titleText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(ColorCell.self, forCellReuseIdentifier: String(describing: ColorCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorInset = .zero
        tableView.backgroundColor = .cellBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.tableHeaderView = .init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setBorder(color: .black.withAlphaComponent(Constants.borderColor))
        tableView.cornerRadius = Constants.cornerRadius
        tableView.clipsToBounds = true

        addSubview(titleLabel)
        addSubview(tableView)
    }

    private func layoutConstraint() {
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: .zero)
        heightConstraint.priority = .defaultHigh
        let titleLabelHeightAnchor = titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight)
        titleLabelHeightAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleLabelTopInset),
            titleLabelHeightAnchor,

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.tableViewTopInset),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalInset),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalInset),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.horizontalInset),
            heightConstraint,
        ])
    }
}
