//
//  DarkModeSwitch.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 06/08/2021.
//

import UIKit

class DarkModeSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DarkModeSwitch {
    @objc public func switchChanged(theSwitch: UISwitch) {
        
    }
}
