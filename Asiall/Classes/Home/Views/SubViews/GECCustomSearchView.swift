//
//  GECCustomSearchView.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

protocol GECCustomSearchViewDelegate: NSObjectProtocol {
    func customSearchViewDidSelectedSearchView()
    func customSearchViewDidSelectedLocationView()
}

class GECCustomSearchView: UIView, CustomViewLoadable {
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var baseSearchBar: UIView!
    @IBOutlet weak var baseLocationView: UIView!
    @IBOutlet weak var locationButton: UIButton!

    weak var delegate: GECCustomSearchViewDelegate?
    static let height: CGFloat = 108

    //MARK: - 初始化
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholderLabel.text = "搜索餐馆".getLocaLized
        baseSearchBar.layer.cornerRadius = 10
        baseSearchBar.layer.borderWidth = 1.0
        baseSearchBar.layer.borderColor = UIColor.red.cgColor
        baseSearchBar.layer.masksToBounds = true

        //添加点击事件
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(didSelectLocation))
        baseLocationView.addGestureRecognizer(locationTap)

        let searchTap = UITapGestureRecognizer(target: self, action: #selector(didSelectSearchAction))
        baseSearchBar.addGestureRecognizer(searchTap)
    }

    //MARK: - 定位按钮点击
    @IBAction func beginTouchedLocationAction(_ sender: UIButton) {
        didSelectLocation()
    }

    public func updateUI() {
        if let zip = GECHomeViewModel.currentLocation?.placeMark.postalCode , let city = GECHomeViewModel.currentLocation?.placeMark.locality{
            self.locationButton.setTitle("\(zip), \(city)", for: .normal)
        }else {
            self.locationButton.setTitle("地址错误", for: .normal)
        }
        
    }


    @objc
    private func didSelectLocation() {
        delegate?.customSearchViewDidSelectedLocationView()
    }

    @objc
    private func didSelectSearchAction() {
        delegate?.customSearchViewDidSelectedSearchView()
    }



}
