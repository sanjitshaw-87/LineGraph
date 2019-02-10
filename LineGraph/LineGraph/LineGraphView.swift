//
//  LineGraphView.swift
//  LineGraph
//
//  Created by Sanjit Shaw on 06/12/18.
//  Copyright © 2018 Sanjit Shaw. All rights reserved.
//

import UIKit

struct UnitData
{
    var date : Date? = nil
    var displayDate : String? = nil
    var displayValue : String? = ""
    var actualValue : Float = 0.0
    var isHighlightRequired : Bool = false
}



let horizontalPadding : CGFloat = 5.0
let verticalPadding : CGFloat = 5.0
let labelDisplayHeight : CGFloat = 25.0
let baseBarHeight : CGFloat = 2.0
let barHeight : CGFloat = 5.0


class LineGraphView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        super.draw(rect)
        self.clipsToBounds = true
    }

    
    func drawWeeklyGraph(weeklyParamList : Array<UnitData>)
    {
        /*let pageSize : Int = 5
        var insertIndex : Int = pageSize - 1
        var pageList : [UnitData] = []
        
        for weeklyData in weeklyParamList.reversed()
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
        }*/
        
        plotGraphpoints(pageList: weeklyParamList)
    }
    
    func moveToPreviousPage()
    {
        
    }
    
    func moveToNextPage()
    {
        
    }
    
    private func plotGraphpoints(pageList : Array<UnitData>)
    {
        let yPos = self.frame.size.height - verticalPadding - labelDisplayHeight
        let barWidth = self.frame.size.width - (2 * horizontalPadding)
        
        let beizerLine = UIBezierPath(rect: CGRect(x: horizontalPadding, y: yPos, width: barWidth, height: baseBarHeight))
        let baseShapeLayer = CAShapeLayer()
        baseShapeLayer.path = beizerLine.cgPath
        baseShapeLayer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(baseShapeLayer)
        
        let eachColumnWidth : CGFloat = barWidth/CGFloat(pageList.count)
        var startX = horizontalPadding
        
        let graphVerticalArea : CGFloat = self.frame.size.height - verticalPadding - labelDisplayHeight
        let eachRowHeight : CGFloat = graphVerticalArea / 11
        var listOfPoints : [CGPoint] = []
        
        drawHorizontalDivisionLine(graphVerticalArea: graphVerticalArea, eachRowHeight: eachRowHeight)
        
        for eachUnit in pageList
        {
            let barLayer = CAShapeLayer()
            let barBeizer = UIBezierPath(rect: CGRect(x: startX, y: yPos + 2.0, width: 2.0, height: barHeight))
            barLayer.path = barBeizer.cgPath
            barLayer.fillColor = UIColor.black.cgColor
            self.layer.addSublayer(barLayer)
            //Bottom black bar
            
            if eachUnit.isHighlightRequired
            {
                let verticalBarLayer = CAShapeLayer()
                let verticalBarBeizer = UIBezierPath(rect: CGRect(x: startX + 1, y: 0.0, width: eachColumnWidth, height: graphVerticalArea))
                verticalBarLayer.path = verticalBarBeizer.cgPath
                verticalBarLayer.lineWidth = 0.5
                verticalBarLayer.fillColor = UIColor.clear.cgColor
                verticalBarLayer.strokeColor = UIColor.black.cgColor
                self.layer.addSublayer(verticalBarLayer)
                //Boundary line for each column
            }
            
            
            let dateDisplayLbl = UILabel(frame: CGRect(x: startX + 2.0, y: yPos + 2.0, width: eachColumnWidth - 4.0, height: labelDisplayHeight))
            dateDisplayLbl.backgroundColor = UIColor.clear
            dateDisplayLbl.text = eachUnit.displayDate
            dateDisplayLbl.textColor = UIColor.white
            self.addSubview(dateDisplayLbl)
            dateDisplayLbl.textAlignment = .center
            dateDisplayLbl.font = UIFont.systemFont(ofSize: 12.0)
            //Bottom date display label
            
            var pointXpos : CGFloat = 0.0
            pointXpos = startX + (eachColumnWidth / 2)
            
            var pointYpos : CGFloat = 0.0
            pointYpos = CGFloat((eachUnit.actualValue / 110)) * graphVerticalArea
            pointYpos = graphVerticalArea - pointYpos
            
            let plottingPoint : CGPoint = CGPoint(x: pointXpos, y: pointYpos)
            listOfPoints.append(plottingPoint)
            
            startX += eachColumnWidth
        }
        
        joinGraphPoints(listOfPoints: listOfPoints)
        
        var index : Int = 0
        for plottingPoint in listOfPoints
        {
            plotWeeklyPoints(position: plottingPoint, with: pageList[index])
            
            index += 1
        }
        
        
        let barLayer = CAShapeLayer()
        let barBeizer = UIBezierPath(rect: CGRect(x: startX - 2.0, y: yPos + 2.0, width: 2.0, height: barHeight))
        barLayer.path = barBeizer.cgPath
        barLayer.fillColor = UIColor.black.cgColor
        self.layer.addSublayer(barLayer) // at the end an extra line need to draw
    }
    
    
    private func drawHorizontalDivisionLine(graphVerticalArea : CGFloat, eachRowHeight : CGFloat)
    {
        //let graphVerticalArea = self.frame.size.height - verticalPadding - labelDisplayHeight
        //let eachRowHeight : CGFloat = graphVerticalArea / 11
        var yPos : CGFloat = eachRowHeight
        
        let barWidth = self.frame.size.width - (2 * horizontalPadding)
        let startX = horizontalPadding
        
        
        for _ in 1...10
        {
            let barLayer = CAShapeLayer()
            let barBeizer = UIBezierPath(rect: CGRect(x: startX, y: yPos, width: barWidth, height: 0.5))
            barLayer.path = barBeizer.cgPath
            barLayer.fillColor = UIColor.black.cgColor
            self.layer.addSublayer(barLayer)
            
            yPos += eachRowHeight
        }
    }
    
    func plotWeeklyPoints(position : CGPoint, with dataModel : UnitData)
    {
        let circularLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: position, radius: 6.0, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        circularLayer.path = circularPath.cgPath
        circularLayer.fillColor = UIColor.blue.cgColor
        self.layer.addSublayer(circularLayer)
        
        let textLayer = CATextLayer()
        textLayer.string = dataModel.displayValue
        circularLayer.addSublayer(textLayer)
        //lineLayer.mask = textLayer
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.frame = CGRect(x: position.x - 8.0, y: position.y - 5.0, width: 16.0, height: 16.0)
        textLayer.isWrapped = false
        textLayer.alignmentMode = .center
        textLayer.fontSize = 8.0
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.rasterizationScale = UIScreen.main.scale
        textLayer.font = UIFont.boldSystemFont(ofSize: 8.0)
        textLayer.display()
    }
    
    func joinGraphPoints(listOfPoints : Array<CGPoint>)
    {
        var index : Int = 0
        
        let lineBeizer = UIBezierPath()
        let lineLayer = CAShapeLayer()
        
        for eachPoint in listOfPoints
        {
            if index == 0
            {
                lineBeizer.move(to: eachPoint)
            }
            else
            {
                lineBeizer.addLine(to: eachPoint)
            }
            
            index += 1
        }
        
        lineLayer.path = lineBeizer.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.blue.cgColor
        //lineLayer.masksToBounds = true
        self.layer.addSublayer(lineLayer)
        
        
    }

}
