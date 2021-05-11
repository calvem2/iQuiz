//
//  QuizView.swift
//  iQuiz
//
//  Created by Megan on 5/10/21.
//

import SwiftUI

struct QuizView: View {
    @State private var scene = "question"
    var body: some View {
        if (scene == "question") {
            VStack {
                
            }
        } else if (scene == "answer") {
            VStack {
                
            }
        } else {
            VStack {
                
            }
        }
    
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
