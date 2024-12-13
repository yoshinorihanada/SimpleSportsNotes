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
        VStack {
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

func iconName(for sport: String) -> String {
    let sportLowercased = sport.lowercased()
    switch sportLowercased {
    case "soccer", "football":
        return "soccerball"
    case "futsal":
        return "figure.indoor.soccer"
    case "seven-a-side football", "7on7 football":
        return "figure.outdoor.soccer"
    case "american football":
        return "american.football"
    case "basketball":
        return "basketball"
    case "baseball":
        return "baseball"
    case "tennis":
        return "tennis.racket"
    case "volleyball":
        return "volleyball"
    case "running", "marathon", "trail running":
        return "figure.run"
    case "swimming", "synchronized swimming", "snorkeling", "diving":
        return "figure.pool.swim"
    case "cycling", "biking", "mountain biking":
        return "bicycle"
    case "boxing":
        return "figure.boxing"
    case "golf":
        return "figure.golf"
    case "hiking":
        return "figure.hiking"
    case "yoga":
        return "figure.mind.and.body"
    case "cricket":
        return "cricket.ball"
    case "rugby":
        return "rugbyball"
    case "skiing", "waterskiing", "jetskiing":
        return "skis"
    case "snowboarding":
        return "snowboard"
    case "surfing":
        return "surfboard"
    case "skateboarding":
        return "skateboard"
    case "table tennis":
        return "figure.table.tennis"
    case "badminton":
        return "figure.badminton"
    case "fencing":
        return "figure.fencing"
    case "archery":
        return "figure.archery"
    case "kickboxing", "taekwondo","karate":
        return "figure.kickboxing" // Use boxing glove icon for kickboxing
    case "mma", "mixed martial arts":
        return "figure.martial.arts" // Use a generic martial arts icon
    case "jiu-jitsu", "brazilian jiu-jitsu":
        return "figure.martial.arts"
    case "wrestling", "judo":
        return "figure.wrestling"
    case "weightlifting":
        return "dumbbell"
    case "rowing","canoeing":
        return "figure.outdoor.rowing"
    case "gymnastics":
        return "figure.gymnastics"
    case "climbing", "bouldering":
        return "figure.climbing"
    case "water polo":
        return "figure.waterpolo"
    case "field hockey":
        return "figure.field.hockey" //fix
    case "ice hockey":
        return "figure.ice.hockey"
    case "figure skating", "ice skating", "speed skating":
        return "figure.ice.skating"
    case "curling":
        return "figure.curling"
    case "cross-country skiing":
        return "figure.skiing.crosscountry"
    case "alpine skiing", "freestyle skiing":
        return "figure.skiing.downhill"
    case "bmx","motocross":
        return "helmet"
    case "kart racing","rallyracing","car racing":
        return "car.side"
    case "boating", "yachting", "sailing":
        return "sailboat"
    case "windsurfing", "kitesurfing":
        return "figure.surfing"
    case "fishing":
        return "figure.fishing"
    case "dance", "hip hop", "folk dance", "tap dance":
        return "music.note"
    case "ballet", "hula dance", "breakdance", "salsa":
        return "figure.dance"
    case "body weight training":
        return "figure.strengthtraining.traditional"
    case "calisthenics":
        return "figure.strengthtraining.functional"
    case "jumprope", "jump rope":
        return "figure.jumprope"
    default:
        return "figure.run" // Default icon for sports
    }
}


// Preview
struct SportsListView_Previews: PreviewProvider {
    static var previews: some View {
        SportsListView()
    }
}
