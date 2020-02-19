//
//  GECVideoPlayerController.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/24.
//  Copyright © 2019 GoEat. All rights reserved.
//

import UIKit
import AVFoundation
class GECPlayerController: UIViewController {

    private var player: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    private func setup() {
        let path = Bundle.main.path(forResource: "aquaman.mp4", ofType: "");
        player = AVPlayer(url: URL(string: path!)!)
        let layer = AVPlayerLayer(layer: player)
        layer.frame = view.bounds
        self.view.layer.addSublayer(layer)
        player.play()
    }




}
