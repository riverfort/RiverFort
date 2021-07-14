//
//  ViewController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/04/2021.
//

import UIKit

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "riverfort-launch")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .tertiarySystemBackground
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.6) {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            if done {
                let viewController = HomeViewController()
                viewController.modalPresentationStyle = .currentContext
                viewController.modalTransitionStyle = .crossDissolve
                self.present(viewController, animated: false)
            }
        })
    }
}

