import Vapor
import HTTP

final class NoteController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Note.makeQuery()
            .join(Comment.self)
            .limit(100)
            .all()
            .makeJSON()
    }

    func show(_ req: Request, note: Note) throws -> ResponseRepresentable {
        return note
    }

    func makeResource() -> Resource<Note> {
        return Resource(
            index: index,
            show: show
        )
    }
}

extension NoteController: EmptyInitializable { }
