//
// Style
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

enum Style {
    private static let grid: CGFloat = 8
    static let gridHalf: CGFloat = grid / 2
    static let grid1: CGFloat = grid * 1
    static let grid2: CGFloat = grid * 2
    static let grid3: CGFloat = grid * 3
    static let grid4: CGFloat = grid * 4
    static let grid5: CGFloat = grid * 5
    static let grid6: CGFloat = grid * 6
    static let grid7: CGFloat = grid * 7
    static let grid8: CGFloat = grid * 8
    static let grid9: CGFloat = grid * 9
    static let grid10: CGFloat = grid * 10

    enum Button {
        enum Height {
            static let normal: CGFloat = grid4
        }
    }

    enum Field {
        enum Height {
            static let normal: CGFloat = grid3
        }
    }
}
