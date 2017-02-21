//
//  QuizController.swift
//  Assessment
//
//  Created by bob on 19/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import UIKit

/**
 *  @class: QuizController
 *
 *  Contoller performs quiz
 */
class QuizController: UIViewController {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    var questions: [QuestionModel]?
    var answers: [AnswerModel]?
    
    var selectedAnswer: AnswerModel?
    
    var currentQuestionIndex: Int?
    
    var currentQuestion: QuestionModel?
    
    var timeTakenToAnswer: String?
    
    // Timer
    var seconds = 0
    var timer = Timer()
    var isTimerOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionIndex = 0
        answers = []
        
        print("No of question: \(self.questions?.count)")
        
        if (self.questions?.count)! < 1 { // check the questions
            return
        }
        
        currentQuestion = self.questions?[currentQuestionIndex!]
        displayQuestion(question: (self.questions?[currentQuestionIndex!])!)
    }
    
    /**
     *  Displays the question in the layout
     *  @param, QuestionModel -> the question object
     */
    func displayQuestion(question: QuestionModel) {
        currentQuestion = question
        self.questionLabel.text = question.question
        self.answer1.setTitle(question.answerChoice?[0], for: .normal)
        self.answer2.setTitle(question.answerChoice?[1], for: .normal)
        self.answer3.setTitle(question.answerChoice?[2], for: .normal)
        self.answer4.setTitle(question.answerChoice?[3], for: .normal)
        
        self.answer4.sizeToFit()
        
        // Word wraping
        answer1.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        answer1.titleLabel?.adjustsFontSizeToFitWidth = true
        answer1.titleLabel?.lineBreakMode = .byWordWrapping
        answer1.setTitleColor(UIColor.white, for: .normal)
        
        answer2.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        answer2.titleLabel?.adjustsFontSizeToFitWidth = true
        answer2.titleLabel?.lineBreakMode = .byWordWrapping
        answer2.setTitleColor(UIColor.white, for: .normal)
        
        answer3.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        answer3.titleLabel?.adjustsFontSizeToFitWidth = true
        answer3.titleLabel?.lineBreakMode = .byWordWrapping
        answer3.setTitleColor(UIColor.white, for: .normal)
        
        answer4.titleLabel?.numberOfLines = 0; // Dynamic number of lines
        answer4.titleLabel?.adjustsFontSizeToFitWidth = true
        answer4.titleLabel?.lineBreakMode = .byWordWrapping
        answer4.setTitleColor(UIColor.white, for: .normal)
       
        selectedAnswer = AnswerModel() // Initilize answer

        startTimer()
    }
    
    /**
     *  Performs action on selecting option
     */
    @IBAction func checkTheSelectedAnswer(_ sender: UIButton) {
        self.timeTakenToAnswer = self.timerLabel.text
        stopTimer()
        currentQuestionIndex = currentQuestionIndex! + 1
        let selectedOption = sender as UIButton!
        
        // selection choice is correct
        if selectedOption?.titleLabel?.text == currentQuestion?.correctAnswer {
            selectedOption?.setTitleColor(UIColor.green, for: .normal)
            saveAnswer(status: "correct") // Save answer
            
            // Delaying for visual confirmation
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.changeQuestion()
            }

        } else {
            selectedOption?.setTitleColor(UIColor.red, for: .normal)
            saveAnswer(status: "wrong") // Save answer
            
            // Show alert of explanation
            let alertController = UIAlertController(title: nil, message:
                currentQuestion?.explanation, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: {(action: UIAlertAction) in
                
                // Delaying for visual confirmation
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.changeQuestion()
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func skipTheQuestion(_ sender: Any) {
        self.timeTakenToAnswer = self.timerLabel.text
        stopTimer()
        currentQuestionIndex = currentQuestionIndex! + 1
        saveAnswer(status: "skip") // Save answer
        changeQuestion()
    }
    
    /**
     *  Moves control to next question
     */
    func changeQuestion() {
        if self.currentQuestionIndex! < (self.questions?.count)! { // Questions exists
            self.displayQuestion(question: (self.questions?[self.currentQuestionIndex!])!)
        } else {
            self.performSegue(withIdentifier: "ShowQuizFinished", sender: nil)
        }
    }
    
    /**
     *  Saves the answer with status
     *  @param, String -> status of the answer(correct, wrong, skip)
     */
    func saveAnswer(status: String) {
        
        // Saving the answer
        self.selectedAnswer?.assessmentID = self.currentQuestion?.assessmentID
        self.selectedAnswer?.timeTaken = self.timeTakenToAnswer
        self.selectedAnswer?.status = status
        self.answers?.append(self.selectedAnswer!)
    }
    
    // Timer realted stuff
    func startTimer() {
        if isTimerOn == false { // Timer is off
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(QuizController.updateTimer)), userInfo: nil, repeats: true)
            isTimerOn = true
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        seconds = 0
        timerLabel.text = formatSeconds(seconds: seconds)
        isTimerOn = false
    }
    
    func updateTimer() {
        seconds += 1
        timerLabel.text = formatSeconds(seconds: seconds)
        print("Seconds: \(formatSeconds(seconds: seconds))")
    }
    
    /**
     *  Formats seconds to display as timer
     *  @param, Int -> seconds
     *  @return, String -> formatted string
     */
    func formatSeconds(seconds: Int) -> String {
        var timerString = "00:00"
        
        // Formatting seconds
        if seconds < 10 {
            timerString = "00:" + "0\(seconds)"
        }
        else if seconds < 60 {
            timerString = "00:" + "\(seconds)"
        }else if seconds < 3600 {
            let minutes = Int(seconds/60)
            let seconds = seconds % 60
            timerString =
                "\(minutes)" + ":" + "\(seconds)"
        }else {
            let hours = Int(seconds/3600)
            let minutes = Int(seconds/60)-(Int(seconds/3600)*60)
            let seconds = seconds % 60
            timerString =
                "\(hours)" + ":" + "\(minutes)" + ":" + "\(seconds)"
        }
        
        return timerString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // Sending the saved answers
        if segue.identifier == "ShowQuizFinished" {
            if let destinationVC = segue.destination as? SubmitQuizController {
                destinationVC.answers = self.answers!
            }
        }
        
    }

}
