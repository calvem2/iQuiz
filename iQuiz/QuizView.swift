//
//  QuizView.swift
//  iQuiz
//
//  Created by Megan on 5/10/21.
//

import SwiftUI

struct QuizView: View {
    @State private var questions: [Question]
    @State private var currQ: Int = 0
    @State private var scene = "question"
    @State private var selected = 0
    @State private var numCorrect = 0
    
    func buildChoice(qIndex : Int) -> some View {
        var color : Color
        if (scene == "question") {
            color = selected == qIndex + 1 ? .purple : .black
        } else {
            if (qIndex + 1 == Int(questions[currQ].answer)) {
                color = .green
            } else if (selected == qIndex + 1) {
                color = .red
            } else {
                color = .black
            }
        }
        return
            HStack {
                Spacer()
                Button(action: {
                    if (scene == "question") {
                        selected = qIndex + 1
                    }
                }) {
                    HStack {
                        Spacer()
                        Text(questions[currQ].answers[qIndex])
                            .multilineTextAlignment(.center)
                            .padding()
                            
                        Spacer()
                    }
                    .foregroundColor(color)
                    .border(color)

                }
                .disabled(scene != "question")
                Spacer()
            }
    }
    
    func getFeedback() -> String {
        let percent: Double = Double(numCorrect) / Double(questions.count) * 100.0
        var feedback: String
        if (numCorrect == questions.count) {
            feedback = "Perfect!"
        } else if (percent > 75) {
            feedback = "Almost!"
        } else if (percent > 50) {
            feedback = "Good effort!"
        } else {
            feedback = "Yikes"
        }
        return feedback
    }
    
    var body: some View {
        
        if (scene == "question") {
            VStack {
                Spacer()
                Text(questions[currQ].text)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                Spacer()
                
                VStack {
                    ForEach((0..<questions[currQ].answers.count), id: \.self) { q in
                        buildChoice(qIndex: q)
                    }
                }

                Button(action: {
                    scene = "answer"
                    if(selected == Int(questions[currQ].answer)) {
                        numCorrect += 1
                    }
                }) {
                    Text("Submit")
                }
                .padding(.top)
                .foregroundColor(selected == 0 ? .gray : /*@START_MENU_TOKEN@*/.purple/*@END_MENU_TOKEN@*/)
                .disabled(selected == 0)
                Spacer()
            }
        } else if (scene == "answer") {
            VStack {
                Spacer()
                
                Text(questions[currQ].text)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                Text("\(selected == Int(questions[currQ].answer) ? "Correct :)" : "Incorrect :(")")
                Spacer()
                // todo add show correct answer logic
                VStack {
                    ForEach((0..<questions[currQ].answers.count), id: \.self) { q in
                        buildChoice(qIndex: q)
                    }
                }
                
                Button(action: {
                    if (currQ + 1 < questions.count) {
                        scene = "question"
                        selected = 0
                        currQ += 1
                    } else {
                        scene = "results"
                    }
                }) {
                    Text("next")
                }
                .padding(.top)
                .foregroundColor(/*@START_MENU_TOKEN@*/.purple/*@END_MENU_TOKEN@*/)
                Spacer()
            }
        } else {
            let percent: Double = Double(numCorrect) / Double(questions.count) * 100.0
            
            VStack {
                Text("\(percent, specifier: "%.2f")%")
                    .font(.title)
                    .fontWeight(.bold)
                Text(getFeedback())
                    .font(.title2)
                Text("You answered \(numCorrect) of \(questions.count) questions correctly")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
