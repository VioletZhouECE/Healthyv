//
//  AddReminderView.swift
//  first_ios_app
//
//  Created by violet on 2022-01-04.
//

import Foundation
import SwiftUI

struct AddReminderView : View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var displayed : DisplayedView
    @State private var taskName = ""
    @State private var time = Date()
    @State private var clicked = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Group{
                    HStack{
                        Spacer()
                        Text("Add a Reminder")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .font(.title)
                        Spacer()
                    }
                    Text("")
                    VStack(alignment: .leading) {
                        Text("Task Name")
                            .font(.callout)
                            .bold()
                        TextField("Task A", text: $taskName)
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
                                addReminder()
                                self.clicked = true
                                displayed.showAddReminder = false
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
    
    func addReminder(){
        let newTask = Task(context:moc)
        newTask.id = UUID()
        newTask.name = taskName
        newTask.isMedication = false
        newTask.completed = false
        newTask.time = time
        try? moc.save()
        NotificationManager.registerNotification(task: newTask, firesToday: true)
    }
}

