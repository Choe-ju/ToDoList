//
//  AddList.swift
//  TodoList
//
//  Created by 최주원 on 11/12/23.
//

import SwiftUI

struct AddNewList: View {
    
    @StateObject var todoListStore : TodoListStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var completed = false
    
    var body: some View {
        
        Form{
            Section {
                DataInput(title: "Title", userInput: $title)
                DataInput(title: "Description", userInput: $description)
            }
            .navigationTitle(Text("New todo"))
        }
        Button {
            addNewList()
        } label: {
            Text("Add todo")
        }.font(Font.body.weight(.bold))
            .padding(.vertical, 7)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .background(Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00))
    }
    func addNewList(){
        let newList = TodoList(id: todoListStore.todoList.count+1, title: title, description: description, completed: completed)
        
        todoListStore.todoList.append(newList)
        dismiss()
    }
}

struct DataInput : View {
    
    var title: String
    @Binding var userInput: String
    
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .font(.headline)
                Spacer()
            }
            TextField("Enter \(title)", text: $userInput)
                .font(.body)
        }
    }
}

//#Preview {
//    AddList()
//}
