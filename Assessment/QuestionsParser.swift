//
//  QuestionsParser.swift
//  Assessment
//
//  Created by bob on 18/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import Foundation

// Protocols to perform ations after processing the response
@objc protocol QuestionsParserDelegate: NSObjectProtocol {
    func didProcessAssessmentData(questions assessmentQuestions: [QuestionModel]?)
    @objc optional func didFailWithParseError()
}

/**
 *  @class QuestionsParser
 *  @protocol QuestionsParserDelegate
 *
 *  Parses the received assesment data
 */
class QuestionsParser: NSObject, XMLParserDelegate {
    
    var delegate: QuestionsParserDelegate?
    
    var parser: XMLParser?
    
    var flag: Bool?
    
    var captureString: String?
    
    var itemElementCount: Int8?
    var answerChoice: Bool?
    
    var assessmentQuestions: [QuestionModel]?
    
    var question: QuestionModel?

    override init() {
        super.init()
        
        // To keep track of parent and child elements
        itemElementCount = 0
        answerChoice = false
    }
    
    /**
     *  Processes assessment
     */
    func processAssessment(data: Data) {
        parser = XMLParser(data: data)
        parser!.delegate = self;
        parser!.parse()
    }
    
    // XMLParser delegate implementation
    func parserDidStartDocument(_ parser: XMLParser) {
        flag = false
        captureString = ""
        assessmentQuestions = []
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if delegate != nil { // Delegate exists
            delegate!.didProcessAssessmentData(questions: assessmentQuestions)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        flag = false
        captureString = ""
        
        switch elementName { // parsing through start tags
            case "item":
                
                // Parsed first item which is question
                if itemElementCount == 0 {
                    question = QuestionModel()
                    question?.answerChoice = []
                }
                
                // Reading answer choice
                if (itemElementCount == 1) && answerChoice! {
                    flag = true
                }
                
                itemElementCount = itemElementCount! + 1
                break
            case "answerChoice":
                answerChoice = true
                break
            case "question":
                flag = true
                break
            case "questionType":
                flag = true
                break
            case "correctAnswer":
                flag = true
                break
            case "assessmentID":
                flag = true
                break
            case "explanation":
                flag = true
                break
            default:
                break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        flag = false
        
        switch elementName { // Parsing through end tags
            case "item":
                
                // Parsed first item which is question
                if itemElementCount == 1 {
                    assessmentQuestions?.append(question!)
                }
                
                // Reading answer choice
                if (itemElementCount == 2) && answerChoice! {
                    question?.answerChoice?.append(captureString!)
                }
                
                itemElementCount = itemElementCount! - 1
                break
            case "answerChoice":
                answerChoice = false
                break
            case "question":
                question?.question = captureString!
                break
            case "questionType":
                question?.questionType = captureString!
                break
            case "correctAnswer":
                question?.correctAnswer = captureString!
                break
            case "assessmentID":
                question?.assessmentID = captureString!
                break
            case "explanation":
                question?.explanation = captureString!
                break
            default:
                break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // Can read
        if flag! {
            captureString = captureString! + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        if delegate != nil {
            if delegate!.responds(to: #selector(QuestionsParserDelegate.didFailWithParseError)) {
                delegate!.didFailWithParseError!()
            }
        }
    }
    
    
}
