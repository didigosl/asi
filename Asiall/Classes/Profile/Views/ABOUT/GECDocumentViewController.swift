//
//  GECDocumentViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 05/07/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECDocumentViewController: UITableViewController {

    //MARK: Vars...
    final let cellIdentifier = "document_identifier"

    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        GECProfileViewModel.getDocumentInfosRequest { (errCode) in
            if errCode != nil {
                self.showErrorWithMessage(ErrorCode.getErrorMsg(errorCode: errCode!))
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GECProfileViewModel.docInfosModel?.collection?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if let dequeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = dequeCell
        }else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell = newCell
        }
        if let model = GECProfileViewModel.docInfosModel?.collection?[indexPath.row] {
            cell?.textLabel?.text = model.title
        }
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
}
