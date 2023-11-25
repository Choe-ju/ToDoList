//
//  ContentView.swift
//  TodoList
//
//  Created by 최주원 on 11/7/23.
//

import SwiftUI

struct TodoList : Codable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var completed: Bool
}

// 데이터 저장소 구조체를 추가
class TodoListStore : ObservableObject {
    @Published var todoList: [TodoList] = []
    
    init(todoList: [TodoList]) {
        self.todoList = todoList
    }
}



struct ContentView: View {
    @StateObject var todoListStore = TodoListStore(todoList: loadJson("sample.json"))
    
    var body: some View {
        VStack {
            NavigationStack(){
                List{
                    ForEach(todoListStore.todoList.indices, id: \.self) { index in
                        ListCell(todoList: $todoListStore.todoList[index])
                    }
                    .onDelete(perform: { indexSet in deleteItems(offsets: indexSet) })
                    .onMove(perform: { indices, newOffset in moveItems(from: indices, to: newOffset) })
                }
                .navigationDestination(for: String.self) { _ in
                    AddNewList(todoListStore: self.todoListStore)
                }
                .navigationTitle("todoList")
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.topBarLeading) {
                        NavigationLink {
                            AddNewList(todoListStore: todoListStore)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    func deleteItems(offsets: IndexSet){
        todoListStore.todoList.remove(atOffsets: offsets)
    }
    
    func moveItems(from source: IndexSet, to destination: Int){
        todoListStore.todoList.move(fromOffsets: source, toOffset: destination)
    }
}
    
struct ListCell: View {
    @Binding var todoList: TodoList
    @State private var listExpanded = false
    @State private var showingAlert: Bool = false
    @State private var edit = true
    //  @State var completedData = todoList.completed
    
    var body: some View {
        DisclosureGroup(
            content: {
                VStack{
                    TextEditor(text: $todoList.description)
                        .padding(2)
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(height: 100)
                        .disabled( edit )
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                            .fill(edit ? Color.white : Color(white: 0.9, opacity: 0.9) ))
                    
                    HStack{
                        // 수정하기
                        Button(action: {
                            edit = !edit
                        }) {
                            HStack{
                                Image(systemName: "pencil")
                                Text(edit ? "Modify" : "Complete")
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                            .fill(edit ? Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00) : Color.gray ))
                        .buttonStyle(CustomButtonStyle())
                    }
                }
            }, label: {
                HStack{
                    Image(systemName: todoList.completed ? "checkmark.square.fill" : "square")
                        .onTapGesture { todoList.completed.toggle()  }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    TextField("Enter Title", text: $todoList.title)
                        .font(.headline)
                        .disabled( edit )
                        .background(RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                            .fill(edit ? Color.white : Color(white: 0.9, opacity: 0.9) ))
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
