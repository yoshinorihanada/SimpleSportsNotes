//  SportsNoteListView.swift
//  SimpleSportsNotes
//
//  Created by Yoshinori Hanada on 2024/10/31.
//

import SwiftUI

struct SportsListView: View {
    @StateObject private var noteStore = NoteStore()
    @State private var showingNewNote = false

    // Compute unique sports with their latest notes
    private var uniqueSports: [(sportType: String, latestNote: Note)] {
        let groupedNotes = Dictionary(grouping: noteStore.notes) { $0.sportType }
        return groupedNotes.compactMap { sportType, notes in
            guard let latestNote = notes.sorted(by: { $0.date > $1.date }).first else {
                return nil
            }
            return (sportType: sportType, latestNote: latestNote)
        }
        .sorted(by: { $0.latestNote.date > $1.latestNote.date })
    }

    var body: some View {
        NavigationView {
            VStack { // Explicit spacing to control gaps
                if uniqueSports.isEmpty {
                    VStack {
                        Text("Your sports memories, all in one place.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button(action: {
                            showingNewNote = true
                        }) {
                            Text("Create Note")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(uniqueSports, id: \.sportType) { sport in
                            NavigationLink(destination: NoteListView(sportType: sport.sportType).environmentObject(noteStore)) {
                                SportRowView(sport: sport)
                            }
                        }
                        .onDelete(perform: deleteSport)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My Sports")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewNote = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NewNoteView(sportType: nil, isPresented: $showingNewNote)
            }
        }
        .environmentObject(noteStore)
    }

    private func deleteSport(at offsets: IndexSet) {
        for index in offsets {
            let sportToDelete = uniqueSports[index].sportType
            noteStore.deleteNotes(forSport: sportToDelete)
        }
    }
}



// Create a separate view for the sport row
struct SportRowView: View {
    let sport: (sportType: String, latestNote: Note)
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName(for: sport.sportType))
                .foregroundColor(.blue)
                .font(.largeTitle)
                .frame(width: 50, height: 50)
                
            VStack(alignment: .leading) {
                // Sport Type with specific icon
                HStack() {
                    Text(sport.sportType)
                        .font(.headline)
                }
                
                // To Do Next
                if(sport.latestNote.toDoNext != ""){
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                        Text(sport.latestNote.toDoNext)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                
                // Last Note Created
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Last note created: ")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(daysAgoString(from: sport.latestNote.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.vertical, 4)
    }
    
    // Move helper functions here
    private func daysAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
        
        switch days {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return "\(days) days ago"
        }
    }
}

public func iconName(for sport: String) -> String {
    let sportLowercased = sport.lowercased()
    switch sportLowercased {
    case "soccer", "football":
        return "figure.soccer"
    case "basketball":
        return "figure.basketball"
    case "baseball":
        return "figure.baseball"
    case "tennis":
        return "figure.tennis"
    case "volleyball":
        return "figure.volleyball"
    case "running":
        return "figure.run"
    case "swimming":
        return "figure.pool.swim"
    case "cycling":
        return "figure.outdoor.cycle"
    case "boxing":
        return "figure.boxing"
    case "golf":
        return "figure.golf"
    case "hiking":
        return "figure.hiking"
    case "yoga":
        return "figure.mind.and.body"
    default:
        return "figure.strengthtraining.functional"
    }
}


// Preview
struct SportsListView_Previews: PreviewProvider {
    static var previews: some View {
        SportsListView()
    }
}
