import Vapor
import HTTP

final class NoteController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Note.all().makeJSON()
    }

    func store(_ req: Request) throws -> ResponseRepresentable {
        let note = try req.note()
        try note.save()

        return note
    }

    func show(_ req: Request, note: Note) throws -> ResponseRepresentable {
        return note
    }

    func delete(_ req: Request, note: Note) throws -> ResponseRepresentable {
        try note.delete()

        return Response(status: .ok)
    }

    func update(_ req: Request, note: Note) throws -> ResponseRepresentable {
        try note.update(for: req)
        try note.save()

        return note
    }

    func replace(_ req: Request, note: Note) throws -> ResponseRepresentable {
        let new = try req.note()

        //note.content = new.content
        try note.save()

        return note
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<Note> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete
        )
    }
}

extension Request {
    /// Create a post from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func note() throws -> Note {
        guard let json = json else { throw Abort.badRequest }
        return try Note(json: json)
    }
}

/// Since PostController doesn't require anything to 
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension NoteController: EmptyInitializable { }
