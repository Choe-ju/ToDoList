//
//  TodoListApp.swift
//  TodoList
//
//  Created by 최주원 on 11/7/23.
//

import SwiftUI
import SwiftData

@main
struct TodoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: TodoItem.self)
        }
    }
}
