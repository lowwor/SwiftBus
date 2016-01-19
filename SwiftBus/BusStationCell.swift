//
//  BusStationCell.swift
//  SwiftBus
//
//  Created by ChenCheung Kit on 16/1/16.
//  Copyright © 2016年 ChenCheung Kit. All rights reserved.
//

import UIKit

class BusStationCell: UITableViewCell {
    
    
   
    @IBOutlet weak var stationNameLabel: UILabel!

    @IBOutlet weak var numLabel: UILabel!
    
    var busNum = 0{
        didSet{
            updateCell()
        }
    }
    var busStation:BusStation?{
        didSet{
            updateCell()
        }
    }
    
    func updateCell(){
       
            if busNum == 0 {
                numLabel.hidden = true
            }else{
                numLabel.hidden = false
                numLabel.text = String(busNum)
                
            }
        
        
        
        if let busStationToShow = busStation {
//            print("updateCell \(busStationToShow.name)")
            stationNameLabel.text = busStationToShow.name
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateCell()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
