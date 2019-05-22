//
//  ViewController.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa
import SSZipArchive

class ViewController: NSViewController {
    
    @IBOutlet weak var serviceStatusView: NSView!
    @IBOutlet weak var serviceStatusLabel: NSTextField!
    
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
    
    @IBOutlet weak var uploadButton: NSButton!
    
    
    
    // Detail Infomation View
    @IBOutlet weak var detailInfoView: NSView!
    @IBOutlet weak var detailInfoViewHeight: NSLayoutConstraint!
    
    
    
    var serviceStatus: ServiceState = .failed
    let service: FFDService = FFDService()
    var uploadFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        detailInfoViewHeight.constant = 0
        NotificationCenter.default.addObserver(self, selector: #selector(getDropFilePath), name: NSNotification.Name("DropFilePath"), object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func fileUpload(_ sender: NSButton) {
        do {
            let fileUrl = URL(fileURLWithPath: uploadFilePath ?? "")
            let fileData = try Data(contentsOf: fileUrl)
            service.fileUpload(fileData: fileData) { result in
                result.uploadProgress(closure: { progress in
                    let fraction = Float(progress.fractionCompleted)
                    let uploadValue = String(format: "%.f", fraction * 100)
                    print("업로드중 \(uploadValue)")
                })
            }
        } catch {
            print("FILE OPTIONAL ERROR")
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
        
        
        
        
        uploadButton.isEnabled = false
        uploadButton.isHighlighted = true
    }
    
    private func setupDetailInfoView() {
        detailInfoView.wantsLayer = true
        detailInfoView.layer?.backgroundColor = NSColor.white.cgColor
        detailInfoView.layer?.cornerRadius = 10
        
        NSAnimationContext.runAnimationGroup { _ in
            NSAnimationContext.current.duration = 5.0
            detailInfoViewHeight.constant = 200
        }
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
    
    @objc private func getDropFilePath(noti: Notification) {
        
        setupDetailInfoView()
        uploadButton.isEnabled = true
        uploadButton.isHighlighted = false
        
        guard let userInfo = noti.userInfo,
        let filePath = userInfo["FilePath"] as? String else { return }
        uploadFilePath = filePath
        
        // ipa 파일을 UnZip을 하면 Payload폴더가 생김(정보를 가져올수 있음)
        let unZipPath = tempUnZipPath(from: filePath)

        let success: Bool = SSZipArchive.unzipFile(atPath: filePath, toDestination: unZipPath)
        if success {
            print(unZipPath + "Payload")
            print("Success UnZip")
        } else {
            print("Fail UnZip")
        }
        
    }
    
    func tempUnZipPath(from filePath: String) -> String {
        print("1",filePath)
        let fileURLPath = URL(fileURLWithPath: filePath).deletingLastPathComponent()
        let encodingPath = fileURLPath.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let path = encodingPath?.components(separatedBy: "file://").last {
            return path
        }
        return ""
    }
}
