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
    @StateObject private var timerViewModel = TimerViewModel()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.startTime_, ascending: true)],
        predicate: NSPredicate(format: "saved = %i", true),
        animation: .default)
    
    private var workouts: FetchedResults<WorkoutEntity>
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: CountdownView()) {
                Text("StartCounting")
            }
            List {
                ForEach(workouts) { workout in
                    NavigationLink {
                        TimesListView(filter: workout.id)
                    } label: {
                        Text(workout.startTime, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            Text("Select an item")
        }.environmentObject(timerViewModel)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
