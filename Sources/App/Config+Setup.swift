import FluentProvider
import PostgreSQLProvider

extension Config {
    public func setup() throws {
        Node.fuzzy = [Row.self, JSON.self, Node.self, Location.self]

        try setupProviders()
        try setupPreparations()

        addConfigurable(command: ImportCommand.init, name: "import")
    }

    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }

    private func setupPreparations() throws {
        preparations.append(Note.self)
        preparations.append(Comment.self)
    }
}
