//
//  note.swift
//  SimpleSportsNotes
//
//  Created by Yoshinori Hanada on 2024/10/31.
//

import Foundation

struct Note: Identifiable, Codable {
    let id = UUID()
    var sportType: String
    var date: Date
    var activities: String
    var goodPoints: String
    var badPoints: String
    var toDoNext: String
    var others: String
}

