//
// EventMonitor
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask

    var handler: ((NSEvent) -> Void)?

    public init(mask: NSEvent.EventTypeMask) {
        self.mask = mask
    }

    deinit {
        stop()
    }

    func start() {
        guard let handler, monitor == nil else { return }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        guard let monitor else { return }
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}
