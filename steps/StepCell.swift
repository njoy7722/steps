//
//  StepCell.swift
//  steps
//
//  Created by Parag Pardeshi on 7/11/20.
//  Copyright © 2020 Parag Pardeshi. All rights reserved.
//

import UIKit

class StepCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(date : Date, step : Int) {
        // format date to display as string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        dateLabel.text = String(dateString)
        stepsLabel.text = String(step)
    }

}
