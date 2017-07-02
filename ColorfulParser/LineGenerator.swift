//
//  LineGenerator.swift
//  ColorfulParser
//
//  Created by Artem Misesin on 7/2/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class LineGenerator {
    
    static let shared = LineGenerator()
    
    func lineColor(from word: String) -> UIColor {
        
        // given words are converted into hex code
        // then we take last 6 symbols of it to use in a UIColor init
        
        let data = word.data(using: .utf8)!
        var hexText = data.hexEncodedString()
        if hexText.characters.count >= 6 {
            let endIndex = hexText.index(hexText.endIndex, offsetBy: -6)
            hexText = hexText.substring(with: endIndex..<hexText.endIndex)
        } else {
            hexText = hexText.padding(toLength: 6, withPad: "0", startingAt: 0)
        }
        hexText = "#" + hexText
        return UIColor(hexString: hexText, alpha: 1)
    }
    
    func lineHeight(from word: String) -> CGFloat {
        
        // given words are converted into hex code
        // then we take first 2 symbols of it, convert them into Int to use as a line height
        
        let data = word.data(using: .utf8)!
        var hexText = data.hexEncodedString()
        if hexText.characters.count >= 1{
            let endIndex = hexText.index(hexText.startIndex, offsetBy: 2)
            hexText = hexText.substring(with: hexText.startIndex..<endIndex)
        }
        if let value = UInt8(hexText, radix: 16) {
            return CGFloat(value)
        }
        return CGFloat(10)
    }
    
}
