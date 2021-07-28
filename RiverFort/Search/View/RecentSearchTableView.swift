//
//  RecentSearchTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/07/2021.
//

import Foundation

class RecentSearchTableView: UITableView {
    private var recentSearchedCompanies = [RecentSearchedCompany]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentSearchTableView {
    public func setRecentSearchedCompanies(recentSearchedCompanies: [RecentSearchedCompany]) {
        self.recentSearchedCompanies = recentSearchedCompanies
    }
}

extension RecentSearchTableView {
    private func configureTableView() {
        self.dataSource = self
        self.delegate = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension RecentSearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchedCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentSearchedCompany = recentSearchedCompanies[indexPath.row]
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "cell")
        cell.textLabel?.text = recentSearchedCompany.symbol
        cell.detailTextLabel?.text = recentSearchedCompany.name
        return cell
    }
}

extension RecentSearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(indexPath.row)")
    }
}

extension RecentSearchTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if recentSearchedCompanies.count == 0 {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let recentlySearchedLabel = UILabel()
        let clearButton = UIButton(type: .system)
        let hStack = UIStackView(arrangedSubviews: [recentlySearchedLabel, clearButton])
        configureHeaderView(headerView: headerView)
        configureRecentlySearchedLabel(recentlySearchedLabel: recentlySearchedLabel)
        configureClearButton(clearButton: clearButton)
        configureHeaderHStack(headerView: headerView, stackView: hStack)
        return headerView
    }
}

extension RecentSearchTableView {
    private func configureHeaderView(headerView: UIView) {

    }
    
    private func configureRecentlySearchedLabel(recentlySearchedLabel: UILabel) {
        recentlySearchedLabel.text = "Recently Searched"
        recentlySearchedLabel.font = .preferredFont(forTextStyle: .headline)
        recentlySearchedLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configureClearButton(clearButton: UIButton) {
        clearButton.showsTouchWhenHighlighted = true
        clearButton.setTitleColor(.systemIndigo, for: .normal)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.titleLabel!.font = .preferredFont(forTextStyle: .headline)
        clearButton.titleLabel!.adjustsFontForContentSizeCategory = true
        clearButton.addTarget(self, action: #selector(showClearRecentlySearchedAC), for: .touchUpInside)
    }
    
    private func configureHeaderHStack(headerView: UIView, stackView: UIStackView) {
        headerView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        stackView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        stackView.centerYAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func configureClearRecentlySearchedAC(ac: UIAlertController) {
        ac.view.tintColor = .systemIndigo
        ac.addAction(UIAlertAction(title: "Clear Recent Searches", style: .destructive, handler: { _ in
            print("TODO: Clear Recent Searches")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.backgroundView
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
    }
}

extension RecentSearchTableView {
    @objc private func showClearRecentlySearchedAC() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        configureClearRecentlySearchedAC(ac: ac)
        UIApplication.topViewController()?.present(ac, animated: true)
    }
}

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard var top = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
