//
//  DataSourceAndDelegate.swift
//  SectionsAsDataSource
//
//  Created by luojie on 16/1/29.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

/**
 Turn UITableView delegate based API to block based API, Usage:
 ```swift
class ViewController: UIViewController {
 
    var dataSourceAndDelegate = DataSourceAndDelegate<SectionInfo, CellInfo>()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            dataSourceAndDelegate.tableView = tableView
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSourceAndDelegate()
        refreshData()
    }
    
    func setupDataSourceAndDelegate() {
        
        dataSourceAndDelegate.reuseIdentifierForCellInfo = {
            cellInfo in
            return "cell"
        }
        
        dataSourceAndDelegate.configureCellForCellInfo = {
            cell, cellInfo in
            cell.textLabel?.text = cellInfo.rawValue
        }
        
        dataSourceAndDelegate.titleForSectionInfo = {
            sectionInfo in
            return sectionInfo.rawValue
        }
        
        dataSourceAndDelegate.didSelectCellInfo = {
            cellInfo in
            print("did Select: \(cellInfo.rawValue)")
        }
    }
    
    func refreshData() {
        dataSourceAndDelegate.sections = [
            Section(sectionInfo: .OverView, cellInfos: [.Name, .Detail, .Time]),
            Section(sectionInfo: .Author,   cellInfos: [.AuthorName, .AuthorImage, .AuthorAge]),
            Section(sectionInfo: .Footer,   cellInfos: [.LikeNumber, .FollowNumer, .Time]),
        ]
    }
    
    enum SectionInfo: String {
        case OverView
        case Author
        case Footer
    }
    
    enum CellInfo: String {
        case Name
        case Detail
        case Time
        
        case AuthorName
        case AuthorImage
        case AuthorAge
        
        case LikeNumber
        case FollowNumer
    }
}
 
 ```
 */

class DataSourceAndDelegate<SectionInfo, CellInfo>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var sections: [Section<SectionInfo, CellInfo>] = [] { didSet { tableView.reloadData() } }
    
    weak var tableView: UITableView! { didSet { tableView.dataSource = self; tableView.delegate = self } }
    
    var reuseIdentifierForCellInfo:     ((CellInfo) -> String)!
    var configureCellForCellInfo:       ((UITableViewCell, CellInfo) -> Void)?
    var titleForSectionInfo:            ((SectionInfo) -> String?)?
    var didSelectCellInfo:              ((CellInfo) -> Void)?
    var viewForHeaderForSectionInfo:    ((SectionInfo) -> UIView?)?
    var scrollViewDidScroll:            ((UIScrollView) -> Void)?
    var scrollViewDidEndDecelerating:   ((UIScrollView) -> Void)?
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellInfos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellInfo = cellInfoAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierForCellInfo(cellInfo))!
        configureCellForCellInfo?(cell, cellInfo)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForSectionInfo?(sections[section].sectionInfo)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderForSectionInfo?(sections[section].sectionInfo)
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cellInfo = cellInfoAtIndexPath(indexPath)
        didSelectCellInfo?(cellInfo)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndDecelerating?(scrollView)
    }
    
    // Helper
    func cellInfoAtIndexPath(indexPath: NSIndexPath) -> CellInfo {
        return sections[indexPath.section].cellInfos[indexPath.item]
    }
}

// Provide Struct For Each Section
struct Section<SectionInfo, CellInfo> {
    var sectionInfo: SectionInfo
    var cellInfos:  [CellInfo]
    
    subscript(index: Int) -> CellInfo {
        get { return cellInfos[index] }
        set { cellInfos[index] = newValue }
    }
}
