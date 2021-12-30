//
//  ContentView.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

//Notifications mechanism that works for Violet:
//If user checked the checkbox for that day:
//1. (optional) cancel the current UNCalendarNotificationTrigger (for that day)
//2. remove the UNTimeIntervalNotificationTrigger (if exists)
//When the notification fires off
//register a UNTimeIntervalNotificationTrigger (id: userid-taskid)
//At 22:30 (bedtime)
//remove the UNTimeIntervalNotificationTrigger (if exists)

struct Task : Identifiable {
    let id = UUID()
    let name : String
    var completed: Bool = false
    //format: HH:mm
    var time: String?
}

struct TaskRow : View {
    @Binding var task: Task
    var body: some View {
        HStack {
            Button(action: {
                if task.completed {
                    task.completed = false
                    //to-do: add the notification back
                } else {
                    task.completed = true
                    removeNotif()
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

//let medications = [Task(name: "Vemlidy")]
//let doctorNotes = [Task(name:"Be nice to urself"), Task(name:"Sleep early"), Task(name:"Eat less")]

struct ContentView: View {
    @State private var medications = [Task(name: "Vemlidy", time: "17:45")]
    @State private var doctorNotes = [Task(name:"Be nice to urself"), Task(name:"Sleep early"), Task(name:"Eat less")]
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Section(header:
                        HStack{
                            Image(systemName: "note.text")
                            Text("Medication")
                        }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .font(.title)){
                    List{
                        ForEach(medications.indices){
                            i in TaskRow(task: $medications[i])}
                    }
                }
                Section(header: HStack{
                    Image(systemName: "pencil.circle")
                    Text("Doctor Notes")
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .font(.title)){
                    List{
                        ForEach(doctorNotes.indices){
                            i in TaskRow(task: $doctorNotes[i])}
                    }
                }
                Spacer()
            }
            .padding(.all)
            Spacer()
        }
    }
    
    //register once a medication entry is created
    //TODO: remove hard-coded values
    func registerMedicationNotif(){
        //schedule daily reminder
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 17
        dateComponents.minute = 45
        NotificationManager.registerCalendarNotif(title:"Medication Time", body:"Remember to take Vemlidy", dateComponents:dateComponents, identifier: "violet-vemlidy-calendar")
        //schedule repeated notifications which are sent in the event where the task is not completed,
        let timer = Timer(fireAt: Calendar.current.date(from: dateComponents)!, interval: 60*60*24, target: self, selector: #selector(self.checkTaskCompleted), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func checkTaskCompleted(){
        
    }
}

struct ContentView_Previews: PreviewProvider {
//    init(){
//        requestAuthorization()
//        registerTimeIntervalNotif()
//    }
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}
