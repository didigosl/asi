//
//  GECLoginViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/16.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
typealias loginCallback = (_ completed: Bool) -> Void
class GECLoginViewController: UIViewController {
    /**
     * 注册
     */
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    /**
     * 登陆
     */
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    /**
     * Check is Register View
     */
    private var isRegister: Bool = false
    var loginCallback: loginCallback?
    
    //MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearAllResponder()
    }

    //Mark: - 初始化
    private func configure() {
        changeButtonState(isEnable: true, button: registerButton)
        changeButtonState(isEnable: true, button: loginButton)
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginUserName.delegate = self
        loginPassword.delegate = self
    }

    @IBAction func registerActionClicked(_ sender: UIButton) {
        if !checkEmailValidad(emailTextField) { return }

        if let userName = userNameTextField.text, userName.count > 0, let password = passwordTextField.text, password.count > 0, let email = emailTextField.text, email.count > 0 {
            self.showLoadingAnimation(with: "注册中".getLocaLized)
            if ValidateEnum.emailAddress(email).isRight {
                let data = ["name": userName,"password": password,"email": email, "phone": ""]
                GECProfileViewModel.registerRequest(parameters: data) {[weak self] (completed) in
                    if completed {
                        self?.stopAnimating()
                        self?.showLoginViewClicked(self!.registerButton)
                    }else {self?.stopAnimating()
                        
                        self?.showErrorWithMessage("邮箱已被注册, 请稍后再试".getLocaLized)}
                }
            }
        }else {
            self.stopAnimating()
            view.showToast(withString: "信息填写出错".getLocaLized)
        }
    }

    @IBAction func showRegisterViewAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.registerView.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        isRegister = true
    }


    @IBAction func showLoginViewClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.registerView.transform = .identity
        }
        isRegister = false
    }

    @IBAction func loginActionClicked(_ sender: UIButton) {
        if !checkEmailValidad(loginUserName) {return}

        if let userName = loginUserName.text, let password = loginPassword.text {
            self.showLoadingAnimation(with: "登陆中".getLocaLized)
            let data = ["email": userName,"password": password]
            GECProfileViewModel.loginRequest(parameters: data) {[weak self] (completed) in
                self?.stopAnimating()
                if completed {
                    self?.loginCallback?(true)
                    self?.getUserInfoAfterLogin()
                }else {
                    self?.showErrorWithMessage("登陆失败,帐号或密码错误".getLocaLized)
                }
            }
        }
    }

    private func getUserInfoAfterLogin() {
        GECProfileViewModel.getUserInfoWithToken { (_) in
            NotificationCenter.default.post(name: NotificationNames.updateFollowRestaurant, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func dismissActionClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UITextFieldDelegate
extension GECLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if isRegister {
//            if let userName = userNameTextField.text, userName.count > 0, let password = passwordTextField.text, password.count > 0, let email = emailTextField.text, email.count > 0 {
//                if ValidateEnum.emailAddress(email).isRight {
//                    self.changeButtonState(isEnable: true, button: registerButton)
//                }else {
//                    self.changeButtonState(button: registerButton)
//                }
//            }}else {
//            if let userName = loginUserName.text, userName.count > 0, let password = loginPassword.text, password.count > 0 {
//                if ValidateEnum.emailAddress(userName).isRight {
//                    self.changeButtonState(isEnable: true, button: loginButton)
//                }else {
//                    self.changeButtonState(button: loginButton)
//                }
////            }
//        }
//        return true
//    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField || textField == loginUserName{
            _ = checkEmailValidad(textField)
        }
    }

    func checkEmailValidad(_ textField: UITextField) -> Bool {
        if !(ValidateEnum.emailAddress(textField.text!).isRight){
            textField.shake()
            self.changeTextFieldState(isNormal: false, textField: textField)
            return false
        }else {
            self.changeTextFieldState(textField: textField)
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else {

        }
        return true
    }

    private func changeTextFieldState(isNormal: Bool = true, textField: UITextField) {
        if isNormal {
            textField.layer.borderColor = nil
            textField.layer.borderWidth  = 0
        }else {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth  = 0.5
            textField.layer.masksToBounds = true
        }
    }

    private func changeButtonState(isEnable: Bool = false, button: UIButton) {
        if isEnable {
            button.isEnabled = true
            button.backgroundColor = UIColor.themaSelectColor
        }else {
            button.isEnabled = false
            button.backgroundColor = UIColor.lightGray
        }
    }

    private func clearAllResponder() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.loginUserName.resignFirstResponder()
        self.loginPassword.resignFirstResponder()
        self.userNameTextField.resignFirstResponder()
    }
}
