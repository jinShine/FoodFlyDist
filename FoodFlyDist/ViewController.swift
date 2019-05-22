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
    //--ㄴ Development
    @IBOutlet weak var choiceDevBackground: NSView!
    @IBOutlet weak var choiceDevTitle: NSTextField!
    @IBOutlet weak var choiceDevIPAView: IPADropView!
    @IBOutlet weak var choiceDevAPKView: IPADropView!
    //--ㄴ Production
    @IBOutlet weak var choiceProBackground: NSView!
    @IBOutlet weak var choiceProTitle: NSTextField!
    @IBOutlet weak var choiceProIPAView: IPADropView!
    @IBOutlet weak var choiceProAPKView: IPADropView!
    
    
    /*
     자동
     */
    @IBOutlet weak var autoRiderContainer: NSView!
    @IBOutlet weak var autoTitle: NSTextField!
    //--ㄴ Development
    @IBOutlet weak var autoDevBackground: NSView!
    @IBOutlet weak var autoDevTitle: NSTextField!
    @IBOutlet weak var autoDevIPAView: IPADropView!
    @IBOutlet weak var autoDevAPKView: IPADropView!
    //--ㄴ Production
    @IBOutlet weak var autoProBackground: NSView!
    @IBOutlet weak var autoProTitle: NSTextField!
    @IBOutlet weak var autoProIPAView: IPADropView!
    @IBOutlet weak var autoProAPKView: IPADropView!
    
    
    
    
    @IBOutlet weak var serviceStatusView: NSView!
    @IBOutlet weak var serviceStatusLabel: NSTextField!
    
    // Detail Infomation View
    @IBOutlet weak var detailInfoView: NSView!
    @IBOutlet weak var detailInfoViewHeight: NSLayoutConstraint!
    
    
    
    var serviceStatus: ServiceState = .failed
    let service: FFDService = FFDService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailInfoViewHeight.constant = 0
        setupUI()
        
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
//        do {
//            let fileUrl = URL(fileURLWithPath: dropView.filePath ?? "")
//            let fileData = try Data(contentsOf: fileUrl)
//            service.fileUpload(fileData: fileData) { result in
//                result.uploadProgress(closure: { progress in
//                    print("업로드중 \(progress.fractionCompleted)")
//                })
//            }
//        } catch {
//            print("FILE OPTIONAL ERROR")
//        }
//        sender.
        
        detailInfoView.wantsLayer = true
        detailInfoView.layer?.backgroundColor = NSColor.white.cgColor
        detailInfoView.layer?.cornerRadius = 10
        
        NSAnimationContext.runAnimationGroup { _ in
            NSAnimationContext.current.duration = 5.0
            detailInfoViewHeight.constant = 200
        }
    }
}

extension ViewController {
    
    private func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0x444444).cgColor
        
        choiceRiderContainer.wantsLayer = true
        choiceRiderContainer.layer?.backgroundColor = .white
        choiceRiderContainer.layer?.cornerRadius = 10
        
        choiceTitle.wantsLayer = true
        choiceTitle.textColor = .black
        
        choiceDevBackground.wantsLayer = true
        choiceDevBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        choiceDevIPAView.image = NSImage(named: "ipa-file")
        choiceDevIPAView.title = "ipa파일 끌어넣기"
        choiceDevAPKView.image = NSImage(named: "apk-file")
        choiceDevAPKView.title = "apk파일 끌어넣기"
        
        choiceProBackground.wantsLayer = true
        choiceProBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        choiceProIPAView.image = NSImage(named: "ipa-file")
        choiceProIPAView.title = "ipa파일 끌어넣기"
        choiceProAPKView.image = NSImage(named: "apk-file")
        choiceProAPKView.title = "apk파일 끌어넣기"
        
        
        
        
        
        autoRiderContainer.wantsLayer = true
        autoRiderContainer.layer?.backgroundColor = .white
        autoRiderContainer.layer?.cornerRadius = 10
        
        autoTitle.wantsLayer = true
        autoTitle.textColor = .black
        
        autoDevBackground.wantsLayer = true
        autoDevBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        autoDevIPAView.image = NSImage(named: "ipa-file")
        autoDevIPAView.title = "ipa파일 끌어넣기"
        autoDevAPKView.image = NSImage(named: "apk-file")
        autoDevAPKView.title = "apk파일 끌어넣기"
        
        autoProBackground.wantsLayer = true
        autoProBackground.layer?.backgroundColor = NSColor.RGBHex(hexValue: 0xDDDDDD).cgColor
        autoProIPAView.image = NSImage(named: "ipa-file")
        autoProIPAView.title = "ipa파일 끌어넣기"
        autoProAPKView.image = NSImage(named: "apk-file")
        autoProAPKView.title = "apk파일 끌어넣기"
    }

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

