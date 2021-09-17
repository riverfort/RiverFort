//
//  PersistentContainer.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 05/08/2021.
//

import UIKit

class PersistentContainer {
    public static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
