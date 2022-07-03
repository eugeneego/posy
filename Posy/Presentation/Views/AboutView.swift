//
// AboutView
// Posy
//
// Copyright (c) 2022 Eugene Egorov.
// License: MIT
//

import SwiftUI

struct AboutView: View {
    private let name: String
    private let description: String = R.S.aboutDescription
    private let author: String = R.S.aboutAuthor
    private let bundleId: String
    private let version: String

    init() {
        let bundle = Bundle.main
        let localName = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
        name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName" as String) as? String ?? localName
        bundleId = bundle.bundleIdentifier ?? ""
        version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var body: some View {
        VStack {
            Image(R.I.Name.logo)
                .resizable()
                .scaledToFill()
                .frame(width: Style.grid8, height: Style.grid8)
                .colorMultiply(Color(.textColor))
                .padding(.bottom, Style.grid1)
            Text(name)
                .font(.title)
                .padding(.bottom, Style.grid1)
            Text(description)
                .font(.title3)
                .padding(.bottom, Style.grid2)
            Text(author)
                .font(.headline)
                .padding(.bottom, Style.gridHalf)
            Text(bundleId)
                .font(.body)
            Text(version)
                .font(.body)
        }
        .multilineTextAlignment(.center)
        .padding(.all, Style.grid2)
        .frame(maxWidth: 200)
        .contentAutoHeight()
    }
}
