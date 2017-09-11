import Vapor
import FluentProvider
import HTTP

enum Action: String {
    case commented, closed, opened, reopened 
}

final class Comment: Model {
    let storage = Storage()

    let noteId: Identifier
    var action: Action
    var createdAt: Date
    var text: String

    var owner: Parent<Comment, Note> {
        return parent(id: noteId)
    }

    static let idKey = "id"
    static let noteIdKey = "note_id"
    static let actionKey = "action"
    static let createdAtKey = "created_at"
    static let textKey = "text"

    init(noteId: Identifier, action: Action, createdAt: Date, text: String) {
        self.noteId = noteId
        self.action = action
        self.createdAt = createdAt
        self.text = text
    }

    init(row: Row) throws {
        noteId = try row.get(Comment.noteIdKey)
        action = Action(rawValue: try row.get(Comment.actionKey))!
        createdAt = try row.get(Comment.createdAtKey)
        text = try row.get(Comment.textKey)
    }

    func makeRow() throws -> Row {
        var row = Row()

        try row.set(Comment.noteIdKey, noteId)
        try row.set(Comment.actionKey, action.rawValue)
        try row.set(Comment.createdAtKey, createdAt)
        try row.set(Comment.textKey, text)

        return row
    }
}

extension Comment: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.parent(Note.self)
            builder.string(actionKey)
            builder.date(createdAtKey)
            builder.string(textKey)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Comment: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            noteId: json.get(Comment.noteIdKey),
            action: json.get(Comment.actionKey),
            createdAt: json.get(Comment.createdAtKey),
            text: json.get(Comment.textKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Comment.idKey, id)
        try json.set(Comment.actionKey, action.rawValue)
        try json.set(Comment.createdAtKey, createdAt)
        try json.set(Comment.textKey, text)
        return json
    }
}

extension Comment: ResponseRepresentable { }
