//
//  ModifyView.swift
//  TodoList
//
//  Created by 최주원 on 11/19/23.
//

import SwiftUI

struct ModifyView: View {
    
    @Binding var modifyTodoList : TodoItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var titleEmptyAlert: Bool = false
    @State private var descriptionEmptyAlert: Bool = false
    
    var body: some View {
        
        Form{
            Section {
                TodoInput(titleInput: $modifyTodoList.title, descriptionInput: $modifyTodoList.detail)
            }
        }
        Button {
            if modifyTodoList.title.isEmpty {
                titleEmptyAlert = true
            }else if modifyTodoList.detail.isEmpty {
                descriptionEmptyAlert = true
            }else{
                dismiss()
            }
        } label: {
            Text("Complete")
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
                dismiss()
            }
            Button("Cancel", role: .none) {}
        }) {
            Text("Would you like to description and skip it?")
        }
    }
}
