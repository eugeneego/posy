//
// AppModel
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class AppModel {
    private let storage: Storage = .init(appName: R.S.name)
    private let layouter: Layouter = .init()
    private(set) var configuration: Configuration = .init(layouts: [])

    func appFolder() throws -> URL {
        try storage.appFolder()
    }

    func hasPermissions() -> Bool {
        AX.isProcessTrusted(prompt: true)
    }

    func loadConfiguration() throws {
        configuration = try storage.read()
    }

    func saveConfiguration() throws {
        try storage.write(configuration: configuration)
    }

    func copyProcessesToPasteboard() {
        let layout = layouter.captureApplications()
        let list = layout.applications
            .map { "\($0.bundleId), \($0.name)" }
            .joined(separator: "\n")
        toPasteboard(string: list)
    }

    func captureLayout() throws -> Layout {
        guard hasPermissions() else { throw AppError.noPermission }
        return layouter.capture()
    }

    func captureLayoutToPasteboard() throws {
        guard hasPermissions() else { throw AppError.noPermission }
        let layout = layouter.capture()
        let data = try storage.encode(data: layout)
        guard let string = String(data: data, encoding: .utf8) else { throw AppError.dataIsNotString }
        toPasteboard(string: string)
    }

    func apply(layout: Layout) {
        layouter.apply(layout)
    }

    func save(layout: Layout, name: String) throws {
        try storage.write(name: name, layout: layout)
        if !configuration.layouts.contains(name) {
            configuration.layouts.append(name)
        }
        try saveConfiguration()
    }

    func loadLayout(name: String) throws -> Layout {
        try storage.read(name: name)
    }

    private func toPasteboard(string: String) {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(string, forType: .string)
    }
}
