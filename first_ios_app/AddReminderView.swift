//
//  AddReminderView.swift
//  first_ios_app
//
//  Created by violet on 2022-01-04.
//

import Foundation
import SwiftUI

struct AddReminderView : View {
    @Binding var showAddReminder : Bool
    @ObservedObject var tasks: TaskContainer
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
                                showAddReminder = false
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
        let newTask = Task(name: taskName, isMedication: false, completed: false, time: time)
        tasks.reminders.append(newTask)
        NotificationManager.registerMedicationNotification(task: newTask)
    }
}

