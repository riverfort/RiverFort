//
//  RecentSearchTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/07/2021.
//

import Foundation

class RecentSearchTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello world"
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
        clearButton.setTitleColor(.systemIndigo, for: .normal)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.titleLabel!.font = .preferredFont(forTextStyle: .headline)
        clearButton.titleLabel!.adjustsFontForContentSizeCategory = true
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
}
