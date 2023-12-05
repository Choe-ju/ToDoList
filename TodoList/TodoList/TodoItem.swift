//
//  TodoItem.swift
//  TodoList
//
//  Created by 최주원 on 12/3/23.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
    @Attribute(.unique) var id = UUID()
    var title: String
    var detail: String
    var completed: Bool
    
    init(title: String = "", detail: String = "None", completed: Bool = false) {
        self.title = title
        self.detail = detail
        self.completed = completed
    }
}
