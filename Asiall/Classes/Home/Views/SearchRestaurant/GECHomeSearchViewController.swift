//
//  GECHomeSearchViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 18/08/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECHomeSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.searchBar.becomeFirstResponder()
        searchBar.placeholder = "搜索您想要收藏的商家名称".getLocaLized
        cancelButton.setTitle("取消".getLocaLized, for: .normal)

        if #available(iOS 13, *) {
            searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14)
            searchBar.searchTextField.textColor = UIColor.themaSelectColor
        }else {
        if let textField = searchBar.value(forKey: SystemKeyPaths.searchBarTextFieldKey) as? UITextField {
            textField.font = UIFont.systemFont(ofSize: 14)
            }
        }
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func cancelSearchAction(_ sender: UIButton) {
        self.searchBar.resignFirstResponder()
        self.navigationController?.dismiss(animated: true, completion: {
        })
    }
}

extension GECHomeSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let key = searchBar.text, key.count > 0 {
            beginToSearchRestaurent(key: key)
        }
    }

    private func resignSearchBar() {
        self.searchBar.resignFirstResponder()
    }

    private func beginToSearchRestaurent(key: String?) {
        GECHomeViewModel.searchRestaurant(with: key, success: {
            self.resignSearchBar()
            let searchResultsVC = GECHomeSearchResultsViewController()
            searchResultsVC.restaurantCollections = GECHomeViewModel.searchRestaurantList?.collection
            searchResultsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(searchResultsVC, animated: true)
        }) { (msg) in
            self.showErrorWithMessage(msg)
        }
    }
}
