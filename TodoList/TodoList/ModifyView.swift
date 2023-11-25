//
//  ModifyView.swift
//  TodoList
//
//  Created by 최주원 on 11/19/23.
//

import SwiftUI

struct ModifyView: View {
    
    @Binding var modifyTodoList : Todo
    @Environment(\.dismiss) private var dismiss
    
    @State private var titleEmptyAlert: Bool = false
    @State private var descriptionEmptyAlert: Bool = false
    
    var body: some View {
        
        Form{
            Section {
                TodoInput(titleInput: $modifyTodoList.title, descriptionInput: $modifyTodoList.description)
            }
        }
        Button {
            if modifyTodoList.title == "" {
                titleEmptyAlert = true
            }else if modifyTodoList.description == "" {
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
        .background(Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00))
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
                modifyTodoList.description = "None"
                dismiss()
            }
            Button("Cancel", role: .none) {}
        }) {
            Text("Would you like to description and skip it?")
        }
    }
}

//#Preview {
//    ModifyView()
//}
