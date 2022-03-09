//
// Layout
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

struct Layout: Codable {
    struct Application: Codable {
        var bundleId: String
        var name: String
        var windows: [Window]
    }

    struct Window: Codable {
        var frame: Rect
    }

    struct Rect: Codable {
        var x: Int
        var y: Int
        var width: Int
        var height: Int
    }

    var applications: [Application]
}

extension Layout.Rect {
    init(_ rect: CGRect) {
        x = Int(rect.origin.x)
        y = Int(rect.origin.y)
        width = Int(rect.size.width)
        height = Int(rect.size.height)
    }

    var cgRect: CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
}
