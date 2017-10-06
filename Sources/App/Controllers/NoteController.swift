import Vapor
import HTTP

final class NoteController: ResourceRepresentable {
    func index(_ req: Request) throws -> ResponseRepresentable {
        let query = try Note.makeQuery().limit(100)

        if (req.data["bbox"] != nil) {
            let bbox = req.data["bbox"]!.string!.split(separator: ",")
            let geoFilter = String(format: "location <@ box(point(%f,%f), point(%f, %f))", Double(bbox[0])!, Double(bbox[1])!, Double(bbox[2])!, Double(bbox[3])!)

            try query.filter(raw: geoFilter)
        }

        return try query.all().makeJSON()
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
