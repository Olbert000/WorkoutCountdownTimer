//
//  ContentView.swift
//  WorkoutCountdownTimer
//
//  Created by Oliver Kerr on 10/8/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timeStamp, ascending: true)],
//        animation: .default)
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CountDownEntity.startTime, ascending: true)],
        animation: .default)
    
    private var countDowns: FetchedResults<CountDownEntity>
//    private var items: FetchedResults<Item>
    
    var body: some View {
        
        let _ = createDataFirst()
        
        
        
        NavigationView {
//            List {
//                ForEach(countDowns) { countDown in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
            TimesListViewPassingInList(countDownList: Array(countDowns))
            Text("Hi")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
    func createDataFirst () {
        let result = PersistenceController.shared
        let context = result.container.viewContext
        for _ in 0..<10 {
            let newCountDownEntity = CountDownEntity(context: context)
            newCountDownEntity.startTime = Date()
            newCountDownEntity.overTime = 20
            newCountDownEntity.countingDownFrom = 30
            print("Creating Entity!")
        }
        do {
            try context.save()
            print("Saving Entity!")

        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
