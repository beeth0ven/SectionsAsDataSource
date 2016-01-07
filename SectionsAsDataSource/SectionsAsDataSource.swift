//
//  SectionsAsDataSource.swift
//  Test
//
//  Created by luojie on 15/12/11.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

/// Provide Data Source to CollectionTypeView
protocol SectionsAsDataSource: class {
    typealias SectionInfo
    typealias CellInfo: ReusableCell
    typealias CollectionTypeView: CollectionTypeViewTrait // UITableView or UICollectionView
    
    var collectionTypeView: CollectionTypeView! { get }
    var sections: [Section<SectionInfo, CellInfo>] { get set }  // Provide Data Source to CollectionTypeView
    var sectionStruct: [(section: SectionInfo, cells: [CellInfo])] { get }  // Minimal Struct For CollectionTypeView
    func configCell(cell: CollectionTypeView.Cell, withCellInfo cellInfo: CellInfo) // Map CellInfo to CollectionTypeView.Cell
}

extension SectionsAsDataSource {
    // Map sectionStruct to sections
    func setupSections() {
        sections = sectionStruct.map { Section(sectionInfo: $0.section, cellInfos: $0.cells) }
        collectionTypeView.reloadData()
    }
    
    // Provide Data Source to CollectionTypeView
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfCellInfosInSection(section: Int) -> Int {
        return sections[section].cellInfos.count
    }
    
    func collectionTypeView(collectionTypeView: CollectionTypeView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CollectionTypeView.Cell {
        let cellInfo = cellInfoAtIndexPath(indexPath)
        let cell = collectionTypeView.dequeueReusableCellWithIdentifier(cellInfo.cellReuseIdentifer, forIndexPath: indexPath)
        configCell(cell, withCellInfo: cellInfo)
        return cell
    }
    
    // Helper
    func cellInfoAtIndexPath(indexPath: NSIndexPath) -> CellInfo {
        return sections[indexPath.section].cellInfos[indexPath.item]
    }
}

// Extension UITableViewController or UICollectionViewController to support SectionsAsDataSource‘s some areas.
extension UITableViewController {
    typealias CollectionTypeView = UITableView
    var collectionTypeView: UITableView! { return tableView }
}

extension UICollectionViewController {
    typealias CollectionTypeView = UICollectionView
    var collectionTypeView: UICollectionView! { return collectionView }
}

// For Cell Info
protocol ReusableCell {
    var cellReuseIdentifer: String { get }
}

// Provide Struct For Each Section
struct Section<SectionInfo, CellInfo> {
    var sectionInfo: SectionInfo
    var cellInfos:  [CellInfo]
}

/// Treat Table View Or Collection View as One Type
protocol CollectionTypeViewTrait {
    typealias Cell
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> Cell
    func reloadData()
}

extension UITableView: CollectionTypeViewTrait {}
extension UICollectionView: CollectionTypeViewTrait {
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
}
