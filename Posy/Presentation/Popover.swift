//
// Popover
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class Popover {
    private let popover: NSPopover = .init()
    private let eventMonitor: EventMonitor = .init(mask: [.leftMouseDown, .rightMouseDown])

    init() {
        eventMonitor.handler = { [weak self] _ in
            self?.hide()
        }
    }

    func show(viewController: NSViewController, from view: NSView?) {
        if popover.isShown && popover.contentViewController == viewController {
            hide()
        } else {
            guard let view = view else { return }
            popover.contentViewController = viewController
            eventMonitor.start()
            popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
        }
    }

    func hide() {
        guard popover.isShown else { return }
        eventMonitor.stop()
        popover.performClose(nil)
        popover.contentViewController = nil
    }
}
