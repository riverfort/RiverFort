//
//  SearchNoResultsView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 10/05/2021.
//

import UIKit

class SearchNoResultsView: UIView {
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-Medium", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "However, you can let us know, we'll add it for you."
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Please add the company", for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        backgroundColor = .systemTeal
        addSubview(contactButton)
        contactButton.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapButton() {
        print("Button Tapped")
    }
}

