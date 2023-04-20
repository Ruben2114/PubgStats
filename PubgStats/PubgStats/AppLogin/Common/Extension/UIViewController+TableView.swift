//
//  UIViewController+TableView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/4/23.
//

import UIKit

extension UIViewController {
    func makeTableViewGroup() -> UITableView {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }
    func makeTableView() -> UITableView {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }
}


