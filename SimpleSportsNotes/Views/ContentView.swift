//
//  ContentView.swift
//  SimpleSportsNotes
//
//  Created by Yoshinori Hanada on 2024/10/31.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var noteStore = NoteStore()

    var body: some View {
        NavigationView {
            SportsListView()
                .environmentObject(noteStore)
        }
    }
}

@main
struct SportsNotesApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
