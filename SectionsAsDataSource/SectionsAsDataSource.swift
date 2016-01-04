//
//  SectionsAsDataSource.swift
//  Test
//
//  Created by luojie on 15/12/11.
//  Copyright © 2015年 LuoJie. All rights reserved.
//

import UIKit

protocol SectionsAsDataSource: class {
    typealias SectionInfo
    typealias CellInfo: ReusableCell
    typealias V: ReusableCellProvider
    typealias CL
    
    var sections: [Section<SectionInfo, CellInfo>] { get set }
    var sectionStruct: [(section: SectionInfo, cells: [CellInfo])] { get }
    func configCell(cell: CL, withCellInfo cellInfo: CellInfo)
}

extension SectionsAsDataSource {
    func setupSections() {
        sections = sectionStruct.map { Section(sectionInfo: $0.section, cellInfos: $0.cells) }
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfCellInfosInSection(section: Int) -> Int {
        return sections[section].cellInfos.count
    }
    
    func collectionTypeView(view: V, cellForRowAtIndexPath indexPath: NSIndexPath) -> CL {
        let cellInfo = cellInfoAtIndexPath(indexPath)
        let cell = view.dequeueReusableCellWithIdentifier(cellInfo.cellReuseIdentifer, forIndexPath: indexPath) as! CL
        configCell(cell, withCellInfo: cellInfo)
        return cell
    }
    
    func cellInfoAtIndexPath(indexPath: NSIndexPath) -> CellInfo {
        return sections[indexPath.section].cellInfos[indexPath.item]
    }
}

protocol SectionInfoEnum { }
protocol ReusableCell {
    var cellReuseIdentifer: String { get }
}

struct Section<S, C> {
    var sectionInfo: S
    var cellInfos:  [C]
}


protocol ReusableCellProvider {
    typealias T
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> T
}

extension UITableView: ReusableCellProvider {}
extension UICollectionView: ReusableCellProvider {
    func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
}
