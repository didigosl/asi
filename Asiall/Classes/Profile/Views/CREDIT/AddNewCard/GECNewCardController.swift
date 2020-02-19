//
//  GECNewCardController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECNewCardController: UIViewController {

    //MARK: -
    //MARK: Vars.
    let masterCardImageName = "mastercard_icon"
    let visaCardImageName = "visacolor_icon"
    let cardBackgroundImageName = "cardBackground"
    @IBOutlet weak var cardBaseView: UIView!
    @IBOutlet weak var topCardImageView: UIImageView!
    @IBOutlet weak var bottomCardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var validTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var cardTimeTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    var cardName = ""



    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    // setup
    private func setup() {
        self.title = "添加银行卡".getLocaLized
        cardBaseView.layer.cornerRadius = 7
        cardBaseView.layer.masksToBounds = true
        cardBaseView.layer.borderColor = UIColor.red.cgColor

        cardTextField.addTarget(self, action: #selector(didCarNumberChangeText(textField:)), for: .editingChanged)
        cardTimeTextField.addTarget(self, action: #selector(didCarTimeChangeText(textField:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(didCarNameChangeText(textField:)), for: .editingChanged)
        nameTextField.delegate = self
        cardTextField.delegate = self
        cardTimeTextField.delegate = self
        cvvTextField.delegate = self

    }

    // addNewCard Actopm
    @IBAction func addNewCardAction(_ sender: UIButton) {
        GECProfileViewModel.validateAddCardAction(name: nameTextField.text, time: cardTimeTextField.text, cvv: cvvTextField.text) { [weak self](isCan) in
            switch isCan {
            case true:
                self?.navigationController?.popViewController(animated: true)
            case false:
                self?.view.showToast(withString: "Someting error", 0.25, 0.25)
            }
        }
    }
}


// MARK: - Target(For CreditCard)
extension GECNewCardController {

    // carNumberTextField DidChanged
    @objc func didCarNumberChangeText(textField:UITextField)
    {
        textField.text = GECProfileViewModel.modifyCreditCardString(creditCardString: textField.text!)
        cardNumberLabel.text = textField.text
        // 获取真实卡号
        if let realNumber = cardNumberLabel.text?.replacingOccurrences(of: " ", with: "") {
            if realNumber.count == 16 {
                realNumber.checkCardNumber { [weak self](isValid) in
                    switch isValid {
                    case true:
                        self?.cardBaseView.layer.borderWidth = 0
                        GECProfileViewModel.isCreditValid = true
                        GECProfileViewModel.creditCardNumber = realNumber
                    case false:
                        GECProfileViewModel.isCreditValid = false
                        self?.cardBaseView.layer.borderWidth = 2
                        self?.cardBaseView.shake(direction: UIView.ShakeDirection.horizontal, times: 5, interval: 0.05, delta: 3, completion: nil)
                }}
                // Check Card type
                if ValidateEnum.visaCard(realNumber).isRight == true {
                    topCardImageView.image = UIImage(named: visaCardImageName)
                    bottomCardImageView.image = UIImage(named: visaCardImageName)
                }else if ValidateEnum.masterCard(realNumber).isRight == true {
                    topCardImageView.image = UIImage(named: masterCardImageName)
                    bottomCardImageView.image = UIImage(named: masterCardImageName)
                }else {
                    topCardImageView.image = nil
                    bottomCardImageView.image = nil
                    view.showToast(withString: "不支持卡类型".getLocaLized, 0.25, 0.25)
                }
            }
        }
    }

    // carNumberTextField DidChanged
    @objc func didCarTimeChangeText(textField:UITextField)
    {
        if textField.text!.count == 2 {
            let text = textField.text! + "/"
            textField.text = text
        }
        validTimeLabel.text = textField.text
    }

    // CardName
    @objc func didCarNameChangeText(textField:UITextField)
    {
        nameLabel.text = textField.text?.uppercased()
    }
}


// MARK: - UITextFieldDelegate(恶习的代码)
extension GECNewCardController: UITextFieldDelegate {
    // 处理编辑问题
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == cardTextField){
            let newLength = textField.text!.count + string.count - range.length
            if newLength <= 19 {return true} else {
                cardTimeTextField.becomeFirstResponder()
                return false
            }
        }else if (textField == cardTimeTextField) {
            let newLength = textField.text!.count + string.count - range.length
            if string.isEmpty  {
                if textField.text?.last == "/" {
                    textField.text = textField.text!.replacingOccurrences(of: "/", with: "")
                    return true
                }
                if newLength == 0 {
                    cardTimeTextField.text = ""
                    validTimeLabel.text = cardTimeTextField.text
                    cardTextField.becomeFirstResponder()
                    return false
                }
            }
            if newLength <= 5 { return true } else {
                cvvTextField.becomeFirstResponder()
            }
        }else if (textField == cvvTextField) {
            let newLength = textField.text!.count + string.count - range.length
            if newLength <= 3{
                if string.isEmpty {
                    if newLength == 0 {
                        cvvTextField.text = ""
                        cvvLabel.text = cvvTextField.text
                        cardTimeTextField.becomeFirstResponder()
                        return false
                    }
                    cvvLabel.text?.removeLast()
                } else {
                    cvvLabel.text = cvvLabel.text! + string
                }
                return true
            }else {
                return false
            }
        }
        return true
    }
}
