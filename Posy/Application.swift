//
// PosyApplication
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class Application: NSApplication {
    private let appDelegate: AppDelegate = .init()

    override init() {
        super.init()
        delegate = appDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
