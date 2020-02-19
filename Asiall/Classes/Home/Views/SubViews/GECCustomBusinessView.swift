//
//  GECCustomBusinessView.swift
//  G-eatClient
//
//  Created by JS_Coder on 20/12/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
let businessNameTitleHeight: CGFloat = 25
let businessImageHeight: CGFloat = 56
let businessCellWidth: CGFloat = 76

protocol GECCustomBusinessViewDelegate: NSObjectProtocol {
    func customBusinessViewDidSelected (model: GECRestaurantBusinessModel)
}
class GECCustomBusinessView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    static let height: CGFloat = businessNameTitleHeight + businessImageHeight + middleMargin * 2
    weak var delegate: GECCustomBusinessViewDelegate?

    //MARK: - collectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(UINib(nibName: "GECCustomBusinessCollectionCell", bundle: nil), forCellWithReuseIdentifier: GECCustomBusinessCollectionCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        self.addSubview(collection)
        return collection
    }()

    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: 公用方法
    public func reloadData() {
        self.collectionView.reloadData()
    }

    //MARK: - 代理 | 数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GECHomeViewModel.businessModelList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GECCustomBusinessCollectionCell.identifier, for: indexPath) as! GECCustomBusinessCollectionCell
        if let model = GECHomeViewModel.businessModelList?[indexPath.row] {
            cell.businessModel = model
        }
        return cell
    }

    //MARK: - FlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 76, height: businessImageHeight + businessNameTitleHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return commonMargin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return commonMargin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: middleMargin, left: commonMargin, bottom: 0, right: commonMargin)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = GECHomeViewModel.businessModelList?[indexPath.row] {
            GECHomeViewModel.selectedBusinessModel?.isSelect = false
            model.isSelect = true
            GECHomeViewModel.selectedBusinessModel = model

            // 唤起代理传递分类类型
            delegate?.customBusinessViewDidSelected(model: model)
            // 更新
            self.collectionView.reloadData()
        }
    }

}
