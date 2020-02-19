//
//  GECProfileInfoInputView.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/5.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECProfileInfoInputView: UIView {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.toolbarPlaceholder = "输入您要修改的信息".getLocaLized
        textView.layer.cornerRadius = normalButtonHeight * 0.5
        textView.layer.masksToBounds = true
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textContainer.lineFragmentPadding = commonMargin
        textView.textContainerInset.top = 10
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("确定".getLocaLized, for: .normal)
        button.setTitleColor(UIColor.themaSelectColor, for: .normal)
        button.setTitleColor(UIColor.themaNormalColor, for: .highlighted)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.themaNormalColor
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(textView)
        addSubview(confirmButton)

        NSLayoutConstraint.activate([
            self.confirmButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -commonMargin),
            self.confirmButton.heightAnchor.constraint(equalToConstant: normalButtonHeight),
            self.confirmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.confirmButton.widthAnchor.constraint(equalToConstant: self.frame.height)
            ])

        NSLayoutConstraint.activate([
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: commonMargin),
            self.textView.rightAnchor.constraint(equalTo: self.confirmButton.leftAnchor, constant: -commonMargin),
            self.textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textView.heightAnchor.constraint(equalToConstant:  normalButtonHeight)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
