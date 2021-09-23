//
//  ButtonCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import CardParts

class TableCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableCardPartView {
    private func configView() {
        view.addSubview(tableView)
        configTableView()
        setTableViewConstraints()
    }
    
    private func configTableView() { }
}

extension TableCardPartView {
    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
