//
// SaveViewController
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

class SaveViewController: NSViewController {
    private let titleLabel: NSTextField = .init()
    private let captionLabel: NSTextField = .init()
    private let textField: NSTextField = .init()
    private let doneButton: NSButton = .init()
    private let cancelButton: NSButton = .init()

    var cancelAction: (() -> Void)?
    var doneAction: ((String) -> Void)?

    override func loadView() {
        view = View(frame: NSRect(x: 0, y: 0, width: 256, height: 200))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.bounds.width
        let contentWidth = width - Style.grid2 * 2
        let titleFont = NSFont.preferredFont(forTextStyle: .title1)
        let bodyFont = NSFont.preferredFont(forTextStyle: .body)

        titleLabel.stringValue = R.S.saveTitle
        titleLabel.font = titleFont
        titleLabel.isBezeled = false
        titleLabel.isEditable = false
        titleLabel.isSelectable = false
        titleLabel.backgroundColor = .clear
        view.addSubview(titleLabel)

        captionLabel.stringValue = R.S.saveName
        captionLabel.font = bodyFont
        captionLabel.isBezeled = false
        captionLabel.isEditable = false
        captionLabel.isSelectable = false
        captionLabel.backgroundColor = .clear
        view.addSubview(captionLabel)

        view.addSubview(textField)

        doneButton.setButtonType(.momentaryPushIn)
        doneButton.bezelStyle = .regularSquare
        doneButton.keyEquivalent = "\r"
        doneButton.title = R.S.commonSave
        doneButton.target = self
        doneButton.action = #selector(doneTap)
        view.addSubview(doneButton)

        cancelButton.setButtonType(.momentaryPushIn)
        cancelButton.bezelStyle = .regularSquare
        cancelButton.title = R.S.commonCancel
        cancelButton.target = self
        cancelButton.action = #selector(cancelTap)
        view.addSubview(cancelButton)

        // Layout

        let titleSize = titleLabel.sizeThatFits(NSSize(width: contentWidth, height: 100))
        titleLabel.frame = NSRect(x: Style.grid2, y: Style.grid2, width: contentWidth, height: titleSize.height)

        let captionSize = captionLabel.sizeThatFits(NSSize(width: contentWidth, height: 100))
        captionLabel.frame = NSRect(x: Style.grid2, y: titleLabel.frame.maxY + Style.grid2, width: contentWidth, height: captionSize.height)

        textField.frame = NSRect(
            origin: NSPoint(x: Style.grid2, y: captionLabel.frame.maxY + Style.gridHalf),
            size: NSSize(width: contentWidth, height: Style.Field.Height.normal)
        )

        let buttonY = textField.frame.maxY + Style.grid2
        let buttonSize = NSSize(width: Style.grid10, height: Style.Button.Height.normal)
        doneButton.frame = NSRect(origin: NSPoint(x: width - Style.grid2 - buttonSize.width, y: buttonY), size: buttonSize)
        cancelButton.frame = NSRect(
            origin: NSPoint(x: width - Style.grid2 - buttonSize.width * 2 - Style.gridHalf, y: buttonY),
            size: buttonSize
        )

        var frame = view.frame
        frame.size.height = doneButton.frame.maxY + Style.grid2
        view.frame = frame
    }

    @objc private func doneTap() {
        let name = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        doneAction?(name)
    }

    @objc private func cancelTap() {
        cancelAction?()
    }
}
