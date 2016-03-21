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
            dataSource.tableView = tableView
        }
    }
    
    var dataSource = DataSource<SectionInfo, CellInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        refreshData()
    }
    
    func setupDataSource() {

        dataSource.reuseIdentifierForCellStyle = {
            cellStyle in
            return "cell"
        }
        
        dataSource.configureCellForCellStyle = {
            cell, cellStyle in
            cell.textLabel?.text = cellStyle.rawValue
        }
        
        dataSource.titleForSectionStyle = {
            sectionInfo in
            return sectionInfo.rawValue
        }
        
        dataSource.didSelectCellStyle = {
            cellStyle in
            print("did Select: \(cellStyle.rawValue)")
        }
    }
    
    func refreshData() {
        dataSource.sections = [
            Section(sectionStyle: .OverView, cellStyles: [.Name, .Detail, .Time]),
            Section(sectionStyle: .Author,   cellStyles: [.AuthorName, .AuthorImage, .AuthorAge]),
            Section(sectionStyle: .Footer,   cellStyles: [.LikeNumber, .FollowNumer, .Time]),
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

