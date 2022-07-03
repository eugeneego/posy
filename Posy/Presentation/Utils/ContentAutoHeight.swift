//
// ContentAutoHeight
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

import SwiftUI

struct ContentAutoHeight: ViewModifier {
    @State private var contentSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .bindContentSize(to: $contentSize)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: contentSize.height)
    }
}

extension View {
    func contentAutoHeight() -> some View {
        modifier(ContentAutoHeight())
    }
}
