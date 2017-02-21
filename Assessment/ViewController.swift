//
//  ViewController.swift
//  Assessment
//
//  Created by bob on 17/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import UIKit

/**
 *  @class: ViewController
 *
 *  Main controller to get assessment data
 */
class ViewController: UIViewController, AssessmentWebserviceDelegate, QuestionsParserDelegate {
    
    @IBOutlet weak var takeTestBtn: UIButton!
    
    var questionsParser: QuestionsParser?
    
    var questions: [QuestionModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.takeTestBtn.isEnabled = false
        
        // get assessment data
        let assessmentService = AssessmentWebservice()
        assessmentService.delegate = self
        assessmentService.getAssessment()
    }
    
    
    // AssessmentWebServiceDelegate implementations
    func didReceiveAssessmentData(data: Data) {
        
        // do parsing
        print("Data: \(data)")
        questionsParser = QuestionsParser()
        questionsParser?.delegate = self
        questionsParser?.processAssessment(data: data)
        print()
    }
    
    func didFailToReceiveAssessmentData() {
        let alertController = UIAlertController(title: nil, message:
            "Network connection not available.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // QuestionsParserDelegate implementations
    func didProcessAssessmentData(questions assessmentQuestions: [QuestionModel]?) {
        self.questions = assessmentQuestions
        self.takeTestBtn.isEnabled = true
    }
    
    func didFailWithParseError() {
        print("Parse error")
    }
    
    
    @IBAction func takeTest(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowQuiz", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Sending the fetched questions
        if segue.identifier == "ShowQuiz" {
            if let destinationVC = segue.destination as? QuizController {
                destinationVC.questions = self.questions!
            }
        }

    }
    
}

