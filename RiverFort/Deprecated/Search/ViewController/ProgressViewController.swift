//
//  ProgressViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 26/07/2021.
//

import UIKit

class ProgressViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureActivityIndicatorView()
        configureActivityLabel(activityLabelText: "Loading...")
    }
}

extension ProgressViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureActivityIndicatorView() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureActivityLabel(activityLabelText: String) {
        let activityLabel = UILabel()
        view.addSubview(activityLabel)
        activityLabel.text = activityLabelText
        activityLabel.textColor = .systemGray
        activityLabel.font = .preferredFont(forTextStyle: .callout)
        activityLabel.adjustsFontForContentSizeCategory = true
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10).isActive = true
    }
}
