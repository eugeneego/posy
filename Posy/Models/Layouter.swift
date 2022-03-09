//
// Layouter
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class Layouter {
    func capture() -> Layout {
        let apps = AX.applications
        let applications = apps.compactMap { app -> Layout.Application? in
            let windows = app.visibleWindows
            guard !windows.isEmpty, let bundleId = app.bundleId, let name = app.name else { return nil }
            return Layout.Application(bundleId: bundleId, name: name, windows: windows.map { Layout.Window(frame: Layout.Rect($0.frame)) })
        }
        return Layout(applications: applications)
    }

    func captureApplications() -> Layout {
        let apps = AX.applications
        let applications = apps.compactMap { app -> Layout.Application? in
            guard let bundleId = app.bundleId, let name = app.name else { return nil }
            return Layout.Application(bundleId: bundleId, name: name, windows: [])
        }
        return Layout(applications: applications)
    }

    func apply(_ layout: Layout) {
        let savedApps: [String: Layout.Application] = layout.applications.reduce(into: [:]) { $0[$1.bundleId] = $1 }
        let apps = AX.applications
        apps.forEach { app in
            guard let bundleId = app.bundleId, let savedApp = savedApps[bundleId], !savedApp.windows.isEmpty else { return }
            let windows = app.visibleWindows
            windows.enumerated().forEach { (index: Int, window: AX.Window) in
                let savedWindow = savedApp.windows[index < savedApp.windows.count ? index : 0]
                window.position = CGPoint(x: savedWindow.frame.x, y: savedWindow.frame.y)
                window.size = CGSize(width: savedWindow.frame.width, height: savedWindow.frame.height)
            }
        }
    }
}
