//
//  RegularExpression.swift
//  TechnicalTest
//
//  Created by AT on 22/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation


struct RegularExpression {
    
    static func checkUpperCase(str: String) -> Bool {
        
        let charactersCount = RegularExpression.matchesForRegexInText(regex: "[A-Z]", text: str)
        let hasUpperCase = charactersCount.count > 0
        if !hasUpperCase {
            return false
        }
        return true
    }
    
    static func checkLowerCase(str: String) -> Bool {
        
        let charactersCount = RegularExpression.matchesForRegexInText(regex: "[a-z]", text: str)
        let hasLowerCase = charactersCount.count > 0
        if !hasLowerCase {
            return false
        }
        return true
    }
    
    static func checkNumericDigits(str: String) -> Bool {
        
        let charactersCount = RegularExpression.matchesForRegexInText(regex: "\\d", text: str)
        let hasNumbers = charactersCount.count > 0
        if !hasNumbers {
            return false
        }
        return true
    }
    
    static func matchesForRegexInText(regex: String, text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
            
            return results.map {
                nsString.substring(with: $0.range)
            }
        } catch let error as NSError {
            print("Invalid Regex: \(error.localizedDescription)")
            return []
        }
    }
}
