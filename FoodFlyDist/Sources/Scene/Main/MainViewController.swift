//
//  ViewController.swift
//  FoodFlyDist
//
//  Created by Seungjin on 20/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa
import SSZipArchive

class MainViewController: NSViewController {
    
    struct UI {
        static let backgroundColor: NSColor = NSColor.RGBHex(hexValue: 0x444444)
        static let environmentColor: NSColor = NSColor.RGBHex(hexValue: 0xDDDDDD)
        static let detailViewHeight: CGFloat = 200
        static let cornerRadiusValue: CGFloat = 10
    }
    
    //MARK:- UI Properties
    
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
    @IBOutlet weak var choiceDevIPAView: ChoiceDevIpaView!
    @IBOutlet weak var choiceDevAPKView: ChoiceDevApkView!
    //--ㄴ Production
    @IBOutlet weak var choiceProBackground: NSView!
    @IBOutlet weak var choiceProTitle: NSTextField!
    @IBOutlet weak var choiceProIPAView: ChoiceProIpaView!
    @IBOutlet weak var choiceProAPKView: ChoiceProApkView!
    
    
    /*
     자동
     */
    @IBOutlet weak var autoRiderContainer: NSView!
    @IBOutlet weak var autoTitle: NSTextField!
    //--ㄴ Development
    @IBOutlet weak var autoDevBackground: NSView!
    @IBOutlet weak var autoDevTitle: NSTextField!
    @IBOutlet weak var autoDevIPAView: AutoDevIpaView!
    @IBOutlet weak var autoDevAPKView: AutoDevApkView!
    //--ㄴ Production
    @IBOutlet weak var autoProBackground: NSView!
    @IBOutlet weak var autoProTitle: NSTextField!
    @IBOutlet weak var autoProIPAView: AutoProIpaView!
    @IBOutlet weak var autoProAPKView: AutoProApkView!
    
    @IBOutlet weak var uploadProgressbar: NSProgressIndicator!
    @IBOutlet weak var uploadProgressValue: NSTextField!
    
    
    /*
     Detail Infomation View
     */
    @IBOutlet weak var detailInfoView: NSView!
    @IBOutlet weak var detailInfoViewHeight: NSLayoutConstraint!
    //ㄴ Detail Info
    @IBOutlet weak var registrantTextField: NSTextField!
    @IBOutlet weak var versionTextField: NSTextField!
    @IBOutlet weak var uploadServerPopup: NSPopUpButton!
    @IBOutlet weak var revisionHistoryTextField: NSScrollView!
    
    //업로드 버튼
    @IBOutlet weak var uploadButton: NSButton!
    
    
    //MARK:- Properties
    
    var serviceStatus: ServiceState = .failed
    let service: FFDService = FFDService()
    var uploadFilePath: String?
    var flatformType: String?
    var fileVersion: String?
    var appType: String?
    var appEnvironment: String?
    
    
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        detailInfoViewHeight.constant = 0
        NotificationCenter.default.addObserver(self, selector: #selector(getDropFileInfo), name: NSNotification.Name("DropFilePath"), object: nil)
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
    
    
    //MARK:- Actions
    
    @IBAction func fileUpload(_ sender: NSButton) {
        
        do {
            let fileUrl = URL(fileURLWithPath: uploadFilePath ?? "")
            let fileData = try Data(contentsOf: fileUrl)

            service.fileUpload(flatform: flatformType ?? "",
                               registrant: registrantTextField.stringValue,
                               version: versionTextField.stringValue,
                               uploadServer: uploadServerPopup.titleOfSelectedItem?.lowercased() ?? "",
                               appType: self.appType ?? "",
                               revisionHistory: (revisionHistoryTextField.documentView as! NSTextView).string,
                               fileData: fileData) { result in
                result.uploadProgress(closure: { progress in
                    let fraction = Float(progress.fractionCompleted)
                    let uploadValue = String(format: "%.f", fraction * 100)
                    self.uploadProgressbar.doubleValue = Double(uploadValue) ?? 0
                    self.uploadProgressValue.stringValue = "\(uploadValue)%"
                    print("업로드중 \(uploadValue)")
                })
            }
        } catch {
            print("FILE OPTIONAL ERROR")
        }
    }
    
    @IBAction func cancelAction(_ sender: NSButton) {
        detailInfoViewHeight.constant = 0
        uploadProgressValue.stringValue = "0%"
        uploadProgressbar.doubleValue = 0.0
        uploadProgressbar.isHidden = true
        uploadProgressValue.isHidden = true
    }
    
    
}

// MARK:- Methods

extension MainViewController {
    
    private func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = UI.backgroundColor.cgColor
        
        choiceRiderContainer.wantsLayer = true
        choiceRiderContainer.layer?.backgroundColor = .white
        choiceRiderContainer.layer?.cornerRadius = UI.cornerRadiusValue
        
        choiceTitle.wantsLayer = true
        choiceTitle.textColor = .black
        
