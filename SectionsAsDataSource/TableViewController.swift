//
//  ViewController.swift
//  SectionsAsDataSource
//
//  Created by luojie on 15/12/31.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, SectionsAsDataSource {
    
    typealias V = UITableView

    var sections: [Section<SectionInfo, CellInfo>] = []
    
    var sectionStruct: [(section: SectionInfo, cells: [CellInfo])] {
        return [
            (.OverView, [
                .Name,
                .Detail,
                .Time
                ]
            ),
            (.Author, [
                .AuthorName,
                .AuthorImage,
                .AuthorAge
                ]
            ),
            (.Footer, [
                .LikeNumber,
                .FollowNumer,
                ]
            )
        ]
    }
    
    enum SectionInfo: String {
        case OverView
        case Author
        case Footer
    }
    
    enum CellInfo: String, ReusableCell {
        case Name
        case Detail
        case Time
        
        case AuthorName
        case AuthorImage
        case AuthorAge
        
        case LikeNumber
        case FollowNumer
        
        var cellReuseIdentifer: String {
            return "cell"
        }
    }
}

extension TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCellInfosInSection(section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return collectionTypeView(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func configCell(cell: UITableViewCell, withCellInfo cellInfo: CellInfo) {
        cell.textLabel?.text = cellInfo.rawValue
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionInfo.rawValue
    }
}

