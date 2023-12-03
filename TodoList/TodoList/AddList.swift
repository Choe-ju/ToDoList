//
//  AddList.swift
//  TodoList
//
//  Created by 최주원 on 11/12/23.
//

import SwiftUI
import SwiftData

struct AddNewList: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    @State private var titleEmptyAlert: Bool = false
    @State private var descriptionEmptyAlert: Bool = false
    
    var body: some View {
        
        Form{
            Section {
                TodoInput(titleInput: $title, descriptionInput: $description)
            }
            .navigationTitle(Text("New todo"))
        }
        Button {
            if title.isEmpty {
                titleEmptyAlert = true
            }else if description.isEmpty {
                descriptionEmptyAlert = true
            }else{
                addNewList()
            }
        } label: {
            Text("Add todo")
        }
        .font(Font.body.weight(.bold))
        .padding(.vertical, 7)
        .foregroundColor(Color.white)
        .frame(maxWidth: .infinity)
        .background(Color(red: 72/255, green: 130/255, blue: 1))
        .alert(Text("No title"),
               isPresented: $titleEmptyAlert,
               actions: {
            Button("Ok", role: .cancel) {}
        }) {
            Text("Please enter a title")
        }
        .alert(Text("No description"),
               isPresented: $descriptionEmptyAlert,
               actions: {
            Button("Skip") {
                addNewList()
            }
            Button("Cancel", role: .none) {}
        }) {
            Text("Would you like to description and skip it?")
        }
        
    }
    func addNewList(){
        context.insert(TodoItem(title: title, detail: description))
        dismiss()
    }
}
