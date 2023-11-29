//
//  TodoInput.swift
//  TodoList
//
//  Created by 최주원 on 11/20/23.
//

import SwiftUI

struct TodoInput: View {
    @Binding var titleInput: String
    @Binding var descriptionInput: String
    
    var body: some View {
        VStack {
            HStack{
                Text("title")
                    .font(.headline)
                Spacer()
            }
            TextField("Enter title here", text: $titleInput)
                .font(.body)
        }
        VStack {
            HStack{
                Text("description")
                    .font(.headline)
                Spacer()
            }
            ZStack{
                
                TextEditor(text: $descriptionInput)
                    .font(.body)
                    .frame(minHeight: 300, maxHeight: .infinity)
                if descriptionInput == "" {
                    Text("Enter todo description here")
                        .foregroundStyle(.gray)
                        .font(.body)
                }
            }
        }
    }
}

//#Preview {
//    TodoInput()
//}
