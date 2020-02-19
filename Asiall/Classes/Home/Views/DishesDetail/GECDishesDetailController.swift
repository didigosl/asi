//
//  GECDishesDetailController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/23.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECDishesDetailController: UIViewController {
    typealias detailDishAction = ((_ model: GECRestaurantDishModel, _ isPlus: Bool, _ canRemove: Bool)->())
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var remarkPlsLabel: UILabel!
    @IBOutlet weak var remarkTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var detailDishViewAction: detailDishAction?
    var dishModel: GECRestaurantDishModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    //View Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    private func setup() {
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.remarkTextField.placeholder = "输入备注".getLocaLized
        self.remarkPlsLabel.text = "Remark".getLocaLized
        self.confirmButton.setTitle("确认".getLocaLized, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(leftBarButtonAction))
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "GECDishesDetailImageViewCell", bundle: nil), forCellReuseIdentifier: "GECDishesDetailImageViewCell")
        tableView.register(UINib(nibName: "GECDishesDetailInfoCell", bundle: nil), forCellReuseIdentifier: "GECDishesDetailInfoCell")
        collectionView.register(UINib(nibName: "GECDishesDetailAttributeCell", bundle: nil), forCellWithReuseIdentifier: "GECDishesDetailAttributeCell")
        tableView.delegate = self
        tableView.dataSource = self
        let flowLayout = JS_CollectionViewFlowLayout(.left)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        if dishModel?.attributes?.count == 0 {
            collectionView.backgroundColor = .clear
        }
    }

    @objc
    private func leftBarButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func confirmButtonAction(_ sender: UIButton) {
        dishModel?.customRemarkAttribute = self.remarkTextField.text ?? ""
        if let model = dishModel {
            detailDishViewAction?(model, true, false)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension GECDishesDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.row == 0 {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "GECDishesDetailImageViewCell", for: indexPath) as! GECDishesDetailImageViewCell
            if let imageUrl = dishModel?.images?.first?.url {
                imageCell.dishImageView.setImageWithUrl(imageUrl, placeImage: "nullImage_icon")
            }else  {
                imageCell.dishImageView.image = UIImage(named: "nullImage_icon")
            }
            cell = imageCell as UITableViewCell
        }else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: "GECDishesDetailInfoCell", for: indexPath) as! GECDishesDetailInfoCell
            infoCell.nameLabel.text = dishModel?.name
            infoCell.priceLabel.text = dishModel?.price
            infoCell.detailInfoLabel.text = dishModel?.commoditeDescription
            cell = infoCell as UITableViewCell
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return screenWidth
        }
        return UITableView.automaticDimension
    }
}

extension GECDishesDetailController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dishModel?.attributes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GECDishesDetailAttributeCell", for: indexPath) as! GECDishesDetailAttributeCell
        cell.attributeModel = dishModel?.attributes?[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols: CGFloat = 5
        let rows: CGFloat = 2
        var width = (screenWidth - (15 * 2) - ((cols - 1) * 10)) / cols
        var height = (collectionView.frame.height - ((rows + 1) * rows)) / rows
        if let dish = dishModel?.attributes?[indexPath.row] {
            width = (dish.name ?? "").getSizeWithFont(font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: screenWidth, height: height)).width + commonMargin
            height = (dish.name ?? "").getSizeWithFont(font: UIFont.systemFont(ofSize: 13), maxSize: CGSize(width: screenWidth, height: height)).height + miniMargin
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dishModel?.attributes?[indexPath.row].isSelect = !(dishModel?.attributes?[indexPath.row].isSelect ?? false)
        collectionView.reloadData()
    }
}
