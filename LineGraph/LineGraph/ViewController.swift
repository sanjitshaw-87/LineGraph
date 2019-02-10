//
//  ViewController.swift
//  LineGraph
//
//  Created by Sanjit Shaw on 06/12/18.
//  Copyright © 2018 Sanjit Shaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var graphView: LineGraphView!
    lazy var dataList : Array<UnitData> = Array()
    lazy var pageList : [UnitData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let list = [[97, 40, 40, 72, 25],[97, 40, 40, 72, 25]]
        
        let list = [97, 40, 40, 72, 25, 7, 50, 20, 52, 75]
        var startingIndex : Int = 0
        var dataLength : Int = 5
        
        for item in startingIndex..<dataLength
        {
            //print(item)
            //print(list[item])
        }
        
        startingIndex += 1
        dataLength += 1
        for item in startingIndex..<dataLength
        {
            //print(item)
            //print(list[item])
        }
        
        var indexValue : Int = 0
        for index in list
        {
            var eachUnitData = UnitData()
            eachUnitData.displayDate = "1/12/18"
            eachUnitData.displayValue = String(index)
            eachUnitData.actualValue = Float(index)
            if indexValue == 7
            {
                eachUnitData.isHighlightRequired = true
            }
            dataList.append(eachUnitData)
            indexValue += 1
        }
        
        manipulatePageData()
        
    }
    
    func manipulatePageData()
    {
        let pageSize : Int = 5
        var insertIndex : Int = pageSize - 1
        //var pageList : [UnitData] = []
        
        for weeklyData in dataList.reversed()
        {
            if insertIndex >= 0
            {
                if pageList.count == 0
                {
                    pageList.append(weeklyData)
                }
                else
                {
                    pageList.insert(weeklyData, at: 0)
                }
                
                insertIndex -= 1
            }
            else
            {
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        graphView.drawWeeklyGraph(weeklyParamList: pageList)
    }


}

