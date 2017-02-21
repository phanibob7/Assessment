//
//  AnswerModel.swift
//  Assessment
//
//  Created by bob on 19/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import Foundation

/**
 * @class AnswerModel
 *
 *  Model class for the answer
 */
class AnswerModel: NSObject {
    var assessmentID: String?
    var timeTaken: String?
    var status: String? // correct, wrong, skip
}
