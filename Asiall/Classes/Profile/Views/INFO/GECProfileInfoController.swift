//
//  GECProfileInfoController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/12.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let inputTextViewHeight: CGFloat = 64
class GECProfileInfoController: UIViewController {

    //MARK: -
    //MARK: Vars.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: commonMargin, width: screenWidth, height: screenHeight))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GECProfileInfoCell", bundle: nil), forCellReuseIdentifier: GECProfileViewModel.infoCellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.themaBackgroundColor
        tableView.rowHeight = 55
        return tableView
    }()

    ///保存按钮
    lazy var saveInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存信息".getLocaLized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = UIColor.themaSelectColor
        button.layer.cornerRadius = normalButtonHeight * 0.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(updateUserInfoRequest), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    ///输入框
    private var textView: UITextView!
    private var confirmButton: UIButton!
    lazy var inputTextView: GECProfileInfoInputView = {
        let inputView = GECProfileInfoInputView(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: inputTextViewHeight))
        self.textView = inputView.textView
        self.confirmButton = inputView.confirmButton
        self.confirmButton.addTarget(self, action: #selector(inputViewTextConfirmAction ), for: .touchUpInside)
        return inputView
    }()


    //MARK: 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        ///监听键盘打开状态
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "".getLocaLized
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.inputTextView.resignFirstResponder()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "确定".getLocaLized
    }


    //MARK: - Actions
    //MARK: 确认保存Actions
    @objc func inputViewTextConfirmAction() {
        if !(textView.text.count > 0) {
            self.textView.resignFirstResponder()
            return
        }
        switch GECProfileViewModel.selectedInfoType {
        case InfoKeys.InfoEnums.userName:
            GECProfileViewModel.userInfoModel?.name = self.textView.text
            break
        case InfoKeys.InfoEnums.email:
            GECProfileViewModel.userInfoModel?.email = self.textView.text
            break
        case InfoKeys.InfoEnums.phoneNUmber:
            GECProfileViewModel.userInfoModel?.phone = self.textView.text
            break
        default:
            print("other")
        }
        self.tableView.reloadData()
        self.textView.text = ""
        self.textView.resignFirstResponder()
    }

    //MARK: 保存用户信息 请求
    @objc func updateUserInfoRequest() {
        GECProfileViewModel.updateCustomerInfo(completed: {
            self.navigationController?.popViewController(animated: true)
        }) { (errorMsg) in
            self.showErrorWithMessage(errorMsg)
        }
    }

    //MARK: 键盘出现
    @objc func keyBoardWillShow(_ notification: Notification){
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let height = kbRect.size.height
        let duration = kbInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.inputTextView.transform = CGAffineTransform.init(translationX: 0, y: -(height + inputTextViewHeight))
        }
    }

    //MARK: 键盘隐藏
    @objc func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let duration = kbInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.inputTextView.transform = .identity
        }
    }

    //MARK: setup UI
    private func setup() {
        self.view.backgroundColor = UIColor.themaBackgroundColor
        self.title = "个人信息".getLocaLized
        view.addSubview(tableView)
        view.addSubview(saveInfoButton)
        view.addSubview(inputTextView)

        /*
         AutoLayout
         */
        ///SaveInfoButton Layout
        NSLayoutConstraint.activate([
            saveInfoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -normalButtonHeight),
            saveInfoButton.widthAnchor.constraint(equalToConstant: screenWidth * 0.5),
            saveInfoButton.heightAnchor.constraint(equalToConstant: normalButtonHeight),
            saveInfoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
    }
}

// MARK: - UITableViewDataSource
extension GECProfileInfoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GECProfileViewModel.infoDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GECProfileViewModel.infoCellIdentifier, for: indexPath) as! GECProfileInfoCell
        let info = GECProfileViewModel.infoDatas[indexPath.row]
        if let titleName = info[InfoKeys.title] as? String, let type = info[InfoKeys.infoType] as? InfoKeys.InfoEnums {
            cell.infoTitle.text = titleName
            cell.detailIcon.isHidden = true
            cell.detailInfo.isHidden = false
            switch type {
            case .icon: cell.detailIcon.setImageWithUrl(GECProfileViewModel.userInfoModel?.headImage ?? "")
            cell.detailInfo.isHidden = true
            cell.detailIcon.isHidden = false
            case .userName:
                cell.detailInfo.text = GECProfileViewModel.userInfoModel?.name ?? " "
            case .email:
                cell.detailInfo.text = GECProfileViewModel.userInfoModel?.email ?? ""
                cell.contentView.backgroundColor = UIColor.themaLightBackgroundColor
            case .password:
                cell.detailInfo.text = "点击修改密码".getLocaLized
            case .phoneNUmber:
                cell.detailInfo.text = GECProfileViewModel.userInfoModel?.phone ?? ""
            }
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GECProfileInfoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = GECProfileViewModel.infoDatas[indexPath.row][InfoKeys.infoType] as? InfoKeys.InfoEnums {

            switch type {
            case InfoKeys.InfoEnums.icon:
                GECProfileViewModel.selectedInfoType = .icon
                iconImageHandler()
            case InfoKeys.InfoEnums.userName:
                GECProfileViewModel.selectedInfoType = .userName
                self.textView.toolbarPlaceholder = "输入您要修改的名字".getLocaLized
                self.textView.becomeFirstResponder()
            case InfoKeys.InfoEnums.email:
                break
//                GECProfileViewModel.selectedInfoType = .email
//                self.textView.toolbarPlaceholder = "输入您要修改的邮箱".getLocaLized
//                self.textView.becomeFirstResponder()
            case InfoKeys.InfoEnums.password:
                GECProfileViewModel.selectedInfoType = .password
                let psVC = GECChangePasswordViewController()
                self.navigationController?.pushViewController(psVC, animated: true)
            case InfoKeys.InfoEnums.phoneNUmber:
                GECProfileViewModel.selectedInfoType = .phoneNUmber
                self.textView.toolbarPlaceholder = "输入您要修改的电话".getLocaLized
                self.textView.becomeFirstResponder()
            default:
                print("other")
            }
        }
    }

    private func iconImageHandler() {
        let alert = UIAlertController(title: "选择照片".getLocaLized, message: "", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "相册".getLocaLized, style: .default) { (_) in
            self.pickerImageHandle()
        }

//        let cameraAction = UIAlertAction(title: "拍照".getLocaLized, style: .default) { (_) in
//
//        }

        let cancelAction = UIAlertAction(title: "取消".getLocaLized, style: .cancel, handler: nil)

        alert.addAction(libraryAction)
//        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        libraryAction.setValue(UIColor.themaNormalColor, forKey: "_titleTextColor")
//        cameraAction.setValue(UIColor.themaNormalColor, forKey: "_titleTextColor")
        cancelAction.setValue(UIColor.red, forKey: "_titleTextColor")
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: -
//MARK: PickerHandle
// UIImagePickerControllerDelegate
extension GECProfileInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func pickerImageHandle() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            GECProfileViewModel.iconImage = editImage
        }else {
            let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            GECProfileViewModel.iconImage = originImage
        }
        uploadImage {
            picker.dismiss(animated: true) {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: 上传图片
    private func uploadImage(completed: @escaping (()->())) {
        self.showLoadingAnimation()
        GECProfileViewModel.uploadImageInfo { [weak self](errorMgs) in
            self?.stopAnimating()
            completed()
            if errorMgs != nil {
                self?.showErrorWithMessage(errorMgs!)
            }
        }
    }
}

