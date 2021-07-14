//
//  SettingFooterView.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/04/2021.
//

import UIKit

class SettingFooterView: UITableViewHeaderFooterView {
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .none
        return textView
    }()
    
    private let attributedString
        = NSMutableAttributedString(
            string: "The data is updated on trading day. \n Powered by Riverfort Global Capital Ltd.\n\n\(AppVersion.getVersion())")
    private let riverfort_url = URL(string: "https://riverfort.com/")!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        
        // Set the substring to be the link
        attributedString.setAttributes([.link: riverfort_url], range: NSMakeRange(36, 41))

        self.textView.attributedText = attributedString
        self.textView.isScrollEnabled = false
        self.textView.isUserInteractionEnabled = true
        self.textView.isEditable = false
        self.textView.font = UIFont(name: "Avenir", size: 12)
        self.textView.textAlignment = .center
        self.textView.textColor = .darkGray

        // Set how links should appear: blue and underlined
        self.textView.linkTextAttributes = [
            .foregroundColor: UIColor.label,
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.centerXToSuperview()
        textView.top(to: contentView, offset: 20)
        textView.width(contentView.frame.size.width - 80)
        textView.height(100)
    }
}
