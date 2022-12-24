//
// Shake
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

import SwiftUI

struct Shake: GeometryEffect {
    var offset: CGFloat = 8
    var shakes: Int = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: offset * sin(animatableData * .pi * CGFloat(shakes)), y: 0))
    }
}
