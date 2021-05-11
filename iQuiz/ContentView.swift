//
//  ContentView.swift
//  iQuiz
//
//  Created by Megan on 5/5/21.
//

import SwiftUI
import Foundation

//struct Quizzes: Codable {
////    public var id = UUID()
//    public var quizzes: [Quiz]
//
////    public var questions: Bool
//}

struct Quiz: Identifiable {
    public var id = UUID()
    public var title: String = ""
    public var desc: String = ""
    
//    public var questions: Bool
}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
//    public var id = UUID()
//    public var title: String
//    public var desc: String
}


//class FetchQuizzes: ObservableObject {
//  // 1.
//  @Published var quizzes = [Quiz]()
//
//    init() {
//        let url = URL(string: "http://tednewardsandbox.site44.com/questions.json")!
//        // 2.
//        URLSession.shared.dataTask(with: url) {(data, response, error) in
//            do {
//                if let quizData = data {
//                    // 3.
//                    let decodedData = try JSONDecoder().decode([Quiz].self, from: quizData)
//                    DispatchQueue.main.async {
//                        self.quizzes = decodedData
//                    }
//                } else {
//                    print("No data")
//                }
//            } catch {
//                print("Error")
//            }
//        }.resume()
//    }
//}

struct ContentView: View {
    @State private var alertShown = false
//    @ObservedObject var fetch = FetchQuizzes()
    @State private var quizzes = [Quiz]()
//    @State private var results = [Result]()
//    let jsonData =
//      ("[{\"lastName\":\"Neward\",\"firstName\":\"Ted\"}," +
//       "{\"lastName\":\"Neward\",\"firstName\":\"Charlotte\"}]")
//       .data(using: .utf8)
//
//    let people = try JSONSerialization.jsonObject(with: jsonData!)
    
//    print(people)
//    let quizzes = ["Mathematics": "PEMDAS anyone?",
//                   "Marvel Super Heroes": "Put your knowledge of Maravel characters to the test",
//                   "Science": "All things Earth, physical, and life science "]
//
    func loadData() {
//        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
//            print("Invalid URL")
//            return
//        }
////        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let decodedResponse = try? JSONDecoder().decode(Quizzes.self, from: data) {
//                    // we have good data – go back to the main thread
////                    DispatchQueue.main.async {
//                        // update our UI
//                        self.quizzes = decodedResponse.quizzes
//                        print(self.quizzes)
////                    }
//
//                    // everything is good; exit
//                    return
//                }
//            }
//
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
//        }.resume()
        guard let url = URL(string: "https://tednewardsandbox.site44.com/questions.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // step 4
//            guard let data = data,
//                    error == nil,
//                    let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
//                    let featuresArray = json["features"] as? [[String: Any]] else {
//                        print("Either no data was returned in AlertDataController.checkWxAlert, or data was not serialized.")
//
////                        completion(nil)
//                        return
//                }
//
//                let propertiesArray = featuresArray.flatMap { $0["properties"] }
//                let alertData = AlertData(json: propertiesArray)
//                completion(alertData)
            

            if let data = data {
//                if let peopleJson = try? JSONSerialization.data(withJSONObject: data) {
//                    let peopleJsonString = String(data: peopleJson, encoding: .utf8)
//                    print(peopleJsonString!)
//                    return
//                }

                print("Hello")
                // works w taylor swift
//                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
//                        self.results = decodedResponse.results
//                        for quiz in decodedResponse {
//                            print(quiz)
//                        }
//                        for quiz in decodedResponse {
//                            print(quiz)
//                        }
//                        for vehicle in (decodedResponse as NSArray as! [Quiz]) {
//                            println(vehicle.registration)
//                        }
                        let resultArray = decodedResponse as! NSMutableArray
                        for res in resultArray as [AnyObject] {
                            var quiz = Quiz()
                            quiz.title = res["title"] as! String
                            quiz.desc = res["desc"] as! String
                            quizzes.append(quiz)
                            print(quiz)
                        }
//                        print(decodedResponse)
//                        print(type(of: decodedResponse))
//                        print(resultArray)
//                        print(String(data: decodedResponse, encoding: .utf8)!)
                    }
//                    print(decodedResponse)
//                    print(type(of: decodedResponse))
                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
//            print(data)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
    }
    
    var body: some View {
        NavigationView {
            List(quizzes) { quiz in
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
            }
            .onAppear(perform: loadData)
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
