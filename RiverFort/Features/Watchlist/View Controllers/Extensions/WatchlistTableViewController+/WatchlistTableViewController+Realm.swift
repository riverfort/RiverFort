//
//  WatchlistTableViewController+Realm.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 27/09/2021.
//

import Foundation
import RealmSwift
import SPAlert

extension WatchlistTableViewController {    
    public func deleteWatchlistCompany(row: Int) {
        let watchlistCompany = watchlistCompanies[row]
        do {
            try realm.write({ realm.delete(watchlistCompany) })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
    
    public func rearrangeWatchlistCompanyList(from: Int, to: Int) {
        do {
            try realm.write({ watchlistCompanies.move(from: from, to: to) })
        } catch {
            print(error.localizedDescription)
            SPAlert.present(title: "Something going wrong", preset: .error, haptic: .error)
        }
    }
}
