//
//  ChecklistScrollView.swift
//  RvChecklist
//
//  Created by Ron Lisle on 2/22/21.
//

import SwiftUI

struct ChecklistScrollView: View {

    @EnvironmentObject var modelData: ModelData
    @State var selectedTrip: String
 
    var showCompleted: Bool

    func category(_ category: String) -> [ChecklistItem] {
        return modelData.checklist.filter { $0.category == category }
    }
    
    func done(_ list: [ChecklistItem]) -> [ChecklistItem] {
        return list.filter { $0.isDone == true }
    }
    
    func todo(_ list: [ChecklistItem]) -> [ChecklistItem] {
        return list.filter { $0.isDone == false }
    }

    var body: some View {
        List {
            TripSection(selectedTrip: selectedTrip)
            ListSection(section: "Pre-Trip", showCompleted: showCompleted)
            ListSection(section: "Departure", showCompleted: showCompleted)
            ListSection(section: "Arrival", showCompleted: showCompleted)
        }
    }
}

struct ChecklistScrollView_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        ChecklistScrollView(selectedTrip: "Inks Lake", showCompleted: false)
            .environmentObject(modelData)
    }
}

struct ListSection: View {
    
    @EnvironmentObject var modelData: ModelData
    
    var section: String
    var showCompleted: Bool

    var body: some View {
        let items = category(section)
        let filteredItems = showCompleted ? items : todo(items)

        Section(header: Text("\(section) (\(done(items).count) of \(items.count) items done)")) {
            ForEach(filteredItems) { listItem in
                NavigationLink(destination: DetailView(listItem: listItem)) {
                    ChecklistRow(listItem: listItem)
                }
            }
            .onDelete(perform: { indexSet in
                print("Delete \(indexSet)!")
                //TODO: delete item?
            })
        }
    }
    
    private func category(_ category: String) -> [ChecklistItem] {
        return modelData.checklist.filter { $0.category == category }
    }
    
    private func done(_ list: [ChecklistItem]) -> [ChecklistItem] {
        return list.filter { $0.isDone == true }
    }
    
    private func todo(_ list: [ChecklistItem]) -> [ChecklistItem] {
        return list.filter { $0.isDone == false }
    }

}

struct TripSection: View {
    
    @EnvironmentObject var modelData: ModelData
    @State var selectedTrip: String
    
    var body: some View {
        
        Section(header: Text("Trip")) {
            NavigationLink(destination: TripList(selectedTrip: selectedTrip)) {
                Text(selectedTrip)
            }
        }
    }
    
//    private func category(_ category: String) -> [ChecklistItem] {
//        return modelData.checklist.filter { $0.category == category }
//    }
//
//    private func done(_ list: [ChecklistItem]) -> [ChecklistItem] {
//        return list.filter { $0.isDone == true }
//    }
//
//    private func todo(_ list: [ChecklistItem]) -> [ChecklistItem] {
//        return list.filter { $0.isDone == false }
//    }

}
