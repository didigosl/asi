//
//  String-Extension.swift
//  G-eatClient
//
//  Created by JS_Coder on 2019/1/13.
//  Copyright © 2019 GoEat. All rights reserved.
//

import Foundation
import UIKit
let visaPattern = "^4[0-9]{12}(?:[0-9]{3})?$"
let masterPattern = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"

extension String {
    // getLocalized
    var getLocaLized: String {
        get{
            return NSLocalizedString(self, comment: "")
        }
    }

    var getIdentifier: String {
        get {
            return "\(self)_identifier"
        }
    }

    func checkCreditCard ()-> (errorString: String? , isVisa: Bool) {

        var visaRes = ""
        var masterRes = ""
        // - 1、创建规则

        // - 2、创建正则表达式对象
        let visaRegex = try! NSRegularExpression(pattern: visaPattern, options: NSRegularExpression.Options.caseInsensitive)
        let masterRegex = try! NSRegularExpression(pattern: masterPattern, options: NSRegularExpression.Options.caseInsensitive)
        // - 3、开始匹配
        let visaResult = visaRegex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count))
        let masterResult = masterRegex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count))
        // 输出结果
        for visaCheck in visaResult {
            visaRes = visaRes + (self as NSString).substring(with: visaCheck.range)
        }

        for masterCheck in masterResult {
            masterRes = masterRes + (self as NSString).substring(with: masterCheck.range)
        }

        if visaRes == self{
            return (nil, true)
        }else if masterRes == self{
            return (nil, false)
        }else {
            return ("不匹配银行卡", false)
        }
    }

    /*
     Algoritm Luhn
     */
    func checkCardNumber(isValid: ((_ valido: Bool)->())){
        let formattedCardNumber = self.formattedCardNumber()


        let originalCheckDigit = formattedCardNumber.last!
        let characters = formattedCardNumber.dropLast().reversed()

        var digitSum = 0

        for (idx, character) in characters.enumerated() {
            let value = Int(String(character)) ?? 0
            if idx % 2 == 0 {
                var product = value * 2

                if product > 9 {
                    product = product - 9
                }

                digitSum = digitSum + product
            }
            else {
                digitSum = digitSum + value
            }
        }

        digitSum = digitSum * 9

        let computedCheckDigit = digitSum % 10

        let originalCheckDigitInt = Int(String(originalCheckDigit))
        let valid = originalCheckDigitInt == computedCheckDigit

        if valid == false {
            isValid(false)
        }else {
            isValid(true)
        }
    }

    public func formattedCardNumber() -> String {
        let numbersOnlyEquivalent = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return numbersOnlyEquivalent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func underLine() -> NSAttributedString{
        let line = NSAttributedString(string: self, attributes:  [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return line
    }

    func getSizeWithFont(font: UIFont, maxSize: CGSize) -> CGSize{
        let size = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
        return size

    }
}

