//
// Collection
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
