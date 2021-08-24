//
//  PrivacyPolicyViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 30/04/2021.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Privacy Policy"
        navigationController?.navigationBar.tintColor = .systemIndigo
        view.addSubview(webView)
        guard let url = URL(string: "https://qiuyangnie.github.io/privacy-policy.html") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
}
