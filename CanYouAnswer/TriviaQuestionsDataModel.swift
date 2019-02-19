//
//  TriviaQuestionsDataModel.swift
//  CanYouAnswer
//
//  Created by JustinCaty<3 on 2/18/19.
//  Copyright © 2019 JustinCaty<3. All rights reserved.
//

import UIKit

enum Category: Int {
    case music = 1
}

struct TrivaData: Decodable {
    var results: Array<Questions>
}

struct Questions: Decodable {
    var question: String
    var correct_answer: String
    var incorrect_answers: Array<String>
}

class TriviaQuestionsDataModel {
    let session = URLSession.shared
    
    func getTrivaQuestions(completionHandler: @escaping (TrivaData) -> ()) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=50&type=multiple") else {
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    print(data)
                    let results = try JSONDecoder().decode(TrivaData.self, from: data)
                    completionHandler(results)
                } catch {
                    print("Error \(error)")
                }
            }
        }.resume()
    }
}
