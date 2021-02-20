//
//  ChecklistView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/11/21.
//

import SwiftUI

struct ChecklistView: View {

    init() {
         UINavigationBarAppearance().configureWithTransparentBackground()
    }
    
    @State var listItems: [ChecklistItem] = checklist
    
    @State var selectedListType: String?
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ChecklistHeader()
                ChecklistScrollView(listItems: $listItems)
            }
            .edgesIgnoringSafeArea([.top])
            .toolbar {
                ToolbarItem {
                    Menu("List Type") {
                        //TODO: map/reduce unique list of categories
                        ForEach(Array(Set(listItems.map { $0.category })), id: \.self) { list in
                            Button(list) {
                                selectedListType = list
                                //TODO:
                                //listItems = Checklists.checklist(named: selectedListType!)
                            }
                        }
                    }.foregroundColor(.white)
                }
            }
        }
        //                .navigationBarHidden(true)
        .navigationBarTitle("RV Checklist")
        .foregroundColor(.black)
    }
    
    func clearChecklist() {
        for index in 0..<listItems.count {
            listItems[index].isDone = false
        }
    }
}

struct ChecklistHeader: View {
    var body: some View {
        ZStack(alignment: .top, content: {
            Image("truck-rv").resizable().aspectRatio(contentMode: .fit)
            Text("RV Checklist").foregroundColor(.white).font(.title2).fontWeight(.semibold).padding(.top, 30)
        })
    }
}

struct ChecklistScrollView: View {
    
    @Binding var listItems: [ChecklistItem]
    
    var body: some View {
        List(listItems) { listItem in
            NavigationLink(destination: DetailView(listItem: listItem)) {
                HStack {
                    Text(listItem.name).strikethrough(listItem.isDone)
                    Spacer()
                    Image(systemName: listItem.isDone ? "checkmark.square" : "square")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            listItems.toggleDone(to: listItem)
                        }
                }
            }
        }.listStyle(PlainListStyle())
    }
}

private extension Array where Element == ChecklistItem {
    mutating func toggleDone(to item: ChecklistItem) {
        guard let index = self.firstIndex( where: { $0 == item }) else { return }
        self[index].isDone.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChecklistView()
            ChecklistHeader()
                .previewLayout(.fixed(width: 300, height: 210))
            //ChecklistScrollView(listItems: checklist)
        }
    }
}

