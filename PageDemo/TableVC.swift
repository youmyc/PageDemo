//
//  TableVC.swift
//  PageDemo
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = ViewController()
            vc.title = "default"
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = ViewController()
            vc.title = "scale"
            vc.scale = 0.2
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}
