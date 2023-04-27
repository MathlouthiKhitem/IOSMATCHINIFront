//
//  matchiniiApp.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 9/3/2023.
//

import SwiftUI


@main
struct matchiniiApp: App {
    let persistenceController = PersistenceController.shared
    let defaults = UserDefaults.standard
    
   var body: some Scene {
        WindowGroup {
//            FriendsList(login:(UserDefaults.standard.object(forKey: "login") as? String)!)

            if defaults.object(forKey: "login") != nil {
                matche(login:(UserDefaults.standard.object(forKey: "login") as? String)!)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                login()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
   }
}

