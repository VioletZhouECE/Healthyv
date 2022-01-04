//
//  ContentView.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

//create a task, set a timer that fires at <time> everyday
//schedule a UNIntervalNotification (fires off every 5 min)

class TaskContainer : ObservableObject {
    @Published var medications = [Task]()
    @Published var reminders = [Task]()
    
    init(medications: [Task], reminders: [Task]){
        self.medications = medications
        self.reminders = reminders
    }
}

class Task: Identifiable, ObservableObject {
    let id = UUID()
    let name : String
    let isMedication: Bool
    @Published var completed: Bool = false
    //format: HH:mm
    var time: Date?
    //reminder body
    var body: String {
        get {
            if isMedication {
                return name
            } else {
                return "Remember to take " + name
            }
        }
    }
    
    init(name: String, isMedication: Bool, completed: Bool, time: Date?=nil){
        self.name = name
        self.isMedication = isMedication
        self.completed = completed
        if let time = time {
            self.time = time
        }
    }
}

struct TaskRow : View {
    @ObservedObject var task: Task
    var time: String {
            get {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: task.time!)
            }
    }
    
    var body: some View {
        HStack {
            Button(action: {
                if task.completed {
                    task.completed = false
                    //TODO: add notifications back
                } else {
                    task.completed = true
                    NotificationManager.removeNotification(task:task)
                }
            }) {
                if task.completed {
                    Image(systemName: "checkmark.square")
                } else {
                    Image(systemName: "square")
                }
            }
            if task.completed {
                Text(task.name)
                    .foregroundColor(.gray)
                    .strikethrough()
            } else {
                Text(task.name)
            }
            Spacer()
            if task.time != nil {
                Text(time)
            }
        }
    }
}

 struct ContentView: View {
    
    @StateObject private var tasks = TaskContainer(medications: [], reminders: [])
    @State private var showAddMedication = false
    @State private var showAddReminder = false
    
    var body: some View {
            HStack{
                VStack(alignment: .leading) {
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
                                    self.showAddMedication = true
                                }){
                                    Image(systemName: "plus")
                                }.popover(isPresented: $showAddMedication) {
                                    AddMedicationView(showAddMedication: $showAddMedication, tasks: tasks)
                                }
                            })
                            {
                            List{
                                ForEach(self.tasks.medications){
                                    medication in TaskRow(task:medication)
                                }
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
                                self.showAddReminder = true
                            }){
                                Image(systemName: "plus")
                            }.popover(isPresented: $showAddReminder) {
                                AddReminderView(showAddReminder: $showAddReminder, tasks: tasks)
                            }
                        }){
                        List{
                            ForEach(self.tasks.reminders){
                                reminder in TaskRow(task:reminder)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.all)
                Spacer()
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
