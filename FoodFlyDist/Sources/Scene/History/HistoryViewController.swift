//
//  HistoryViewController.swift
//  FoodFlyDist
//
//  Created by 승진김 on 24/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

enum Segment: Int {
    case Android = 0
    case iOS
}

class HistoryViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var flatformSegment: NSSegmentedControl!
    
    var historyModel: [HistoryModel] = []
    let service: FFDService = FFDService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        requestRevisionHistory(flatformSegment.selectedSegment)
    }
    
    @IBAction func flatformAction(_ sender: NSSegmentedControl) {
        requestRevisionHistory(sender.selectedSegment)
    }
    
    @IBAction func okAction(_ sender: NSButton) {
        self.dismiss(self)
    }
    
}

//MARK:- Method
extension HistoryViewController {
    
    private func requestRevisionHistory(_ selectedSegment: Int) {
        if selectedSegment == Segment.Android.rawValue {
            service.revisionHistory(flatform: "android") { [weak self] history in
                self?.historyModel = history
                self?.tableView.reloadData()
            }
        } else if selectedSegment == Segment.iOS.rawValue {
            service.revisionHistory(flatform: "ios") { [weak self] history in
                self?.historyModel = history
                self?.tableView.reloadData()
            }
        }
    }
}


//MARK:- TableView DataSource
extension HistoryViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return historyModel.count
    }
}

//MARK:- TableView DataDelegate
extension HistoryViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let versionCell = "VersionCellID"
        static let appTypeCellID = "AppTypeCellID"
        static let environmentCellID = "EnvironmentCellID"
        static let revisionCell = "RevisionCellID"
        static let registrantCellID = "RegistrantCellID"
        static let dateCellID = "DateCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var inputText: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            inputText = historyModel[row].version
            cellIdentifier = CellIdentifiers.versionCell
        } else if tableColumn == tableView.tableColumns[1] {
            inputText = historyModel[row].appType
            cellIdentifier = CellIdentifiers.appTypeCellID
        } else if tableColumn == tableView.tableColumns[2] {
            inputText = historyModel[row].environment
            cellIdentifier = CellIdentifiers.environmentCellID
        } else if tableColumn == tableView.tableColumns[3] {
            inputText = historyModel[row].revisionHistory
            cellIdentifier = CellIdentifiers.revisionCell
        } else if tableColumn == tableView.tableColumns[4] {
            inputText = historyModel[row].registrant
            cellIdentifier = CellIdentifiers.registrantCellID
        } else if tableColumn == tableView.tableColumns[5] {
            inputText = historyModel[row].updatedAt
            cellIdentifier = CellIdentifiers.dateCellID
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            
            cell.textField?.stringValue = inputText
            return cell
        }
        
        return nil
    }
}
