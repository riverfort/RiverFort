//
//  ButtonCardPartView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 07/09/2021.
//

import CardParts

protocol ButtonCardPartViewDelegate { func buttonDidTap() }

class ButtonCardPartView: UIView, CardPartView {
    internal var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public var delegate: ButtonCardPartViewDelegate?
    public let button = UIButton(type: .system)
    
    init() {
        super.init(frame: CGRect.zero)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ButtonCardPartView {
    private func configView() {
        view.addSubview(button)
        configButton()
        setButtonConstraints()
    }
    
    private func configButton() {
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .secondarySystemGroupedBackground
        button.setTitleColor(.link, for: .normal)
        button.setTitle("View ADTV Trends", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
}

extension ButtonCardPartView {
    private func setButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ButtonCardPartView {
    @objc private func didTapButton() {
        delegate?.buttonDidTap()
    }
}
