//
//  ContentView.swift
//  iQuiz
//
//  Created by Megan on 5/5/21.
//

import SwiftUI
import Foundation

struct Quiz: Identifiable {
    public var id = UUID()
    public var title: String = ""
    public var desc: String = ""
    public var questions: [Question] = []
}

struct Question: Identifiable {
    public var id = UUID()
    public var text: String = ""
    public var answer: Int = 0
    public var answers: [String] = []
}

struct ContentView: View {
    @State private var alertShown = false
    @State private var quizzes = [Quiz]()

    func loadData() {
        guard let url = URL(string: "https://tednewardsandbox.site44.com/questions.json") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        let resultArray = decodedResponse as! NSMutableArray
                        quizzes.removeAll()
                        for res in resultArray as [AnyObject] {
                            var quiz = Quiz()
                            quiz.title = res["title"] as! String
                            quiz.desc = res["desc"] as! String
                            
                            // parse questions
                            let questions = res["questions"] as! [[String: Any]]
                            for q in questions {
                                var question = Question()
                                question.text = q["text"] as! String
                                question.answer = Int(q["answer"] as! String)!
                                question.answers = q["answers"] as! [String]
                                quiz.questions.append(question)
                            }
                            self.quizzes.append(quiz)
                        }
                    }
                    return
                }
            }

            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
    var body: some View {
        NavigationView {
            List(quizzes) { quiz in
                NavigationLink(destination: QuizView(questions: quiz.questions)) {
                    HStack {
                        Image(systemName: "bolt")
                        VStack(alignment: .leading) {
                            Text(quiz.title)
                                .fontWeight(.semibold)
                            Text(quiz.desc)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                
                        }
                    }
                }.navigationBarTitle("back")
            }
            .onAppear(perform: loadData)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("iQuiz")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.alertShown = true
                    }, label: {
                        Image(systemName: "gear")
                            .foregroundColor(.blue)
                        Text("Settings")
                            .foregroundColor(.blue)
                    }).alert(isPresented: $alertShown) { () -> Alert in
                        Alert(title: Text("Settings"), message: Text("Settings go here"), dismissButton: .default(Text("Ok")))
                    }
                }
            }
            .foregroundColor(.purple)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
