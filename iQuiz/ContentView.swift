//
//  ContentView.swift
//  iQuiz
//
//  Created by Megan on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var alertShown = false
    let quizzes = ["Mathematics": "PEMDAS anyone?",
                   "Marvel Super Heroes": "Put your knowledge of Maravel characters to the test",
                   "Science": "All things Earth, physical, and life science "]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(quizzes.sorted(by: <), id: \.key) { key, value in
                    HStack {
                        Image(systemName: "bolt")
                        VStack(alignment: .leading) {
                            Text(key)
                                .fontWeight(.semibold)
                            Text(value)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("iQuiz")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
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
