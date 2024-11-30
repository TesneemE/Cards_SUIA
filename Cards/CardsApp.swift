//
//  CardsApp.swift
//  Cards
//
//  Created by Tes Essa on 10/17/24.
//

import SwiftUI

@main
struct CardsApp: App {
//    init() {
//      Team.save()
//    }
//    init() {
//      Team.load()
//    }
//    @StateObject var store = CardStore() //new instanitiation no defualt data
//    @StateObject var store = CardStore(defaultData: true) //instantiate CardStore w/ defaul data
    @StateObject var store = CardStore(defaultData: false)
    var body: some Scene {
        WindowGroup {
            AppLoadingView()
                .environmentObject(store) //address the data store through environment
                .onAppear {
                  print(URL.documentsDirectory)
                }
        }
    }
}
//struct Team: Codable {
//    let names: [String]
//    let count: Int
//    static func save() {
//      do {
//    // 1
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        // 2
//        let data = try encoder.encode(teamData)
//        // 3
//        let url = URL.documentsDirectory
//          .appendingPathComponent("TeamData")
//        try data.write(to: url)
//    } catch {
//      print(error.localizedDescription)
//    } }
//    static func load() {
//      // 1
//      let url = URL.documentsDirectory
//        .appendingPathComponent("TeamData")
//    do { // 2
//        let data = try Data(contentsOf: url)
//        // 3
//        let decoder = JSONDecoder()
//        // 4
//        let team = try decoder.decode(Team.self, from: data)
//        print(team)
//      } catch {
//        print(error.localizedDescription)
//      }
//    }
//}
//let teamData = Team(
//  names: [
//  "Richard", "Libranner", "Caroline", "Audrey", "Sandra"
//  ], count: 5)
