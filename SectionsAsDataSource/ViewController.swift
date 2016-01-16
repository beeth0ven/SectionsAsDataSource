//
//  ViewController.swift
//  SectionsAsDataSource
//
//  Created by luojie on 16/1/16.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! { didSet { dataSourceAndDelegate.tableView = tableView } }
    
    var dataSourceAndDelegate = DataSourceAndDelegate<SectionInfo, CellInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSourceAndDelegate()
    }
    
    func setupDataSourceAndDelegate() {
        dataSourceAndDelegate.sections = [
            (.OverView, [
                .Name,
                .Detail,
                .Time]),
            (.Author, [
                .AuthorName,
                .AuthorImage,
                .AuthorAge]),
            (.Footer, [
                .LikeNumber,
                .FollowNumer])
        ]
        
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

class DataSourceAndDelegate<SectionInfo, CellInfo>: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var sections: [(sectionInfo: SectionInfo, cellInfos: [CellInfo])] = [] { didSet { tableView.reloadData() } }
    
    weak var tableView: UITableView! { didSet { tableView.dataSource = self; tableView.delegate = self } }
    
    var reuseIdentifierForCellInfo: ((CellInfo) -> String)!
    var configureCellForCellInfo: ((UITableViewCell, CellInfo) -> Void)?
    var titleForSectionInfo: ((SectionInfo) -> String?)?
    var didSelectCellInfo: ((CellInfo) -> Void)?
    
    
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
    
    // Helper
    func cellInfoAtIndexPath(indexPath: NSIndexPath) -> CellInfo {
        return sections[indexPath.section].cellInfos[indexPath.item]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cellInfo = cellInfoAtIndexPath(indexPath)
        didSelectCellInfo?(cellInfo)
    }
}

