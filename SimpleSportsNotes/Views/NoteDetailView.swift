//
//  NoteView.swift
//  SimpleSportsNotes
//
//  Created by Yoshinori Hanada on 2024/10/31.
//

import SwiftUI

struct NoteDetailView: View {
    @State private var editedNote: Note
    @State private var isEditing = false
    let note: Note
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var noteStore: NoteStore
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    init(note: Note) {
        self.note = note
        _editedNote = State(initialValue: note)
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(spacing: 20) {
                // Date Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "Date", systemImage: "calendar")
                    if isEditing {
                        DatePicker("", selection: $editedNote.date, displayedComponents: [.date])
                            .labelsHidden()
                    } else {
                        Text(editedNote.date, formatter: dateFormatter)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // Activities Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "Activities", systemImage: "figure.run")
                    if isEditing {
                        ScrollableTextEditor(text: $editedNote.activities)
                    } else {
                        Text(editedNote.activities)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // Good Points Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "Good Points", systemImage: "hand.thumbsup")
                    if isEditing {
                        ScrollableTextEditor(text: $editedNote.goodPoints)
                    } else {
                        Text(editedNote.goodPoints)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // Bad Points Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "Bad Points", systemImage: "hand.thumbsdown")
                    if isEditing {
                        ScrollableTextEditor(text: $editedNote.badPoints)
                    } else {
                        Text(editedNote.badPoints)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // To Do Next Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "To Do Next", systemImage: "arrow.right.circle")
                    if isEditing {
                        ScrollableTextEditor(text: $editedNote.toDoNext)
                    } else {
                        Text(editedNote.toDoNext)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // Others Section
                VStack(alignment: .leading, spacing: 8) {
                    SectionHeaderView(title: "Others", systemImage: "text.bubble")
                    if isEditing {
                        ScrollableTextEditor(text: $editedNote.others)
                    } else {
                        Text(editedNote.others)
                            .font(.body)
                    }
                }
                .sectionStyle()
                
                // Add some bottom padding to ensure the last section isn't cut off
                Spacer()
                    .frame(height: 20)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        saveChanges()
                    }
                    isEditing.toggle()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func saveChanges() {
        noteStore.updateNote(editedNote)
    }
}

// Custom ScrollableTextEditor component
struct ScrollableTextEditor: View {
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .frame(minHeight: 100, maxHeight: .infinity)
            .font(.body)
            .padding(4)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .scrollContentBackground(.hidden) // iOS 16+ only
    }
}

// Helper Views and Modifiers (unchanged)
struct SectionHeaderView: View {
    let title: String
    let systemImage: String
    
    // Get the appropriate color based on the section type
    private var iconColor: Color {
        switch title {
        case "Activities":
            return .orange
        case "Good Points":
            return .green
        case "Bad Points":
            return .red
        case "To Do Next", "Date":
            return .blue  // To match secondary color in list view
        default:
            return Color(.systemGray)        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundColor(iconColor)
                .font(.system(size: 20))
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

extension View {
    func sectionStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Preview
struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        let store = NoteStore()
        
        NavigationView {
            NoteDetailView(note: Note(
                sportType: "Soccer",
                date: Date(),
                activities: "Practice dribbling and shooting drills for 2 hours",
                goodPoints: "Improved ball control and shot accuracy",
                badPoints: "Still need to work on left foot control",
                toDoNext: "Focus on left foot dribbling exercises",
                others: "Additional notes about today's practice"
            ))
        }
    }
}
