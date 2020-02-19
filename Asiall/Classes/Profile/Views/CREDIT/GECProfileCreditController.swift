//
//  GECProfileCreditController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileCreditController: UIViewController {
    //MARK: -
    //MARK: Vars.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCardButton: UIButton!



    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    //MARK: setup
    private func setup() {
        self.title = "付款方式".getLocaLized
        tableView.register(UINib(nibName: "GECProfileCardCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.creditCardCellIdentifeir)
        tableView.rowHeight = GECProfileViewModel.cardRowHeight
        tableView.delegate = self
        tableView.dataSource = self
    }

    // add Action Selected
    @IBAction func addCardAction(_ sender: UIButton) {
        let addVc = GECNewCardController()
        self.navigationController?.pushViewController(addVc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension GECProfileCreditController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.creditCardCellIdentifeir, for: indexPath) as! GECProfileCardCell

        if indexPath.row == 1 {
            cell.baseContentView.backgroundColor = .white
            cell.baseContentView.layer.borderColor = UIColor.themaSelectColor.cgColor
            cell.checkButton.isSelected = true
            cell.cardImageView.image = UIImage(named: "mastercard_icon")
        }else {
            cell.baseContentView.backgroundColor = UIColor.themaLightBackgroundColor
            cell.baseContentView.layer.borderColor = UIColor.themaLightBackgroundColor.cgColor
            cell.checkButton.isSelected = false
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GECProfileCreditController: UITableViewDelegate {

}
