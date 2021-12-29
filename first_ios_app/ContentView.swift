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
}

struct TaskRow : View {
    let task: Task
    var body: some View {
        HStack {
            Image(systemName: "square")
            Text(task.name)
        }
    }
}

let medications = [Task(name: "Vemlidy")]
let doctorNotes = ["Be nice to urself", "Sleep early", "Eat less"]

struct ContentView: View {
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
                        ForEach(medications, content: {
                                    med in TaskRow(task: med)})
                    }
                }
                Section(header: HStack{
                    Image(systemName: "pencil.circle")
                    Text("Doctor Notes")
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .font(.title)){
                    List{
                        ForEach(doctorNotes, id: \.self, content: {
                                    name in Text(name)})
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
