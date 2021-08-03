//
//  WatchlistTableView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 03/08/2021.
//

import Foundation

class WatchlistTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WatchlistTableView {
    private func configureTableView() {
        self.backgroundColor = .systemBackground
        self.dataSource = self
        self.delegate = self
        self.register(WatchlistTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension WatchlistTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchlistTableViewCell
        cell.setWatchlistTableViewCell()
        return cell
    }
}
