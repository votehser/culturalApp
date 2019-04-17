//
//  Additional.swift
//  RusEdit
//
//  Created by Maxim Reshetov on 10/04/2019.
//  Copyright © 2019 Maxim Reshetov. All rights reserved.
//

import UIKit

struct Message {
    let text: String
    let isSender: Bool
    let color: UIColor
}

var messages: [Message] = []

let correctWords = ["привет", "не за что", "почему", "причем", "зачем"]

var changedWords = [String]()

func offerSuggestions(textFieldText: String) -> Bool {
    
    var open = false
    
    changedWords = [String]()
    
    var check: Double = 0
    var control: Double = 0
    
    let words = textFieldText.lowercased().components(separatedBy: " ")
    for word in words {
        for correctWord in correctWords {
            check = 0
            control = Double(correctWord.count)
            for letter in word {
                if correctWord.contains(letter) {
                    check += 1
                }
            }
            print(check / control)
            if (check / control >= 0.6) && (check / control != 1) {
                let cword = "\(word) -> \(correctWord)"
                changedWords.append(cword)
                open = true
            }
        }
    }
    return open
}
