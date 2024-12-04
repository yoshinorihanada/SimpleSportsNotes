import SwiftUI

struct NoteListView: View {
    @EnvironmentObject var noteStore: NoteStore
    @State private var showingNewNote = false
    let sportType: String

    var filteredNotes: [Note] {
        noteStore.notes.filter { $0.sportType == sportType }
    }

    var body: some View {
        List {
            ForEach(filteredNotes.sorted(by: { $0.date > $1.date })) { note in
                NavigationLink(destination: NoteDetailView(note: note).environmentObject(noteStore)) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.headline)
                            Text(note.date, formatter: dateFormatter)
                                .font(.headline)
                        }
                        if note.activities != "" {
                            HStack(spacing: 4) {
                                Image(systemName: "figure.run")
                                    .foregroundColor(.orange)
                                    .font(.headline)
                                Text(note.activities)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        if note.toDoNext != "" {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                Text(note.toDoNext)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .onDelete(perform: deleteNote)
        }
        .navigationTitle(sportType)
        .navigationBarTitleDisplayMode(.inline) // Consistent inline navigation title
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: iconName(for: sportType))
                        .foregroundColor(.blue)
                        .font(.title2)
                    Text(sportType)
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingNewNote = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewNote) {
            NewNoteView(sportType: sportType, isPresented: $showingNewNote)
        }
    }

    private func deleteNote(at offsets: IndexSet) {
        let notesToDelete = offsets.map { filteredNotes[$0] }
        notesToDelete.forEach { noteStore.deleteNote($0) }
    }
}


// Formatter for displaying dates
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// Preview with sample data
struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        let store = NoteStore()
        return NoteListView(sportType: "Soccer")
            .environmentObject(store)
    }
}
