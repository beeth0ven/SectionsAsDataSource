//
//  ModelTableViewCell.swift
//  Education
//
//  Created by luojie on 16/1/11.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit

class ModelTableViewCell: UITableViewCell, UIUpatable {
    var model: Any! { didSet { updateUI() } }
    func updateUI() {}
}

///  可刷新页面的能力
protocol UIUpatable {
    func updateUI()
}