//
//  GECChangePasswordViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/6.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import AudioToolbox
class GECChangePasswordViewController: UIViewController {

    //
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!

    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!



    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    //MARK: - Functions _ Actions
    private func setup() {
        self.title = "修改密码".getLocaLized
        // 名称Label
        oldPasswordLabel.text = "旧密码".getLocaLized + ":"
        newPasswordLabel.text = "新密码".getLocaLized + ":"
        confirmPasswordLabel.text = "确认新密码".getLocaLized + ":"
        changePasswordButton.setTitle("保存密码".getLocaLized, for: .normal)
        //TextField 圆角
        oldPasswordTextField.setRadiuCorner(borderColor: .clear, radius: 10)
        newPasswordTextField.setRadiuCorner(borderColor: .clear, radius: 10)
        confirmPasswordTextField.setRadiuCorner(borderColor: .clear, radius: 10)

        //textField 占位符 颜色
        oldPasswordTextField.setPlaceHolder(text: "请输入旧密码".getLocaLized, color: .darkGray)
        newPasswordTextField.setPlaceHolder(text: "请输入新密码".getLocaLized, color: .darkGray)
        confirmPasswordTextField.setPlaceHolder(text: "请再次输入新密码".getLocaLized, color: .darkGray)

        // 确认按钮 圆角 以及 阴影
        changePasswordButton.layer.cornerRadius = changePasswordButton.frame.height * 0.5
        changePasswordButton.layer.masksToBounds = true
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        if checkPasswordValidad() {
            if !newPasswordTextField.text!.elementsEqual(confirmPasswordTextField.text!) {
                return
            }
            GECProfileViewModel.changePassword(old: oldPasswordTextField.text!, new: newPasswordTextField.text!, confirm: confirmPasswordTextField.text!) { [weak self] (errorMsg) in
                if let msg = errorMsg {
                    self?.showErrorWithMessage(msg)
                }else {
                    self?.showSingleAlertWithMessage("修改成功".getLocaLized, acepted: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }

    private func checkPasswordValidad() -> Bool{
        if let newPassword = newPasswordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            newPassword.count > 0,
            confirmPassword.count > 0 { return true}
        return false
    }
}


// MARK: - UITextFieldDelegate
extension GECChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if checkPasswordValidad() {
            if !newPasswordTextField.text!.elementsEqual(confirmPasswordTextField.text!) {
                newPasswordTextField.shake(times: 2, interval: 0.05)
                confirmPasswordTextField.shake(times: 2, interval: 0.05)

                newPasswordTextField.setRadiuCorner(borderColor: .red)
                confirmPasswordTextField.setRadiuCorner(borderColor: .red)
                
                AudioServicesPlaySystemSound(1520) // 震动
            }else {
                newPasswordTextField.setRadiuCorner(borderColor: UIColor.clear)
               confirmPasswordTextField.setRadiuCorner(borderColor: UIColor.clear)
            }
        }
    }
}
