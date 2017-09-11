import Vapor
import FluentProvider
import HTTP

final class Note: Model {
    let storage = Storage()

    var location: Location?
    var createdAt: Date
    var closedAt: Date?

    static let idKey = "id"
    static let locationKey = "location"
    static let createdAtKey = "created_at"
    static let closedAtKey = "closed_at"

    init(location: Location, createdAt: Date, closedAt: Date?) {
        self.location = location
        self.createdAt = createdAt
        self.closedAt = closedAt
    }

    init(row: Row) throws {
        let locationString: String = try row.get(Note.locationKey)

        location = Note.parseLocation(locationString)
        createdAt = try row.get(Note.createdAtKey)
        closedAt = try row.get(Note.closedAtKey)
    }

    func makeRow() throws -> Row {
        var row = Row()

        try row.set(Note.locationKey, String(format: "(%.8f,%.8f)", location!.latitude, location!.longitude))
        try row.set(Note.createdAtKey, createdAt)
        try row.set(Note.closedAtKey, closedAt)

        return row
    }

    private static func parseLocation(_ locationString: String) -> Location {
        let locationArray = locationString
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .components(separatedBy: ",")

        let latitude = Double(locationArray[0])!
        let longitude = Double(locationArray[1])!

        return Location(latitude: latitude, longitude: longitude)
    }
}

extension Note: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.custom(locationKey, type: "Point")
            builder.date(createdAtKey)
            builder.date(closedAtKey, optional: true)
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Note: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            location: json.get(Note.locationKey),
            createdAt: json.get(Note.createdAtKey),
            closedAt: json.get(Note.closedAtKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Note.idKey, id)
        try json.set(Note.locationKey, location)
        return json
    }
}

extension Note: ResponseRepresentable { }

extension Note: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Note>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            /*
            UpdateableKey(Note.locationKey, String.self) { note, content in
                note.content = content
            }
            */
        ]
    }
}
