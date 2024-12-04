//
//  NewNoteView.swift
//  SimpleSportsNotes
//
//  Created by Yoshinori Hanada on 2024/10/31.
//

import SwiftUI

struct NewNoteView: View {
    let sportType: String?  // Optional: nil if coming from SportsListView
    @Binding var isPresented: Bool
    var onNoteCreated: (() -> Void)?
    
    @State private var selectedSportType: String
    @State private var date = Date()
    @State private var activities = ""
    @State private var goodPoints = ""
    @State private var badPoints = ""
    @State private var toDoNext = ""
    @State private var others = ""
    
    // States for section expansion
    @State private var isActivitiesExpanded = false
    @State private var isGoodPointsExpanded = false
    @State private var isBadPointsExpanded = false
    @State private var isToDoNextExpanded = false
    @State private var isOthersExpanded = false
    
    // Sample sports list - you can replace this with your actual sports list
    private let availableSports = ["Soccer", "Basketball", "Tennis", "Swimming", "Running"]
    
    @EnvironmentObject var noteStore: NoteStore
    
    init(sportType: String? = nil, isPresented: Binding<Bool>) {
        self.sportType = sportType
        self._isPresented = isPresented
        self._selectedSportType = State(initialValue: sportType ?? "")
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Sport Type Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                SectionHeaderView(title: "Sport Type", systemImage: "figure.run.circle.fill")
                                Text("*").foregroundColor(.red)
                            }
                            
                            if let fixedSportType = sportType {
                                // Coming from NoteListView - show uneditable sport type
                                Text(fixedSportType)
                                    .font(.body)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                
                            } else {
                                // Coming from SportsListView
                                TextField("Enter sport type", text: $selectedSportType)
                                    .font(.body)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemBackground))  // White background
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(.systemGray4), lineWidth: 1)  // Gray border
                                    )
                            }
                            
                        }
                        .sectionStyle()
                        
                        // Date Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                SectionHeaderView(title: "Date", systemImage: "calendar")
                                Text("*").foregroundColor(.red)
                            }
                            DatePicker("", selection: $date, displayedComponents: [.date])
                                .labelsHidden()
                        }
                        .sectionStyle()
                        
                        // Activities Section
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: { isActivitiesExpanded.toggle() }) {
                                HStack {
                                    SectionHeaderView(title: "Activities", systemImage: "figure.run")
                                    Text("*").foregroundColor(.red)
                                    Spacer()
                                    Image(systemName: isActivitiesExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            if isActivitiesExpanded {
                                CompactTextEditor(text: $activities, placeholder: "What did you do today?")
                            }
                        }
                        .sectionStyle()
                        
                        // Good Points Section
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: { isGoodPointsExpanded.toggle() }) {
                                HStack {
                                    SectionHeaderView(title: "Good Points", systemImage: "hand.thumbsup")
                                    Spacer()
                                    Image(systemName: isGoodPointsExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            if isGoodPointsExpanded {
                                CompactTextEditor(text: $goodPoints, placeholder: "What went well?")
                            }
                        }
                        .sectionStyle()
                        
                        // Bad Points Section
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: { isBadPointsExpanded.toggle() }) {
                                HStack {
                                    SectionHeaderView(title: "Bad Points", systemImage: "hand.thumbsdown")
                                    Spacer()
                                    Image(systemName: isBadPointsExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            if isBadPointsExpanded {
                                CompactTextEditor(text: $badPoints, placeholder: "What needs improvement?")
                            }
                        }
                        .sectionStyle()
                        
                        // To Do Next Section
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: { isToDoNextExpanded.toggle() }) {
                                HStack {
                                    SectionHeaderView(title: "To Do Next", systemImage: "arrow.right.circle")
                                    Spacer()
                                    Image(systemName: isToDoNextExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            if isToDoNextExpanded {
                                CompactTextEditor(text: $toDoNext, placeholder: "What's your next goal?")
                            }
                        }
                        .sectionStyle()
                        
                        // Others Section
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: { isOthersExpanded.toggle() }) {
                                HStack {
                                    SectionHeaderView(title: "Others", systemImage: "text.bubble")
                                    Spacer()
                                    Image(systemName: isOthersExpanded ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.blue)
                                }
                            }
                            if isOthersExpanded {
                                CompactTextEditor(text: $others, placeholder: "Any other notes?")
                            }
                        }
                        .sectionStyle()
                        
                        // Create Button
                        Button(action: createNote) {
                            Text("Create Note")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New Note")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                }
            )
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var isFormValid: Bool {
        let sportTypeValid = sportType != nil || !selectedSportType.isEmpty
        return sportTypeValid && !activities.isEmpty
    }
    
    private func createNote() {
        let newNote = Note(
            sportType: sportType ?? selectedSportType,
            date: date,
            activities: activities,
            goodPoints: goodPoints,
            badPoints: badPoints,
            toDoNext: toDoNext,
            others: others
        )
        
        noteStore.addNote(newNote)
        onNoteCreated?()
        isPresented = false
    }
}

// Compact TextEditor with placeholder
struct CompactTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextEditor(text: $text)
            .frame(height: 80)
            .font(.body)
            .scrollContentBackground(.hidden) // Hide default background
            .padding(.horizontal, 8)  // Reduced horizontal padding
            .padding(.vertical, 4)    // Reduced vertical padding
            .background(Color(.systemBackground))  // White background
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)  // Gray border
            )
            .overlay(
                Group {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color(.placeholderText))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)  // Adjusted to match text position
                    }
                },
                alignment: .topLeading
            )
    }
}


// Preview
struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(sportType: "Soccer", isPresented: .constant(true))
    }
}
