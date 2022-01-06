//
//  ContentView.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

//create a task, set a timer that fires at <time> everyday
//schedule a UNIntervalNotification (fires off every 5 min)

class DisplayedView : ObservableObject {
    @Published var showAddMedication = false
    @Published var showAddReminder = false
}

class TaskContainer : ObservableObject {
    @Published var medications = [Task]()
    @Published var reminders = [Task]()
    
    init(medications: [Task], reminders: [Task]){
        self.medications = medications
        self.reminders = reminders
    }
}

class Task: Identifiable, ObservableObject, Equatable {
    let id = UUID()
    @Published var name : String {
        didSet {
            print("set name")
            NotificationManager.rescheduleNotification(task: self, firesToday: true)
        }
    }
    let isMedication: Bool
    @Published var completed: Bool = false {
        didSet {
            print("set completed")
            if completed == false {
                NotificationManager.rescheduleNotification(task: self, firesToday: true)
            } else {
                NotificationManager.rescheduleNotification(task: self, firesToday: false)
            }
        }
    }
    //format: HH:mm
    var time: Date? {
        didSet {
            print("set time")
            NotificationManager.rescheduleNotification(task: self, firesToday: true)
        }
    }
    //time string
    var timeString: String {
            get {
                if time == nil {
                    return ""
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: time!)
            }
    }
    //timer that schedules notifications
    var timer: Timer?
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
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.isMedication == rhs.isMedication && lhs.time == rhs.time
    }
}

struct TaskRow : View {
    @EnvironmentObject var displayed: DisplayedView
    @Environment(\.editMode) var editMode
    @ObservedObject var task: Task
    
    var body: some View {
        HStack {
            Button(action: {
                task.completed.toggle()
            }) {
                if task.completed {
                    Image(systemName: "checkmark.square")
                } else {
                    Image(systemName: "square")
                }
            }
            if editMode!.wrappedValue.isEditing {
                TextField(task.name, text: $task.name)
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
            if task.time != nil {
                if editMode!.wrappedValue.isEditing {
                    DatePicker("", selection: Binding<Date>(get: {task.time ?? Date()}, set: {task.time = $0}), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } else {
                    Text(task.timeString)
                }
            }
        }
    }
}

 struct ContentView: View {
    
    @StateObject private var tasks = TaskContainer(medications: [], reminders: [])
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
                                ForEach(self.tasks.medications){
                                    medication in TaskRow(task:medication)
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
                            ForEach(self.tasks.reminders){
                                reminder in TaskRow(task:reminder)
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
        //remove notifications
        let idxArray = Array(offsets)
        idxArray.forEach {idx in
            NotificationManager.unregisterNotification(task: self.tasks.medications[idx])
        }
        self.tasks.medications.remove(atOffsets: offsets)
    }
    
    func deleteReminder(at offsets: IndexSet){
        //remove notifications
        let idxArray = Array(offsets)
        idxArray.forEach {idx in
            NotificationManager.unregisterNotification(task: self.tasks.reminders[idx])
        }
        self.tasks.reminders.remove(atOffsets: offsets)
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
