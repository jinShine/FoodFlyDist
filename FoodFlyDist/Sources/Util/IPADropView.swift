//
//  DropView.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

class IPADropView: NSView {
    
    // UI Property
    private let _imageView: NSImageView = {
        let imageView = NSImageView()
        return imageView
    }()
    
    private let _title: NSTextField = {
        let label = NSTextField()
        label.maximumNumberOfLines = 0
        label.textColor = .black
        label.alignment = .center
        label.isEditable = false
        return label
    }()
    
    
    
    // Property
    
    public var filePath: String?
    public var expectedExt = ["ipa"] {
        didSet(extensions) {
            expectedExt = extensions
        }
    }
    public var image: NSImage? {
        get { return _imageView.image! }
        set (newValue) { _imageView.image = newValue }
    }
    public var title: String? {
        get { return _title.stringValue }
        set (newValue) { _title.stringValue = newValue! }
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        setupUI()
        
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL,
                                 NSPasteboard.PasteboardType.URL,
                                 NSPasteboard.PasteboardType.fileContents])
    
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    private func setupUI() {
        
        self.layer?.backgroundColor = .clear
        [_imageView, _title].forEach { addSubview($0) }
        
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            _imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            _imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            _imageView.bottomAnchor.constraint(equalTo: _title.topAnchor, constant: -10)
            ])
        
        _title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _title.leadingAnchor.constraint(equalTo: leadingAnchor),
            _title.trailingAnchor.constraint(equalTo: trailingAnchor),
            _title.heightAnchor.constraint(equalToConstant: 30),
            _title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) {
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }

        self._imageView.image = NSImage(named: "ipa-file-upload")
        self.filePath = path
        Swift.print("FilePath: \(path)")
        
        return true
    }
}

extension IPADropView {
    
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
