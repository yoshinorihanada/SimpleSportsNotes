import Foundation

class NoteStore: ObservableObject {
    @Published private(set) var notes: [Note] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                  in: .userDomainMask,
                                  appropriateFor: nil,
                                  create: false)
            .appendingPathComponent("notes.data")
    }
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func deleteNotes(forSport sportType: String) {
        notes.removeAll { $0.sportType == sportType }
        saveNotes()
    }
    
    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        } catch {
            print("Saving notes failed with error: \(error.localizedDescription)")
        }
    }
    
    private func loadNotes() {
        do {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                notes = []
                return
            }
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
            print("Loading notes failed with error: \(error.localizedDescription)")
        }
    }
}
