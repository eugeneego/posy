//
// ContentSize
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

import SwiftUI

struct ContentSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func bindContentSize(to size: Binding<CGSize>) -> some View {
        background(GeometryReader { Color.clear.preference(key: ContentSizePreferenceKey.self, value: $0.size) })
            .onPreferenceChange(ContentSizePreferenceKey.self) { size.wrappedValue = $0 }
    }
}
