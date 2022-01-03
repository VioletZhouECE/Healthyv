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
    @Published var doctorNotes = [Task]()
    
    init(medications: [Task], doctorNotes: [Task]){
        self.medications = medications
        self.doctorNotes = doctorNotes
    }
}

class Task: Identifiable, ObservableObject {
    let id = UUID()
    let name : String
    @Published var completed: Bool = false
    //format: HH:mm
    var time: String?
    
    init(name: String, completed: Bool, time: String?=nil){
        self.name = name
        self.completed = completed
        if let time = time {
            self.time = time
        }
    }
}

struct TaskRow : View {
    @ObservedObject var task: Task
    
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
                Text(task.time!)
            }
        }
    }
}

struct AddTaskView : View {
    @Binding var showAddAMedication : Bool
    @State private var taskName = ""
    @State private var time = Date()
    @State private var clicked = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Group{
                    HStack{
                        Spacer()
                        Text("Add a Medication")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .font(.title)
                        Spacer()
                    }
                    Text("")
                    VStack(alignment: .leading) {
                        Text("Medication Name")
                            .font(.callout)
                            .bold()
                        TextField("Medication A", text: $taskName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Text("")
                    Text("")
                    VStack(alignment: .leading) {
                        Text("Reminder Time")
                            .font(.callout)
                            .bold()
                        DatePicker("Repeat everyday at", selection: $time, displayedComponents: .hourAndMinute)
                    }
                    Text("")
                    Text("")
                    HStack{
                        Spacer()
                        Button(action: {
                            if self.clicked == false {
                                self.clicked = true
                                //sleep for 1s
                                
                                showAddAMedication = false
                                print(showAddAMedication)
                            }
                        }){
                            if self.clicked == false {
                                Image(systemName: "checkmark.rectangle")
                                .resizable()
                                .frame(width: 60, height: 40)
                            } else {
                                Image(systemName: "checkmark.rectangle.fill")
                                .resizable()
                                .frame(width: 60, height: 40)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.all)
                Spacer()
            }
        }
    }
}

 struct ContentView: View {
    
    @StateObject private var tasks = TaskContainer(medications: [Task(name: "Vemlidy", completed: false, time: "17:45")], doctorNotes: [Task(name:"Be nice to urself", completed: false), Task(name:"Sleep early", completed: false), Task(name:"Eat less", completed: false)])
    @State private var showAddAMedication = false

    init(){
        //TODO: remove hard-coded initial notifications
        NotificationManager.removeAllPendingNotification()
        //ignore the warning
        NotificationManager.registerMedicationNotification(task:tasks.medications[0])
    }
    
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
                                    self.showAddAMedication = true
                                }){
                                    Image(systemName: "plus")
                                }.popover(isPresented: $showAddAMedication) {
                                    AddTaskView(showAddAMedication: $showAddAMedication)
                                }
                            })
                            {
                            List{
                                ForEach(tasks.medications.indices){
                                    i in TaskRow(task: self.tasks.medications[i])}
                            }
                        }
                    Section(header: HStack{
                        Image(systemName: "pencil.circle")
                        Text("Doctor Notes")
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.title)){
                        List{
                            ForEach(tasks.doctorNotes.indices){
                                i in TaskRow(task: tasks.doctorNotes[i])}
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
