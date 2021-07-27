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

extension RecentSearchTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello world"
        return cell
    }
}
