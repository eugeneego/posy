//
// Storage
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Foundation

class Storage {
    private let fileManager: FileManager = .default
    private let decoder: JSONDecoder = .init()
    private let encoder: JSONEncoder = .init()
    private let configFile: String = "configuration.json"
    private let layoutExtension: String = "layout.json"
    private let appName: String

    init(appName: String) {
        self.appName = appName
        encoder.outputFormatting = [.prettyPrinted]
    }

    // MARK: - State

    func write(name: String, layout: Layout) throws {
        try write(file: try url(layoutName: name), data: layout)
    }

    func read(name: String) throws -> Layout {
        try read(file: try url(layoutName: name))
    }

    // MARK: - Configuration

    func write(configuration: Configuration) throws {
        try write(file: try appFolder().appendingPathComponent(configFile), data: configuration)
    }

    func read() throws -> Configuration {
        try read(file: try appFolder().appendingPathComponent(configFile))
    }

    // MARK: - Generic

    func encode<T: Encodable>(data: T) throws -> Data {
        try encoder.encode(data)
    }

    func decode<T: Decodable>(data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }

    func write<T: Encodable>(file: URL, data: T) throws {
        let data = try encode(data: data)
        try data.write(to: file)
    }

    func read<T: Decodable>(file: URL) throws -> T {
        guard fileManager.fileExists(atPath: file.path) else { throw AppError.fileNotFound }
        let data = try Data(contentsOf: file)
        return try decode(data: data)
    }

    // MARK: - Routines

    func appFolder() throws -> URL {
        guard let folder = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw AppError.noAppFolder
        }
        let appFolder = folder.appendingPathComponent(appName)
        try? fileManager.createDirectory(at: appFolder, withIntermediateDirectories: true, attributes: nil)
        return appFolder
    }

    func url(layoutName: String) throws -> URL {
        try appFolder().appendingPathComponent("\(sanitize(filename: layoutName)).\(layoutExtension)", isDirectory: false)
    }

    func sanitize(filename: String) -> String {
        filename.components(separatedBy: CharacterSet(charactersIn: "/\\\":?%*|<>")).joined()
    }
}
