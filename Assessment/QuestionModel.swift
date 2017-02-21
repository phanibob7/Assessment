//
//  Question.swift
//  Assessment
//
//  Created by bob on 18/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import Foundation

/**
 * @class QuestionModel
 * 
 *  Model class for the question
 */
class QuestionModel: NSObject {
    var assessmentID: String?
    var question: String?
    var questionType: String?
    var correctAnswer: String?
    var explanation: String?
    var answerChoice: [String]?
}
