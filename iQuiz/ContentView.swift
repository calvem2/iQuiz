//
//  ContentView.swift
//  iQuiz
//
//  Created by Megan on 5/5/21.
//

import SwiftUI
import Foundation
import Network


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
    
    @State private var showingPopover = false
    @State private var showingNetAlert = false
    @State private var showingDownAlert = false
    @State private var quizzes = [Quiz]()
    // Store settings in app settings
    @AppStorage("qURL") private var qURL = "https://tednewardsandbox.site44.com/questions.json"
    
    let monitor = NWPathMonitor()

    init() {
        // monitor nentwork connectivity
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    func isConnected() -> Bool {
        return monitor.currentPath.status == .satisfied
    }

    // load initial data when app launched
    func onMenuAppear() {
        if (quizzes.count == 0) {
            parseQuizzes()
        }
        
        if (quizzes.count == 0) {
            loadData()
        }
    }
    
    // fetch quiz data
    func loadData() {
        // check connectivity
        if (!isConnected()) {
            showingNetAlert = true
            print("not connected")
            return
        }
        
        guard let url = URL(string: qURL) else {
            showingDownAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        let results = decodedResponse as! NSMutableArray
                        // store JSON in local files
                        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.json")
                        do {
                            try results.write(to: path)
                        } catch {
                            print(error.localizedDescription)
                        }
                        parseQuizzes()
                    }
                    return
                }
            }

            showingDownAlert = true
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
    // populate quizzes with stored JSON data
    func parseQuizzes() {
        // read json file from local storage
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("questions.json")
        let questions = NSMutableArray(contentsOf: path)
        if (questions == nil) {
            showingDownAlert = true
            return
        }
                
        quizzes.removeAll()
        for res in questions! as [AnyObject] {
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
                }.navigationBarTitle("quizzes")
            }
            .onAppear(perform: onMenuAppear)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("iQuiz")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingPopover = true
                    }, label: {
                        Image(systemName: "gear")
                            .foregroundColor(.blue)
                        Text("Settings")
                            .foregroundColor(.blue)
                    }).popover(isPresented: $showingPopover) {
                        VStack {
                            Text("Settings")
                                .font(.headline)
                                .padding(.vertical)
                            Spacer()
                            HStack {
                                Spacer()
                                TextField("example.com/questions.json", text: $qURL)
                                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                    .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                Spacer()
                            }
                            .alert(isPresented: $showingNetAlert) {
                                Alert(title: Text("Network Unavailable"), message: Text("Could not download file"), dismissButton: .default(Text("Ok")))
                            }
                            Button(action: {
                                loadData()
                            }, label: {
                                Text("check now")
                                    .foregroundColor(.blue)
                            })
                            .alert(isPresented: $showingDownAlert) {
                                    Alert(title: Text("Download Failed"), message: Text("Something went wrong!"), dismissButton: .default(Text("Ok")))
                            }
                            Spacer()
                        }
                        
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
