//
// SaveView
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

import SwiftUI

struct SaveView: View {
    @State private var name: String
    @State private var isValid: Bool = true
    private let cancel: () -> Void
    private let save: (String) -> Void

    init(name: String = "", cancel: @escaping () -> Void, save: @escaping (String) -> Void) {
        self.name = name
        self.cancel = cancel
        self.save = save
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(R.S.saveTitle)
                .font(.title)
                .padding(.bottom, Style.grid2)
            Text(R.S.saveName)
                .font(.body)
            TextField("", text: $name)
                .onSubmit(saveAction)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, Style.grid1)
                .modifier(Shake(animatableData: !isValid ? 1 : 0))
            HStack {
                Button(R.S.commonCancel, role: .cancel, action: cancel)
                    .buttonStyle(.bordered)
                Button(R.S.commonSave) { saveAction() }
                    .buttonStyle(.borderedProminent)
            }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
            .frame(width: 256)
            .padding(Style.grid2)
    }

    private func saveAction() {
        isValid = true
        withAnimation {
            let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            isValid = !name.isEmpty
            guard isValid else { return }
            save(name)
        }
    }
}
