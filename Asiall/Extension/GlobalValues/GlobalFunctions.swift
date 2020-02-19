//
//  GlobalFunctions.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/6/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import AudioToolbox

func playSystemSoundWithPlus() {
    AudioServicesPlaySystemSound(1519) // 震动
}
func playSystemSoundWithSubtract() {
    AudioServicesPlaySystemSound(1520) // 震动
}


func getCurrentLanguage() -> Int {
    let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
    switch String(describing: preferredLang) {
    case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
        return 1//中文
    default:
        return 2
    }
}

func checkTime(originTimeStr: String, maxTime: TimeInterval) -> Bool {
    let formatterStr = DateFormatter()
    formatterStr.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let originDate = formatterStr.date(from: originTimeStr) {
        let nowDate = Date()
        return nowDate.timeIntervalSince1970 - originDate.timeIntervalSince1970 < maxTime
    }
    return true
}