        choiceDevBackground.wantsLayer = true
        choiceDevBackground.layer?.backgroundColor = UI.environmentColor.cgColor
        choiceDevIPAView.image = NSImage(named: "ipa-file")
        choiceDevIPAView.title = "ipa파일 끌어넣기"
        choiceDevAPKView.image = NSImage(named: "apk-file")
        choiceDevAPKView.title = "apk파일 끌어넣기"
        
        choiceProBackground.wantsLayer = true
        choiceProBackground.layer?.backgroundColor = UI.environmentColor.cgColor
        choiceProIPAView.image = NSImage(named: "ipa-file")
        choiceProIPAView.title = "ipa파일 끌어넣기"
        choiceProAPKView.image = NSImage(named: "apk-file")
        choiceProAPKView.title = "apk파일 끌어넣기"
        
        autoRiderContainer.wantsLayer = true
        autoRiderContainer.layer?.backgroundColor = .white
        autoRiderContainer.layer?.cornerRadius = UI.cornerRadiusValue
        
        autoTitle.wantsLayer = true
        autoTitle.textColor = .black
        
        autoDevBackground.wantsLayer = true
        autoDevBackground.layer?.backgroundColor = UI.environmentColor.cgColor
        autoDevIPAView.image = NSImage(named: "ipa-file")
        autoDevIPAView.title = "ipa파일 끌어넣기"
        autoDevAPKView.image = NSImage(named: "apk-file")
        autoDevAPKView.title = "apk파일 끌어넣기"
        
        autoProBackground.wantsLayer = true
        autoProBackground.layer?.backgroundColor = UI.environmentColor.cgColor
        autoProIPAView.image = NSImage(named: "ipa-file")
        autoProIPAView.title = "ipa파일 끌어넣기"
        autoProAPKView.image = NSImage(named: "apk-file")
        autoProAPKView.title = "apk파일 끌어넣기"
        
        
        // Detail Info
        uploadServerPopup.wantsLayer = true
        uploadServerPopup.removeAllItems()
        uploadServerPopup.addItems(withTitles: ["development","production"])
         
        uploadButton.isEnabled = false
        uploadButton.isHighlighted = true
    }
    
    private func setupDetailInfoView() {
        detailInfoView.wantsLayer = true
        detailInfoView.layer?.backgroundColor = NSColor.clear.cgColor
        detailInfoView.layer?.cornerRadius = UI.cornerRadiusValue
        
        uploadButton.isEnabled = true
        uploadButton.isHighlighted = false
        uploadProgressbar.isHidden = false
        uploadProgressValue.isHidden = false
        
        NSAnimationContext.runAnimationGroup { _ in
            NSAnimationContext.current.duration = 5.0
            detailInfoViewHeight.constant = UI.detailViewHeight
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
    
    @objc private func getDropFileInfo(noti: Notification) {
        
        setupDetailInfoView()

        guard let userInfo = noti.userInfo,
        let filePath = userInfo["FilePath"] as? String,
        let flatform = userInfo["Flatform"] as? String,
        let appType = userInfo["appType"] as? String,
        let appEnvironment = userInfo["appEnvironment"] as? String else { return }
        self.uploadFilePath = filePath
        self.flatformType = flatform
        self.appType = appType
        self.appEnvironment = appEnvironment
        
        self.appType = appType
        uploadServerPopup.selectItem(withTitle: appEnvironment)
        
        if flatform == "ios" {
            extractIpaInfomation(from: filePath)
        }
    }
    
    private func tempUnZipPath(from filePath: String) -> String {
        let fileURLPath = URL(fileURLWithPath: filePath).deletingLastPathComponent()
        let encodingPath = fileURLPath.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let path = encodingPath?.components(separatedBy: "file://").last {
            return path
        }
        return ""
    }
    
    private func extractIpaInfomation(from filePath: String) {
        let fileName: NSString = (filePath as NSString).lastPathComponent as NSString
        let deleteExtensionFileName = fileName.deletingPathExtension
        
        // ipa 파일을 UnZip을 하면 Payload폴더가 생김(정보를 가져올수 있음)
        let unZipPath = tempUnZipPath(from: filePath)
        
        let success: Bool = SSZipArchive.unzipFile(atPath: filePath, toDestination: unZipPath)
        if success {
            print("Success UnZip")
            print("getDropFileInfo :", unZipPath + "Payload/" + "\(deleteExtensionFileName).app/info.plist")
            let plistPath = unZipPath + "Payload/" + "\(deleteExtensionFileName).app/info.plist"
            versionTextField.stringValue = getPlistInfomation(from: plistPath)
            removePayloadDir(from: unZipPath)
        } else {
            print("Fail UnZip")
        }
    }
    
    private func getPlistInfomation(from filePath: String) -> String {
        do {
            let plistData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let result = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any]
            let bundleShortVersion = result?["CFBundleShortVersionString"] as? String ?? ""
            let bundleVersion = result?["CFBundleVersion"] as? String ?? ""
            let version = bundleShortVersion + "(\(bundleVersion))"
            return version
        } catch {
            print("getPlistInfomation Error")
        }
        return ""
    }
    
    private func removePayloadDir(from unZipPath: String) {
        do { try FileManager.default.removeItem(atPath: unZipPath + "Payload") }
        catch { print("getDropFileInfo FileManager Error") }
    }
}
