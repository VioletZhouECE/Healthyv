//
//  ContentView.swift
//  first_ios_app
//
//  Created by violet on 2021-12-26.
//

import SwiftUI

struct Task : Identifiable {
    let id = UUID()
    let name : String
    var completed: Bool = false
}

struct TaskRow : View {
    @Binding var task: Task
    var body: some View {
        HStack {
            Button(action: {
                if task.completed {
                    task.completed = false
                } else {
                    task.completed = true
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
        }
    }
}

//let medications = [Task(name: "Vemlidy")]
//let doctorNotes = [Task(name:"Be nice to urself"), Task(name:"Sleep early"), Task(name:"Eat less")]

struct ContentView: View {
    @State private var medications = [Task(name: "Vemlidy")]
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
