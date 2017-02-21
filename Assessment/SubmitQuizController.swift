//
//  SubmitQuizController.swift
//  Assessment
//
//  Created by bob on 19/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import UIKit

/**
 *  @class: SubmitQuizController
 *
 *  Controller class to submit the answers
 */
class SubmitQuizController: UIViewController, AssessmentWebserviceDelegate {
    
    @IBOutlet weak var submitStatusLabel: UILabel!
    
    var answers: [AnswerModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if answers exists
        if (self.answers?.count)! > 0 {
            let xmlBody = generateXmlStringWithAnswersData()  // Generate xml data
            print("xml body: \(xmlBody)")
            
            // submit assessment data
            let assessmentService = AssessmentWebservice()
            assessmentService.delegate = self
            assessmentService.submitAssessment(body: xmlBody)
        } else {
            print("Assessment answers missing")
            return
        }
    }
    
    // AssessmentWebserviceDelegate submit implementations
    func didSubmitAssessmentAnswers(urlResponse: URLResponse) {
        print("\n====\nFinal response: \(urlResponse)\n====\n")
        DispatchQueue.main.async {
            self.submitStatusLabel.text = "Submitted the assesment."
        }
    }
    
    func didFailToSubmitAssessmentAnswers() {
        DispatchQueue.main.async {
            self.submitStatusLabel.text = "Assesment submission failed."
        }
    }

    
    /**
     *  Generates xml string with answers data
     *  @return, String -> xmlString, Generated string
     */
    private func generateXmlStringWithAnswersData() -> String {
        var xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        xmlString.append("<map>")
        
        // Generate answer blocks
        for answer in self.answers! {
            xmlString.append("<\(answer.status!)>")
            xmlString.append("<list>")
            xmlString.append("<item><map>")
            xmlString.append("<assessmentID>\(answer.assessmentID!)</assessmentID>")
            xmlString.append("<timeTaken>\(answer.timeTaken!)</timeTaken>")
            xmlString.append("</map></item>")
            xmlString.append("<item>...</item>")
            xmlString.append("</list>")
            xmlString.append("</\(answer.status!)>")
        }
        
        xmlString.append("</map>")

        return xmlString
    }
}
