//
//  DropView.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    public var filePath: String?
    public var expectedExt = ["ipa", "apk"] {
        didSet(extensions) {
            expectedExt = extensions
        }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL,
                                 NSPasteboard.PasteboardType.URL,
                                 NSPasteboard.PasteboardType.fileContents])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) {
            self.layer?.backgroundColor = NSColor.yellow.cgColor
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.gray.cgColor
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        self.filePath = path
        Swift.print("FilePath: \(path)")
        
        return true
    }
}

extension DropView {
    
    private func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType.init(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = board[0] as? String else { return false }
        
        let dragFileExtension = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == dragFileExtension {
                return true
            }
        }
        return false
    }
}
