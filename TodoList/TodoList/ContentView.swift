//
//  ContentView.swift
//  TodoList
//
//  Created by 최주원 on 11/7/23.
//

import SwiftUI

struct Todo : Codable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var completed: Bool
}

struct ContentView: View {
    @State private var todoList: [Todo] = JsonManager().loadJson("sample.json")
    
    var body: some View {
        VStack {
            NavigationStack(){ 
                List{
                    ForEach(todoList, id: \.id) {
                        ListCell(todoList: $0)
                    }
                    .onDelete(perform: { indexSet in
                        deleteItems(offsets: indexSet)
                    })
                    .onMove(perform: { indices, newOffset in
                        moveItems(from: indices, to: newOffset)
                    })
                }
                .navigationTitle("todoList")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink {
                            AddNewList(todoListStore: $todoList)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    func deleteItems(offsets: IndexSet){
        todoList.remove(atOffsets: offsets)
    }
    
    func moveItems(from source: IndexSet, to destination: Int){
        todoList.move(fromOffsets: source, toOffset: destination)
    }
}
    
struct ListCell: View {
    @State var todoList: Todo
    @State private var isModifyViewPresented = false
    
    var body: some View {
        DisclosureGroup(
            content: {
                VStack{
                    HStack{
                        Text(todoList.description)
                            .padding(5)
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack{
                        // 수정하기 버튼
                        Button(action: {
                            isModifyViewPresented.toggle()
                        }) {
                            HStack{
                                Image(systemName: "pencil")
                                Text("Modify")
                            }
                        }
                        .sheet(isPresented: $isModifyViewPresented) {
                            ModifyView(modifyTodoList: $todoList)
                        }
                        .background(RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                            .fill(Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00)))
                        .buttonStyle(CustomButtonStyle())
                        
                        // 완료 버튼 추가
                        Button(action: {
                            todoList.completed.toggle()
                        }, label: {
                            HStack{
                                Image(systemName: todoList.completed ? "arrow.uturn.backward" : "checkmark")
                                Text(todoList.completed ? "Cancel" : "Complete")
                            }
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                                .fill(todoList.completed ? Color.gray : Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00)
                        ))
                        .buttonStyle(CustomButtonStyle())
                        
                    }
                }
            }, label: {
                HStack{
                    Image(systemName: todoList.completed ? "checkmark.square.fill" : "square")
                        .onTapGesture {
                            todoList.completed.toggle()
                        }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Text(todoList.title)
                        .font(.headline)
                }
            }
        )
    }
}
    
public struct CustomButtonStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.bold))
            .padding(.vertical, 7)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
//            .background(
//                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
//                    .fill(Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00))
//            )
            .opacity(configuration.isPressed ? 0.4 : 1.0)
    }
}
    
#Preview {
    ContentView()
}
