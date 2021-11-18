//
//  DetailViewControllerV2.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 16/11/2021.
//

import UIKit

class DetailViewControllerV2: UIViewController {
    private let scrollView = UIScrollView()
    private let chartContentView = UIView()
    private let segmentedControl = UISegmentedControl(items: ["D", "W", "M", "6M", "Y", "ALL"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setScrollViewConstraints()
        setChartContentViewConstraints()
        setSegmentedControlConstraints()
    }
}

// MARK: - View config

extension DetailViewControllerV2 {
    private func configView() {
        navigationItem.title = "RMM.L"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)
        configScrollView()
        configChartContentView()
    }
    
    private func configScrollView() {
        scrollView.addSubview(chartContentView)
    }
    
    private func configChartContentView() {
        chartContentView.addSubview(segmentedControl)
        chartContentView.backgroundColor = .systemBackground
    }
}

// MARK: - Auto layout

extension DetailViewControllerV2 {
    private func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(scrollView.widthAnchor.constraint(equalTo: view.widthAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setChartContentViewConstraints() {
        chartContentView.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(chartContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(chartContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(chartContentView.widthAnchor.constraint(equalTo: view.widthAnchor))
        constraints.append(chartContentView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setSegmentedControlConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(segmentedControl.topAnchor.constraint(equalTo: chartContentView.topAnchor, constant: 10))
        constraints.append(segmentedControl.centerXAnchor.constraint(equalTo: chartContentView.centerXAnchor))
        constraints.append(segmentedControl.widthAnchor.constraint(equalTo: chartContentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9))
        NSLayoutConstraint.activate(constraints)
    }
}
