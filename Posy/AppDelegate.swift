//
// AppDelegate
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private lazy var aboutViewController: NSViewController = NSHostingController(rootView: AboutView())
    private let popover: Popover = .init()
    private let menu: NSMenu = .init()
    private var standardMenuItems: [NSMenuItem] = []
    private let model: AppModel = .init()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        loadConfiguration()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    private func setupMenu() {
        statusItem.button?.image = R.I.logoStatus
        statusItem.button?.imageScaling = .scaleProportionallyUpOrDown
        statusItem.menu = menu
        standardMenuItems = [
            NSMenuItem(title: R.S.mainCaptureLayout, action: #selector(capture), keyEquivalent: ""),
            NSMenuItem(title: R.S.mainCaptureLayoutToPasteboard, action: #selector(captureToPasteboard), keyEquivalent: ""),
            NSMenuItem(title: R.S.mainCopyProcessesToPasteboard, action: #selector(copyProcesses), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: R.S.mainReloadConfiguration, action: #selector(loadConfiguration), keyEquivalent: ""),
            NSMenuItem(title: R.S.mainOpenConfigurationFolder, action: #selector(openConfiguration), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: R.S.mainAbout, action: #selector(about), keyEquivalent: ""),
            NSMenuItem(title: R.S.mainQuit, action: #selector(NSApplication.terminate), keyEquivalent: "q"),
        ]
        menu.items = standardMenuItems
    }

    // MARK: - About

    @objc private func about() {
        popover.show(viewController: aboutViewController, from: statusItem.button)
    }

    // MARK: - Preferences

    @objc private func loadConfiguration() {
        do {
            try model.loadConfiguration()
            updateLayoutMenu()
        } catch {
            show(error: error, message: R.S.errorLoadConfiguration)
        }
    }

    @objc private func openConfiguration() {
        do {
            let url = try model.appFolder()
            NSWorkspace.shared.open(url)
        } catch {
            show(error: error, message: R.S.errorOpenConfigurationFolder)
        }
    }

    private func updateLayoutMenu() {
        var items = standardMenuItems
        let layoutsItems = model.configuration.layouts.map { layout in
            layout == "-"
                ? NSMenuItem.separator()
                : NSMenuItem(title: R.S.mainLayoutPrefix + layout, action: #selector(loadLayout(_:)), keyEquivalent: "")
        }
        if !layoutsItems.isEmpty {
            items = layoutsItems + [NSMenuItem.separator()] + items
        }
        menu.items = items
    }

    // MARK: - Errors

    private func show(error: Error, message: String) {
        NSLog("%@", "\(message), \(error)")

        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = error.localizedDescription
        alert.alertStyle = .critical
        alert.runModal()
    }

    // MARK: - Layout

    @objc private func loadLayout(_ menuItem: NSMenuItem) {
        guard model.hasPermissions() else { return }

        let name = String(menuItem.title.dropFirst(R.S.mainLayoutPrefix.count))
        do {
            let layout = try model.loadLayout(name: name)
            model.apply(layout: layout)
        } catch {
            show(error: error, message: String(format: R.S.errorLoadLayout, name))
        }
    }

    @objc private func capture() {
        guard model.hasPermissions() else { return }

        let saveViewController = SaveViewController()
        saveViewController.cancelAction = { [weak self] in
            self?.popover.hide()
        }
        saveViewController.doneAction = { [weak self] name in
            self?.saveLayout(name: name)
        }
        popover.show(viewController: saveViewController, from: statusItem.button)
    }

    private func saveLayout(name: String) {
        do {
            let layout = try model.captureLayout()
            try model.save(layout: layout, name: name)
            updateLayoutMenu()
            popover.hide()
        } catch {
            show(error: error, message: String(format: R.S.errorSaveLayout, name))
        }
    }

    @objc private func captureToPasteboard() {
        do {
            try model.captureLayoutToPasteboard()
        } catch {
            show(error: error, message: R.S.errorCaptureLayout)
        }
    }

    @objc private func copyProcesses() {
        model.copyProcessesToPasteboard()
    }
}
