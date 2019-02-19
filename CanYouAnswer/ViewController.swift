//
//  ViewController.swift
//  CanYouAnswer
//
//  Created by JustinCaty<3 on 2/18/19.
//  Copyright © 2019 JustinCaty<3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var questions: [Questions]?
    let trivaQuestions = TriviaQuestionsDataModel()
    
    @IBOutlet weak var answerLabel1: UIButton!
    @IBOutlet weak var answerLabel2: UIButton!
    @IBOutlet weak var answerLabel3: UIButton!
    @IBOutlet weak var answerLabel4: UIButton!
    
    var randomQuestion: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getMeQuestions()
    }
    
    func getMeQuestions() {
        trivaQuestions.getTrivaQuestions(completionHandler: { (TrivaData) in
            DispatchQueue.main.sync {
                self.questions = [Questions](TrivaData.results)
                self.updateQuestion()
            }
        })
    }
    
    func updateQuestion() {
        let btns = [answerLabel1, answerLabel2, answerLabel3, answerLabel4]
        
        if self.questions?.count == 0 {
            for button in btns as! [UIButton] {
                button.isEnabled = false
            }
            self.getMeQuestions()
            return
        }
        
        randomQuestion = Int.random(in: 0 ..< (self.questions?.count)!)

        let question = getQuestion(index: randomQuestion)
        let correctAnswer = getAnswersForQuestion(index: randomQuestion)
        let incorrectAnswers = getWrongAnswersForQuestion(index: randomQuestion)

        var allAnswers = incorrectAnswers
        allAnswers.append(correctAnswer)
        allAnswers.shuffle()
        
        guard let data = question.htmlAttributedString else { return }
        questionLabel.text = data.string
        
        for button in btns as! [UIButton] {
            button.isEnabled = true
            let answer = allAnswers[Int.random(in: 0 ..< (allAnswers.count))]
            answer.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: answer.length))
            button.setAttributedTitle(answer, for: .normal)
            allAnswers.removeAll { $0 == answer }
        }
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        let correctAnswer = questions![randomQuestion].correct_answer.htmlAttributedString!
        if correctAnswer == sender.titleLabel?.text?.htmlAttributedString {
            self.questions?.remove(at: randomQuestion)
            updateQuestion()
        }
    }
    
    func getQuestion(index: Int) -> String {
        return self.questions![index].question
    }
    
    func getAnswersForQuestion(index: Int) -> NSMutableAttributedString {
        return self.questions![index].correct_answer.htmlAttributedString!
    }
    
    func getWrongAnswersForQuestion(index: Int) -> Array<NSMutableAttributedString> {
        var attrAnswers = Array<NSMutableAttributedString>()
        self.questions![index].incorrect_answers.forEach {
            attrAnswers.append($0.htmlAttributedString!)
        }
        return attrAnswers
    }
    
}

extension String {
    
    var htmlAttributedString: NSMutableAttributedString? {
        return try? NSMutableAttributedString(data: Data(utf8), options: [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
