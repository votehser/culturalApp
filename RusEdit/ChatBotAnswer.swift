//
//  ChatBotAnswer.swift
//  RusEdit
//
//  Created by Maxim Reshetov on 11/04/2019.
//  Copyright © 2019 Maxim Reshetov. All rights reserved.
//

import UIKit

var randomAnswers = ["Хорошо", "Великолепно", "Лучше, чем у вас", "Нормально, а у вас как?", "Всё плохо"]

func ChatBotAnswer(text: String) -> String {
    let correctedText = text.lowercased()
    var answer = ""
    if correctedText == "привет" || correctedText == "здравствуйте" || correctedText == "добрый вечер" || correctedText == "добрый день" || correctedText == "приветствую" {
        answer = "Здравствуйте"
    } else if correctedText == "как дела?" || correctedText == "какие ваши дела?" || correctedText == "как вы поживаете?" || correctedText == "как дела?" {
        let randomIndex = Int(arc4random_uniform(UInt32(randomAnswers.count)))
        answer = randomAnswers[randomIndex]
    } else {
        answer = "Я вас не понимаю"
    }
    
    return answer
}
