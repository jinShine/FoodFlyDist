//
//  ViewController.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    /*
     선택
     */
    @IBOutlet weak var choiceRiderContainer: NSView!
    @IBOutlet weak var choiceTitle: NSTextField!
    @IBOutlet weak var choiceDevBackground: NSView!
    @IBOutlet weak var choiceDevTitle: NSTextField!
    @IBOutlet weak var choiceProBackground: NSView!
    @IBOutlet weak var choiceProTitle: NSTextField!
    
    /*
     자동
     */
    @IBOutlet weak var autoRiderContainer: NSView!
    @IBOutlet weak var autoTitle: NSTextField!
    @IBOutlet weak var autoDevBackground: NSView!
    @IBOutlet weak var autoDevTitle: NSTextField!
    @IBOutlet weak var autoProBackground: NSView!
    @IBOutlet weak var autoProTitle: NSTextField!
    
    
    
    
    @IBOutlet weak var serviceStatusView: NSView!
    @IBOutlet weak var serviceStatusLabel: NSTextField!
    @IBOutlet weak var dropView: DropView!
    
    
    
    var serviceStatus: ServiceState = .failed
    let service: FFDService = FFDService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0x444444).cgColor
        
        choiceRiderContainer.wantsLayer = true
        choiceRiderContainer.layer?.backgroundColor = .white
        choiceRiderContainer.layer?.cornerRadius = 10
        
        choiceTitle.wantsLayer = true
        choiceTitle.textColor = .black
        
        choiceDevBackground.wantsLayer = true
        choiceDevBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        
        choiceProBackground.wantsLayer = true
        choiceProBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        
        
        
        
        
        autoRiderContainer.wantsLayer = true
        autoRiderContainer.layer?.backgroundColor = .white
        autoRiderContainer.layer?.cornerRadius = 10
        
        autoTitle.wantsLayer = true
        autoTitle.textColor = .black
        
        autoDevBackground.wantsLayer = true
        autoDevBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        
        autoProBackground.wantsLayer = true
        autoProBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        
        
        
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        service.pingCheck(completion: changeStatus)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func fileUpload(_ sender: NSButton) {
        do {
            let fileUrl = URL(fileURLWithPath: dropView.filePath ?? "")
            let fileData = try Data(contentsOf: fileUrl)
            service.fileUpload(fileData: fileData) { result in
                result.uploadProgress(closure: { progress in
                    print("업로드중 \(progress.fractionCompleted)")
                })
            }
        } catch {
            print("FILE OPTIONAL ERROR")
        }
    }
}

extension ViewController {

    private func changeStatus(_ result: Bool, _ ping: SwiftyPing?) -> () {
        if result {
            ping?.observer = { (_, response) in
                let duration = response.duration
                print(duration)
                ping?.stop()
            }
            self.serviceStatus = .connected
            self.serviceStatusLabel.stringValue = "업로드 가능"
            self.serviceStatusView.wantsLayer = true
            self.serviceStatusView.layer?.cornerRadius = self.serviceStatusView.frame.width / 2
            self.serviceStatusView.layer?.backgroundColor = NSColor.green.cgColor
            ping?.start()
        } else {
            print("STOP")
            self.serviceStatus = .failed
            self.serviceStatusLabel.stringValue = "서버 업로드 불가능"
            self.serviceStatusView.wantsLayer = true
            self.serviceStatusView.layer?.cornerRadius = self.serviceStatusView.frame.width / 2
            self.serviceStatusView.layer?.backgroundColor = NSColor.red.cgColor
            ping?.stop()
        }
    }
    
}

