import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("notes", NoteController.self)
    }
}
