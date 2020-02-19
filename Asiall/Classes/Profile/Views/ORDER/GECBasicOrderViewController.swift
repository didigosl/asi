//
//  GECBasicOrderViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/18.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
let placeholderHeight: CGFloat = 120
class GECBasicOrderViewController: UITableViewController {

    //MARK: - Vars.
    lazy var placeholder: GECPlaceholderView = {
        let placeholder = GECPlaceholderView.getClassWithNib()
        placeholder.center = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y - placeholderHeight)
        return placeholder
    }()
    
    lazy var refresh: UIRefreshControl = UIRefreshControl()

    //MARK: - Life Cricle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configure()
    }

    private func setup() {
        tableView.addSubview(placeholder)
        placeholder.isHidden = true
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        tableView.rowHeight = normalOrderTableRowHeight
        tableView.backgroundColor = UIColor.themaLightBackgroundColor
        refresh.addTarget(self, action: #selector(updateOrderList), for: .valueChanged)
    }

    func configure() {

    }

    func updateTableView() {
        
    }

    @objc func updateOrderList() {

    }
}
