//
//  HistoryViewController.swift
//  FoodFlyDist
//
//  Created by 승진김 on 24/05/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import Cocoa

class HistoryViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension HistoryViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return 3
    }
}

extension HistoryViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let versionCell = "VersionCellID"
        static let revisionCell = "RevisionCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = CellIdentifiers.versionCell
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = CellIdentifiers.revisionCell
        }
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            
            cell.textField?.stringValue = "aldfkjlalksdfj;lakjdf;lkjdsfa\n"
            
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 200
    }
}
