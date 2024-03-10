//
//  NasaApp.swift
//  Nasa
//
//  Created by Zhora Babakhanyan on 08/03/2024.
//

import SwiftUI

@main
struct NasaApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var homeViewModel = HomeViewModel(networkManager: NetworkManager())
    var body: some Scene {
        WindowGroup {
           PrealoderView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(homeViewModel)
        }
    }
}
