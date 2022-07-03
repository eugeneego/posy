//
// Resources
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

enum R {
    enum I {
        enum Name {
            static let logo: String = "Icons/logo"
            static let logoStatus: String = "Icons/logo-status"
        }

        static let logo: NSImage? = NSImage(named: Name.logo)
        static let logoStatus: NSImage? = NSImage(named: Name.logoStatus)
    }

    enum S {
        static let name: String = "Posy"

        static let commonSave: String = NSLocalizedString("commonSave", comment: "")
        static let commonCancel: String = NSLocalizedString("commonCancel", comment: "")

        static let mainLayoutPrefix: String = NSLocalizedString("mainLayoutPrefix", comment: "")
        static let mainCaptureLayout: String = NSLocalizedString("mainCaptureLayout", comment: "")
        static let mainCaptureLayoutToPasteboard: String = NSLocalizedString("mainCaptureLayoutToPasteboard", comment: "")
        static let mainCopyProcessesToPasteboard: String = NSLocalizedString("mainCopyProcessesToPasteboard", comment: "")
        static let mainReloadConfiguration: String = NSLocalizedString("mainReloadConfiguration", comment: "")
        static let mainOpenConfigurationFolder: String = NSLocalizedString("mainOpenConfigurationFolder", comment: "")
        static let mainAbout: String = NSLocalizedString("mainAbout", comment: "")
        static let mainQuit: String = NSLocalizedString("mainQuit", comment: "")

        static let aboutDescription: String = NSLocalizedString("aboutDescription", comment: "")
        static let aboutAuthor: String = NSLocalizedString("aboutAuthor", comment: "")

        static let saveTitle: String = NSLocalizedString("saveTitle", comment: "")
        static let saveName: String = NSLocalizedString("saveName", comment: "")

        static let errorLoadConfiguration: String = NSLocalizedString("errorLoadConfiguration", comment: "")
        static let errorOpenConfigurationFolder: String = NSLocalizedString("errorOpenConfigurationFolder", comment: "")
        static let errorLoadLayout: String = NSLocalizedString("errorLoadLayout", comment: "")
        static let errorSaveLayout: String = NSLocalizedString("errorSaveLayout", comment: "")
        static let errorCaptureLayout: String = NSLocalizedString("errorCaptureLayout", comment: "")
        static let errorNoAppFolder: String = NSLocalizedString("errorNoAppFolder", comment: "")
        static let errorFileNotFound: String = NSLocalizedString("errorFileNotFound", comment: "")
        static let errorDataIsNotString: String = NSLocalizedString("errorDataIsNotString", comment: "")
        static let errorNoPermission: String = NSLocalizedString("errorNoPermission", comment: "")
    }
}
