//
//  NewADTVChartCardController.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 02/09/2021.
//

import UIKit

class NewADTVChartCardController: TemplateCardController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        createObservesr()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([NewADTVChartCardPartView()])
    }
}

extension NewADTVChartCardController {
    private func createObservesr() {
        let adtvName = Notification.Name(NewDetailViewConstant.ADTV)
        NotificationCenter.default.addObserver(self, selector: #selector(prepareView), name: adtvName, object: nil)
    }
    
    @objc private func prepareView(notification: Notification) {
        guard let adtvs = notification.object as? [NewADTV] else {
            return
        }
        print(adtvs)
    }
}
