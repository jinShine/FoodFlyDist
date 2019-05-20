//
//  ViewController.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var serviceStatusView: NSView!
    @IBOutlet weak var serviceStatusLabel: NSTextField!
    @IBOutlet weak var dropView: DropView!
    
    var serviceStatus: ServiceState = .failed
    let service: FFDService = FFDService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

