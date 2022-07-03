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
        let screens = AX.screens
        let applications = AX.applications.compactMap { app -> Layout.Application? in
            let windows = app.visibleWindows
            guard !windows.isEmpty, let bundleId = app.bundleId, let name = app.name else { return nil }
            return Layout.Application(bundleId: bundleId, name: name, windows: windows.map { window in
                let frame = Layout.Rect(window.frame)
                let screen = screens.firstIndex { $0.frame.contains(frame) }
                return Layout.Window(screen: screen, frame: frame)
            })
        }
        return Layout(version: Constants.version, screens: screens, applications: applications)
    }

    func captureApplications() -> [Layout.Application] {
        let applications = AX.applications.compactMap { app -> Layout.Application? in
            guard let bundleId = app.bundleId, let name = app.name else { return nil }
            return Layout.Application(bundleId: bundleId, name: name, windows: [])
        }
        return applications
    }

    func apply(_ layout: Layout) {
        let screens = AX.screens
        let savedScreens = layout.screens ?? []

        let savedApps: [String: Layout.Application] = layout.applications.reduce(into: [:]) { $0[$1.bundleId] = $1 }
        let apps = AX.applications
        apps.forEach { app in
            guard let bundleId = app.bundleId, let savedApp = savedApps[bundleId], !savedApp.windows.isEmpty else { return }
            let windows = app.visibleWindows
            windows.enumerated().forEach { (index: Int, window: AX.Window) in
                let savedWindow = savedApp.windows[min(index, savedApp.windows.count - 1)]
                let frame = correctFrame(window: savedWindow, savedScreens: savedScreens, screens: screens)
                window.position = CGPoint(x: frame.x, y: frame.y)
                window.size = CGSize(width: frame.width, height: frame.height)
            }
        }
    }

    private func correctFrame(window: Layout.Window, savedScreens: [Layout.Screen], screens: [Layout.Screen]) -> Layout.Rect {
        var frame = window.frame
        guard let id = window.screen, let savedScreen = savedScreens[safe: id], let screen = screens[safe: id] else { return frame }
        guard savedScreen.frame.size == screen.frame.size else { return frame }
        frame.x += -savedScreen.frame.x + screen.frame.x
        frame.y += -savedScreen.frame.y + screen.frame.y
        return frame
    }

    private enum Constants {
        static let version: Int = 2
    }
}
