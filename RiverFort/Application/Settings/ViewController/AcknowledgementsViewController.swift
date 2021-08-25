//
//  AcknowledgementsViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 25/08/2021.
//

import UIKit

class AcknowledgementsViewController: UIViewController {
    private let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTextView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextViewConstraints()
    }
}

extension AcknowledgementsViewController {
    private func configView() {
        title = "Acknowledgements"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
    }
    
    private func configTextView() {
        view.addSubview(textView)
        textView.textAlignment = .justified
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.text = "Data provided by Financial Modeling Prep: https://financialmodelingprep.com/developer/docs/"
    }
    
    private func setTextViewConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive    = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive     = true
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive            = true
    }
}
