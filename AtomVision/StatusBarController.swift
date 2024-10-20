//
//  StatusBarController.swift
//  AtomVision
//
//  Created by Anvar Madvaliev on 02/07/24.
//

import AppKit
import SwiftUI

class StatusBarController {
    private var statusBar: NSStatusBar
    private(set) var statusItem: NSStatusItem
    private(set) var popover: NSPopover

    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = .init()
        statusItem = statusBar.statusItem(withLength: 30)

        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "atom", accessibilityDescription: "atom symbol")
            button.action = #selector(showApp(sender:))
            button.target = self
        }
    }

    @objc
    func showApp(sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            NSApplication.shared.activate()

            popover.contentSize = NSSize(width: 250, height: 500)

            popover.show(
                relativeTo: statusItem.button!.bounds,
                of: statusItem.button!,
                preferredEdge: .minY
            )

            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
