//
//  AssessmentWebservice.swift
//  Assessment
//
//  Created by bob on 18/02/17.
//  Copyright © 2017 bobzzz. All rights reserved.
//

import Foundation

// Protocols to perform ations after getting the response
@objc protocol AssessmentWebserviceDelegate: NSObjectProtocol {
    @objc optional func didReceiveAssessmentData(data: Data)
    @objc optional func didFailToReceiveAssessmentData()
    @objc optional func didSubmitAssessmentAnswers(urlResponse: URLResponse)
    @objc optional func didFailToSubmitAssessmentAnswers()
}

/**
 *  @class: AssessmentWebservice
 *  @protocol: AssessmentWebserviceDelegate
 *
 *  Class is basically a webservice to get and post assessment data
 *
 */
class AssessmentWebservice : NSObject, URLSessionDelegate {

    var delegate: AssessmentWebserviceDelegate?
    
    /*
     http://cogknit.getsandbox.com/getassessment
     Request-type : GET
     Content-type : application/xml
     Sample response: <map><data><list><item><map><answerChoice><list><item>Compromising</item><item>Avoiding</item><item>Competing</item><item>Collaboration</item></list></answerChoice><assessmentID>a8c72bb2-b514-4eba-8ffb-198df5ddea58</assessmentID><explanation>Collaboration means cooperating with the other party to understand their concerns and expressing your own concerns in an effort to find a mutually and completely satisfactory solution (win-win).</explanation><question>Which of the conflict management styles would be most often employed where two parties from similar cultures are in conflict?</question><questionType>multiple</questionType><correctAnswer>Collaboration</correctAnswer></map></item></list></data></map>
     */
    private let getAssessmentUrl = URL(string: "https://cogknit.getsandbox.com/getassessment")
    
    /*
     http://cogknit.getsandbox.com/submitAssessment
     Request-type : POST
     Content-type : application/xml
     Request body: <map><correct><list><item><map><assessmentID>92oi-sdkl32-93dsklfl</assessmentID><timeTaken></timeTaken></map></item><item>...</item></list></correct><wrong><list><item><map><assessmentID>43957-123423-124123</assessmentID><timeTaken></timeTaken></map></item><item>...</item></list></wrong><skip><list><item><map><assessmentID>43957-123423-124123</assessmentID><timeTaken></timeTaken></map></item><item>...</item></list></skip></map>
     */
    private let submitAssessmentUrl = URL(string: "https://cogknit.getsandbox.com/submitAssessment")
    
    /**
     *  Gets the assessment data
     */
    func getAssessment() {
        let urlRequest = NSMutableURLRequest(url: getAssessmentUrl!)
        urlRequest.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "GET"
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            
            if error != nil { // error
                print("Response error: \(error)")

                // execute only if delegate method implemented
                if self.delegate != nil {
                    if self.delegate!.responds(to: #selector(AssessmentWebserviceDelegate.didFailToReceiveAssessmentData)) {
                        self.delegate?.didFailToReceiveAssessmentData?()
                    }
                }
            } else if httpResponse?.statusCode == 200 { // data recieved
                
                // execute only if delegate method implemented
                if self.delegate != nil {
                    if self.delegate!.responds(to: #selector(AssessmentWebserviceDelegate.didReceiveAssessmentData)) {
                        self.delegate?.didReceiveAssessmentData?(data: data!)
                    }
                }
            } else {
                print("Response code: \(httpResponse?.statusCode)")
            }
        })
        task.resume()
    }
    
    /**
     *  Submits the assessment data
     *  @param, String -> body, xml body
     */
    func submitAssessment(body: String) {
        let urlRequest = NSMutableURLRequest(url: submitAssessmentUrl!)
        urlRequest.setValue("application/xml", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse

            if error != nil { // error
                print("Response error: \(error)")
                
                // execute only if delegate method implemented
                if self.delegate != nil {
                    if self.delegate!.responds(to: #selector(AssessmentWebserviceDelegate.didFailToSubmitAssessmentAnswers)) {
                        self.delegate?.didFailToSubmitAssessmentAnswers?()
                    }
                }
            } else if httpResponse?.statusCode == 200 { // data recieved
                
                // execute only if delegate method implemented
                if self.delegate != nil {
                    if self.delegate!.responds(to: #selector(AssessmentWebserviceDelegate.didSubmitAssessmentAnswers)) {
                        self.delegate?.didSubmitAssessmentAnswers?(urlResponse: response!)
                    }
                }
            } else {
                print("Response code -: \(httpResponse?.statusCode)")
            }
        })
        task.resume()
    }

}
