import Vapor
import Foundation
import Console
import SWXMLHash

final class ImportCommand: Command {
    public let id = "import"
    public let help = ["This command does things, like foo, and bar."]
    public let console: ConsoleProtocol

    public init(console: ConsoleProtocol) {
        self.console = console
    }

    public func run(arguments: [String]) throws {
        if (arguments.isEmpty) {
            return console.print("You have to provide file name!");
        }

        let xmlContent = try String(contentsOfFile: arguments[0], encoding: String.Encoding.utf8)
        let xml = SWXMLHash.lazy(xmlContent)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        console.print("loaded xml file")

        for elem in xml["osm-notes"]["note"].all {
            let element = elem.element!

            let location = Location(
                latitude: Double(element.attribute(by: "lat")!.text)!,
                longitude: Double(element.attribute(by: "lon")!.text)!
            )

            let createdAt = dateFormatter.date(from: element.attribute(by: "created_at")!.text)!
            let closedAt = dateFormatter.date(from: element.attribute(by: "closed_at")!.text)

            let note = Note.init(
                location: location,
                createdAt: createdAt,
                closedAt: closedAt
            )

            note.id = Identifier(Int(element.attribute(by: "id")!.text)!)

            try note.save()

            for elem in elem["comment"].all {
                let element = elem.element!

                let createdAt = dateFormatter.date(from: element.attribute(by: "timestamp")!.text)!

                let comment = Comment.init(
                    noteId: note.id!,
                    action: Action(rawValue: element.attribute(by: "action")!.text)!,
                    createdAt: createdAt,
                    text: element.text
                )

                try comment.save()
            }
        }
    }
}

extension ImportCommand: ConfigInitializable {
    public convenience init(config: Config) throws {
        let console = try config.resolveConsole()
        self.init(console: console)
    }
}
