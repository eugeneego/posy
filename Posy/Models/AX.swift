//
// AX
// Posy
//
// Copyright (c) 2021 Eugene Egorov.
// License: MIT
//

import Cocoa

enum AX {
    static func isProcessTrusted(prompt: Bool) -> Bool {
        AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt] as CFDictionary)
    }

    static var applications: [Application] {
        NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy != .prohibited && !$0.isTerminated }
            .map { Application(processId: $0.processIdentifier, bundleId: $0.bundleIdentifier, name: $0.localizedName) }
    }

    class Application: Element, CustomStringConvertible {
        let processId: pid_t
        let bundleId: String?
        let name: String?

        var description: String {
            "Application(processId: \(processId), bundleId: \(bundleId ?? "nil"), name: \(name ?? "nil"))"
        }

        var windows: [Element] {
            let windows: [AXUIElement]? = attribute(kAXWindowsAttribute)
            return (windows ?? []).map(Element.init)
        }

        var visibleWindows: [Window] {
            windows.compactMap { window -> AX.Window? in
                guard let position = window.position, let size = window.size else { return nil }
                return AX.Window(frame: CGRect(origin: position, size: size), name: window.title, element: window.element)
            }
        }

        init(processId: pid_t, bundleId: String?, name: String?) {
            self.processId = processId
            self.bundleId = bundleId
            self.name = name
            super.init(element: AXUIElementCreateApplication(processId))
        }
    }

    class Window: Element, CustomStringConvertible {
        let frame: CGRect
        let name: String?

        var description: String {
            "Window(frame: \(frame), name: \(name ?? "nil"))"
        }

        init(frame: CGRect, name: String?, element: AXUIElement) {
            self.frame = frame
            self.name = name
            super.init(element: element)
        }
    }

    class Element {
        let element: AXUIElement

        init(element: AXUIElement) {
            self.element = element
        }

        func attributes() -> [String] {
            var names: CFArray?
            let error = AXUIElementCopyAttributeNames(element, &names)
            guard error == .success, let names = names else { return [] }
            return names as [AnyObject] as? [String] ?? []
        }

        func attribute<T>(_ attribute: String) -> T? {
            var value: AnyObject?
            let error = AXUIElementCopyAttributeValue(element, attribute as CFString, &value)
            guard error == .success, let value = value else { return nil }
            return unpackAXValue(value) as? T
        }

        func setAttribute(_ attribute: String, value: Any) {
            _ = AXUIElementSetAttributeValue(element, attribute as CFString, packAXValue(value))
        }

        func unpackAXValue(_ value: AnyObject) -> Any {
            switch value {
                case let value as AXUIElement:
                    return Element(element: value)
                case let value as AXValue:
                    let type = AXValueGetType(value)
                    switch type {
                        case .cgPoint:
                            var result = CGPoint.zero
                            _ = AXValueGetValue(value, type, &result)
                            return result
                        case .cgSize:
                            var result = CGSize.zero
                            _ = AXValueGetValue(value, type, &result)
                            return result
                        case .cgRect:
                            var result = CGRect.zero
                            _ = AXValueGetValue(value, type, &result)
                            return result
                        case .cfRange:
                            var result = CFRange()
                            _ = AXValueGetValue(value, type, &result)
                            return result
                        case .illegal:
                            return value
                        case .axError:
                            var result = AXError.success
                            _ = AXValueGetValue(value, type, &result)
                            return result
                        @unknown default:
                            return value
                    }
                default:
                    return value
            }
        }

        func packAXValue(_ value: Any) -> AnyObject {
            switch value {
                case let value as Element:
                    return value.element
                case var value as CFRange:
                    guard let axValue = AXValueCreate(.cfRange, &value) else { break }
                    return axValue
                case var value as CGPoint:
                    guard let axValue = AXValueCreate(.cgPoint, &value) else { break }
                    return axValue
                case var value as CGRect:
                    guard let axValue = AXValueCreate(.cgRect, &value) else { break }
                    return axValue
                case var value as CGSize:
                    guard let axValue = AXValueCreate(.cgSize, &value) else { break }
                    return axValue
                default:
                    break
            }
            return value as AnyObject
        }
    }
}

extension AX.Element {
    var title: String? {
        get {
            attribute(kAXTitleAttribute) as String?
        }
        set {
            guard let value = newValue else { return }
            setAttribute(kAXTitleAttribute, value: value)
        }
    }

    var position: CGPoint? {
        get {
            attribute(kAXPositionAttribute)
        }
        set {
            guard let value = newValue else { return }
            setAttribute(kAXPositionAttribute, value: value)
        }
    }

    var size: CGSize? {
        get {
            attribute(kAXSizeAttribute)
        }
        set {
            guard let value = newValue else { return }
            setAttribute(kAXSizeAttribute, value: value)
        }
    }
}
