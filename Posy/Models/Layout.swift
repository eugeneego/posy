//
// Layout
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

struct Layout: Codable, Equatable {
    struct Screen: Codable, Equatable {
        var name: String
        var frame: Rect
    }

    struct Application: Codable, Equatable {
        var bundleId: String
        var name: String
        var windows: [Window]
    }

    struct Window: Codable, Equatable {
        var name: String?
        var screen: Int?
        var frame: Rect
    }

    struct Rect: Codable, Equatable {
        var x: Int
        var y: Int
        var width: Int
        var height: Int

        var maxX: Int { x + width }
        var maxY: Int { y + height }
        var size: Size { Size(width: width, height: height) }

        func contains(_ rect: Rect) -> Bool {
            rect.x >= x && rect.y >= y && rect.maxX <= maxX && rect.maxY <= maxY
        }
    }

    struct Size: Codable, Equatable {
        var width: Int
        var height: Int
    }

    var version: Int?
    var screens: [Screen]?
    var applications: [Application]
}

extension Layout.Rect {
    init(_ rect: CGRect) {
        x = Int(rect.origin.x)
        y = Int(rect.origin.y)
        width = Int(rect.size.width)
        height = Int(rect.size.height)
    }
}
