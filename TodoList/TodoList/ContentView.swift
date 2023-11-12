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

var todoListData: [TodoList] = loadJson("sample.json")

// 데이터 저장소 구조체를 추가
class TodoListStore : ObservableObject {
    @Published var todoList: [TodoList]
    
    init(todoList: [TodoList] = []) {
        self.todoList = todoList
    }
}



struct ContentView: View {
    @StateObject var todoListStore = TodoListStore(todoList: todoListData)
    @State private var stackPath = NavigationPath()
    
    var body: some View {
        VStack {
            NavigationStack(){
                List{
                    ForEach (0..<todoListStore.todoList.count, id: \.self){ i in
                        ListCell(todoList: $todoListStore.todoList[i])
                    }
                    .onDelete(perform: { indexSet in
                        deleteItems(offsets: indexSet)
                    })
                    .onMove(perform: { indices, newOffset in
                        moveItems(from: indices, to: newOffset)
                    })
                }
                .navigationDestination(for: String.self) { _ in
                    AddNewList(todoListStore: self.todoListStore, path: $stackPath)
                }
                
                .navigationTitle("todoList")
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        NavigationLink(value: "Add to-do") {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
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
                            Text(edit ? "Modify" : "Complete")
                        }
                        .background(RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                            .fill(edit ? Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00) : Color.gray ))
                        .buttonStyle(CustomButtonStyle())
                        // 삭제하기
                        Button(action: {
                            showingAlert = true
                        }) {
                            Text("Deleat")
                        }.alert(Text("삭제하기"),
                                isPresented: $showingAlert,
                                actions: {
                            Button("Deleat") {
                                // 삭제 기능 추가
                            }
                                .foregroundColor(Color.red)
                            Button("Cancel", role: .cancel) { }
                        }, message: {
                            Text("삭제하시겠습니까?")
                        }
                        )
                        .buttonStyle(CustomButtonStyle())
                        .background(RoundedRectangle(cornerRadius: 14.0, style: .continuous).fill(Color(hue: 0.61, saturation: 0.68, brightness: 1.00, opacity: 1.00)))
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
