//
//  GECTakeInWebViewController.swift
//  G-eatClient
//
//  Created by JS_Coder on 19/08/2019.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit

class GECTakeInWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var link: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "扫码点餐".getLocaLized
        webView.delegate = self
        let request = URLRequest(url:  URL(string: link)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        webView.loadRequest(request)
        self.showLoadingAnimation()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .done, target: self, action: #selector(dissmissAction))
    }

    @objc private func dissmissAction() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension GECTakeInWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.stopAnimating()
      self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
}
