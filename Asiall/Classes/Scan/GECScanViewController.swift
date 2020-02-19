//
//  GECScanViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/10.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import AVFoundation
class GECScanViewController: UIViewController {

    //MARK: -
    //MARK: Vars.
    @IBOutlet weak var topLineConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var scanBackgroundView: UIView!
    @IBOutlet weak var backBaseView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!

    lazy var scanDrawView: GECScanDrawView = {
        let scanDrawView = GECScanDrawView.init(frame: self.view.bounds)
        scanDrawView.isOpaque = false
        scanDrawView.backgroundColor = .clear
        return scanDrawView
    }()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var session: AVCaptureSession? = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
        guard let cameraDevice = AVCaptureDevice.default(for: .video) else { return nil }
        guard let inputDevice = try? AVCaptureDeviceInput(device: cameraDevice) else { return nil}
        

        let outPut = AVCaptureMetadataOutput()
        outPut.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        if session.canAddInput(inputDevice) && session.canAddOutput(outPut) {
            session.addInput(inputDevice)
            session.addOutput(outPut)
            outPut.metadataObjectTypes = [.qr]
            let x: CGFloat = self.scanBackgroundView.frame.origin.y / self.view.bounds.height
            let y: CGFloat = self.scanBackgroundView.frame.origin.x / self.view.bounds.width
            let width: CGFloat = self.scanBackgroundView.frame.height / self.view.bounds.height
            let height: CGFloat = self.scanBackgroundView.frame.width / self.view.bounds.width
            outPut.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        }

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = self.view.bounds
        self.view.layer.insertSublayer(layer, at: 0)
        self.previewLayer = layer
        return session
    }()
    var isScaned: Bool = false

    //MARK: -
    //MARK: Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.isOpaque = false
        self.view.backgroundColor = .clear
        self.view.insertSubview(scanDrawView, belowSubview: backBaseView)
        contentLabel.text = "扫描桌上二维码, 进行点餐 或者 关注餐馆".getLocaLized
        cancelButton.setTitle("放弃扫描".getLocaLized, for: .normal)
        ScanQRCode.shareInstance.beginScanQRCoder(scanView: scanBackgroundView, superView: self.view) {[weak self] (content) in
            if self?.isScaned == true { return }
            self?.isScaned = true
            self?.dismiss(animated: true) {
                self?.isScaned = false
                NotificationCenter.default.post(name: NotificationNames.showTakeInRestaurant, object: nil, userInfo: ["link": content])
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }


    @IBAction func cancelScanAction(_ sender: UIButton) {
        endScan()
        self.dismiss(animated: true, completion: nil)
    }

    private func startAnimation() {
        UIView.animate(withDuration: 1.5) {
            self.topLineConstraint.constant = self.scanBackgroundView.frame.height - 4
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }
    }

    private func startScan() {
        session?.startRunning()
    }

    private func endScan() {
        session?.stopRunning()
    }
}

extension GECScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var resultStrs: String = ""
        for obj in metadataObjects {
            guard let codeObj = obj as? AVMetadataMachineReadableCodeObject else {
                return
            }
            resultStrs.append(codeObj.stringValue ?? "")
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NotificationNames.showTakeInRestaurant, object: nil, userInfo: ["link": resultStrs])
            }
        }
    }
}

