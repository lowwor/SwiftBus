//
//  ViewController.swift
//  SwiftBus
//
//  Created by ChenCheung Kit on 16/1/9.
//  Copyright © 2016年 ChenCheung Kit. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import Alamofire
import RxCocoa


class ViewController:  UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var lineNameTextField: UITextField!
    
    @IBOutlet weak var switchDirectionButton: UIButton!
    @IBOutlet weak var autoRefreshSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var busStationTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel = BusLineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busStationTableView.delegate = self
        busStationTableView.dataSource = self
        
//        lineNameTextField.becomeFirstResponder()
        searchButton.rx_tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribeNext({ () -> Void in
                self.viewModel.searchText = self.lineNameTextField.text})
            .addDisposableTo(disposeBag)
        
        switchDirectionButton.rx_tap
            .subscribeNext({ () -> Void in
                self.viewModel.direction = !self.viewModel.direction})
            .addDisposableTo(disposeBag)
        
        autoRefreshSwitch.rx_value.subscribeNext { (isOn) -> Void in
            if(isOn){
                self.viewModel.autoRefreshBus()
            }else{
                self.viewModel.cancelAutoRefreshBus()
            }
        }.addDisposableTo(disposeBag)
        
        viewModel.tableViewStations.subscribeNext { stations in
//            print(stations)
            self.tableViewStations = stations
            self.busStationTableView.reloadData()
        }
        viewModel.tableViewBuses.subscribeNext { buses in
            print(buses)
            self.tableViewBuses = buses
            self.busStationTableView.reloadData()
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
//        if textField == lineNameTextField{
//           lineNameTextField.resignFirstResponder()
//            return true
//
//        }
        return true
    }
    
    //MARK: Table view data source
    
    var tableViewStations:[BusStation]?
    var tableViewBuses:[Bus]?

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewStations == nil ? 0 : tableViewStations!.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("busStationCell", forIndexPath: indexPath) as? BusStationCell
        var busNum = 0
        if let buses = tableViewBuses{
            for bus in buses{
                if (bus.currentStation == tableViewStations![indexPath.row].name){
                    busNum += 1
                }
            }
          
        }
        cell!.busNum = tableViewBuses == nil ? 0 : busNum
        cell!.busStation = tableViewStations == nil ? nil : tableViewStations![indexPath.row]

        return cell!
    }
}

