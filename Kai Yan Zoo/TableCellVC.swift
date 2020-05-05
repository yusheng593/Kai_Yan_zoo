//
//  TableCellVC.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/3/10.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import UIKit

class TableCellVC: UITableViewCell {

    @IBOutlet weak var lbAnimalName: UILabel!
    @IBOutlet weak var imgAnimal: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
