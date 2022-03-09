//
// AboutViewController
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class AboutViewController: NSViewController {
    override func loadView() {
        view = View(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle.main
        let localName = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
        let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName" as String) as? String ?? localName
        let bundleId = bundle.bundleIdentifier ?? ""
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

        let title1Font = NSFont.preferredFont(forTextStyle: .title1)
        let title3Font = NSFont.preferredFont(forTextStyle: .title3)
        let headlineFont = NSFont.preferredFont(forTextStyle: .headline)
        let bodyFont = NSFont.preferredFont(forTextStyle: .body)

        let iconView = NSImageView()
        iconView.image = R.I.logo
        iconView.imageAlignment = .alignCenter
        iconView.imageScaling = .scaleProportionallyUpOrDown
        iconView.contentTintColor = .textColor
        view.addSubview(iconView)

        let nameLabel = createLabel(text: name, font: title1Font)
        view.addSubview(nameLabel)

        let descriptionLabel = createLabel(text: R.S.aboutDescription, font: title3Font)
        view.addSubview(descriptionLabel)

        let authorLabel = createLabel(text: R.S.aboutAuthor, font: headlineFont)
        view.addSubview(authorLabel)

        let bundleLabel = createLabel(text: bundleId, font: bodyFont)
        view.addSubview(bundleLabel)

        let versionLabel = createLabel(text: version, font: bodyFont)
        view.addSubview(versionLabel)

        // Layout

        let edgeInsets = NSEdgeInsets(top: Style.grid2, left: Style.grid2, bottom: Style.grid2, right: Style.grid2)
        let items: [StackView.Item] = [
            .init(control: iconView, spacing: Style.grid1, mode: .center(NSSize(width: Style.grid8, height: Style.grid8))),
            .init(control: nameLabel, spacing: Style.grid2, mode: .fill),
            .init(control: descriptionLabel, spacing: Style.grid3, mode: .fill),
            .init(control: authorLabel, spacing: Style.grid1, mode: .fill),
            .init(control: bundleLabel, spacing: 0, mode: .fill),
            .init(control: versionLabel, spacing: 0, mode: .fill),
        ]
        let size = StackView.verticalLayout(items: items, width: view.bounds.width, offset: .zero, edgeInsets: edgeInsets)
        view.frame = NSRect(origin: .zero, size: size)
    }

    private func createLabel(text: String, font: NSFont) -> NSTextField {
        let label = NSTextField()
        label.stringValue = text
        label.font = font
        label.alignment = .center
        label.isBezeled = false
        label.isEditable = false
        label.isSelectable = false
        label.backgroundColor = .clear
        return label
    }
}
