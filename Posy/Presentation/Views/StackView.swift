//
// StackView
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

enum StackView {
    struct Item {
        enum Mode {
            case fill
            case center(NSSize)
        }

        var control: NSControl
        var spacing: CGFloat
        var mode: Mode
    }

    static func verticalLayout(items: [StackView.Item], width: CGFloat, offset: CGPoint, edgeInsets: NSEdgeInsets) -> NSSize {
        let contentWidth = width - edgeInsets.left - edgeInsets.right
        var size = NSSize(width: width, height: edgeInsets.top + edgeInsets.bottom)
        var y = offset.y + edgeInsets.top
        items.forEach { item in
            let itemSize: NSSize
            switch item.mode {
                case .fill:
                    itemSize = item.control.sizeThatFits(NSSize(width: contentWidth, height: 1000))
                    item.control.frame = NSRect(x: offset.x + edgeInsets.left, y: y, width: contentWidth, height: itemSize.height)
                case .center(let size):
                    itemSize = size
                    item.control.frame = NSRect(origin: NSPoint(x: offset.x + (width - itemSize.width) / 2, y: y), size: itemSize)
            }
            y += itemSize.height + item.spacing
            size.height += itemSize.height + item.spacing
        }
        return size
    }
}
