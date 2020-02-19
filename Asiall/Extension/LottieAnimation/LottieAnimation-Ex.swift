//
//  LottieAnimation-Ex.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/14.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
import Lottie
class LottieAnimation {
    static let shared = LottieAnimation()
    private var animationView: AnimationView!
    private var hubView: UIView!
    // Initialization
    private init() { }

    func startLottieAnimation(_ name: String = "restaurantLoading"){
        let animationView = AnimationView(name: name)
        animationView.loopMode = .loop
        self.animationView = animationView
        if let vc = UIApplication.shared.keyWindow?.rootViewController {

            let hubView = UIView()
            self.hubView = hubView
            hubView.backgroundColor = .black
            hubView.alpha = 0.2
            hubView.frame = vc.view.bounds

            animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            animationView.center = vc.view.center
            animationView.contentMode = .scaleAspectFill
            vc.view.addSubview(hubView)
            vc.view.addSubview(animationView)
        }
        animationView.play()
    }

    func stopLottieAnimation() {
        self.animationView.stop()
        self.hubView.removeFromSuperview()
        self.animationView.removeFromSuperview()
    }
}
