//
//  ActivitiesView.swift
//  EventApp
//
//  Created by Daniel Xu on 12/29/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct ActivityListView: View {
    @State private var activities: [Activity] = []
    @State private var showingAddActivity = false
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            List(activities) { activity in
                VStack(alignment: .leading) {
                    Text(activity.title).font(.headline)
                    Text(activity.location).font(.subheadline)
                    Text(activity.date).font(.subheadline).foregroundColor(.secondary)
                    Text(activity.description).font(.body).padding(.top, 4)
                }
            }
            .navigationTitle("Activities")
            .navigationBarItems(trailing: Button(action: {
                showingAddActivity = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activities: $activities)
            }
            .onAppear {
                fetchActivities()
            }
        }
    }
    
    func fetchActivities() {
        db.collection("activities").addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                self.activities = documents.compactMap { doc in
                    try? doc.data(as: Activity.self)
                }
            } else if let error = error {
                print("Error fectching activities: \(error)")
            }
        }
    }
}

struct AddActivityView: View {
    @Binding var activities: [Activity]
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var date: String = ""
    @State private var description: String = ""
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Location")) {
                    TextField("Location", text: $location)
                }
                Section(header: Text("Date")) {
                    TextField("Date", text: $date)
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
            }
            .navigationBarTitle("Add Activity", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                let newActivity = Activity(title: title, location: location, date: date, description: description)
                saveActivity(activity: newActivity)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func saveActivity(activity: Activity) {
        do {
            _ = try db.collection("activities").addDocument(from: activity)
        } catch {
            print("Error saving activity: \(error)")
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
