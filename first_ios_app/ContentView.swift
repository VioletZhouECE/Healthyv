//
//  ContentView.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI
import CoreData

//create a task, set a timer that fires at <time> everyday
//schedule a UNIntervalNotification (fires off every 5 min)

class DisplayedView : ObservableObject {
    @Published var showAddMedication = false
    @Published var showAddReminder = false
}

class TaskContainer: ObservableObject {
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    init(){}
}

struct TaskRow : View {
    @EnvironmentObject var displayed: DisplayedView
    @Environment(\.editMode) var editMode
    @ObservedObject var task: Task
    
    var body: some View {
        HStack {
            Button(action: {
                task.completed.toggle()
                if task.completed {
                    NotificationManager.rescheduleNotification(task: task, firesToday: false)
                } else {
                    NotificationManager.rescheduleNotification(task: task, firesToday: true)
                }
            }) {
                if task.completed {
                    Image(systemName: "checkmark.square")
                } else {
                    Image(systemName: "square")
                }
            }
            if editMode!.wrappedValue.isEditing {
                TextField(task.name, text: $task.name)
                    .onChange(of: task.name, perform: {
                        value in
                        task.hasChanged = true
                    })
          } else {
            if task.completed {
                Text(task.name)
                    .foregroundColor(.gray)
                    .strikethrough()
            } else {
                Text(task.name)
            }
          }
            Spacer()
            if editMode!.wrappedValue.isEditing {
                DatePicker("", selection: Binding<Date>(get: {task.time}, set: {task.time = $0; task.hasChanged = true}), displayedComponents: .hourAndMinute)
                    .labelsHidden()
            } else {
                Text(task.timeString)
            }
        }.onChange(of: editMode!.wrappedValue, perform: {
            value in
            if value.isEditing == false && task.hasChanged {
                if task.completed == false {
                    NotificationManager.rescheduleNotification(task: task, firesToday: true)
                } else {
                    NotificationManager.rescheduleNotification(task: task, firesToday: false)
                }
                task.hasChanged = false
            }
        })
    }
}

 struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @StateObject private var tasks = TaskContainer()
    @StateObject private var displayed = DisplayedView()
    
    var body: some View {
            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        Spacer()
                        EditButton()
                    }
                    Text("")
                    Section(header:
                            HStack{
                                HStack{
                                    Image(systemName: "note.text")
                                    Text("Medication")
                                }
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                .font(.title)
                                Spacer()
                                Button(action:{
                                    self.displayed.showAddMedication = true
                                }){
                                    Image(systemName: "plus")
                                }.popover(isPresented: $displayed.showAddMedication) {
                                    AddMedicationView()
                                }
                            })
                            {
                            List{
                                ForEach(self.tasks.tasks){
                                    task in
                                    if task.isMedication {
                                        TaskRow(task:task)
                                    }
                                }
                                .onDelete(perform: deleteMedication)
                            }
                        }
                    Section(header:
                        HStack{
                            HStack{
                                Image(systemName: "pencil.circle")
                                Text("Reminders")
                            }
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .font(.title)
                            Spacer()
                            Button(action:{
                                self.displayed.showAddReminder = true
                            }){
                                Image(systemName: "plus")
                            }.popover(isPresented: $displayed.showAddReminder) {
                                AddReminderView()
                            }
                        }){
                        List{
                            ForEach(self.tasks.tasks){
                                task in
                                if task.isMedication == false {
                                    TaskRow(task:task)
                                }
                            }
                            .onDelete(perform: deleteReminder)
                        }
                    }
                    Spacer()
                }
                .padding(.all)
                Spacer()
            }.environmentObject(tasks)
            .environmentObject(displayed)
    }

    func deleteMedication(at offsets: IndexSet){
        let idxArray = Array(offsets)
        idxArray.forEach {idx in
            NotificationManager.unregisterNotification(task: self.tasks.tasks[idx])
            moc.delete(tasks.tasks[idx])
        }
    }
    
    func deleteReminder(at offsets: IndexSet){
        let idxArray = Array(offsets)
        idxArray.forEach {idx in
            NotificationManager.unregisterNotification(task: self.tasks.tasks[idx])
            moc.delete(tasks.tasks[idx])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        NotificationManager.setNotifications()
    }
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

