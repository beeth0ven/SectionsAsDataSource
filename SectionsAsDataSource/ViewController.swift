//
//  ViewController.swift
//  SectionsAsDataSource
//
//  Created by luojie on 16/1/16.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            dataSourceAndDelegate.tableView = tableView
        }
    }
    
    var dataSourceAndDelegate = DataSourceAndDelegate<SectionInfo, CellInfo>()
    
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

