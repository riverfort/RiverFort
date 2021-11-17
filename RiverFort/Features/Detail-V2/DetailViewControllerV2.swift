//
//  DetailViewControllerV2.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/11/2021.
//

import UIKit

class DetailViewControllerV2: UIViewController {
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setScrollViewConstraints()
    }
}

extension DetailViewControllerV2 {
    private func configView() {
        navigationItem.title = "IRON.L"
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
    }
    
    private func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
