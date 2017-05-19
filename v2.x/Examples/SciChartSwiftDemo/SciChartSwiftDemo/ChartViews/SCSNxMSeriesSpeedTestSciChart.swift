//
//  SCSNxMSeriesSpeedTestSciChart.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSNxMSeriesSpeedTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSRandomWalkGenerator()
    
//    var delegate: SCSDrawingProtocolDelegate?
//    var chartProviderName: String = "SciChart"
    
    var parameters: SCSTestParameters!
    var rangeMin = Double.nan
    var rangeMax = Double.nan
    var updateNumber = 0
    
    // MARK: SpeedTestProtocol
    
    override func run(_ testParameters: SCSTestParameters) {
        parameters = testParameters
        addSeries()
        addAxes()
        addDefaultModifiers()
    }
    
    override func updateChart() {
        
        if let delegate = delegate {
            delegate.chartExampleStarted()
        }
        
        if rangeMin.isNaN {
            rangeMin = SCIGenericDouble(yAxes.item(at: 0).visibleRange.min)
            rangeMax = SCIGenericDouble(yAxes.item(at: 0).visibleRange.max)
        }
        
        let scaleFactor = fabs(sin(Double(updateNumber)*0.1)) + 0.5
        
        if let yAxis = yAxes[0] {
            yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(rangeMin * scaleFactor),
                                                 max: SCIGeneric(rangeMax * scaleFactor))
        }
        
        invalidateElement()
        updateNumber += 1
        
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let axisX = SCINumericAxis()
        axisX.autoRange = .once
        xAxes.add(axisX)
        
        let axisY = SCINumericAxis()
        axisY.autoRange = .once
        yAxes.add(axisY)
    }
    
    fileprivate func addSeries() {
        var color: UInt32 = 0xFF0F0505
        var series: Int32 = 0
        while series < Int32(parameters.seriesNumber) {
            
            let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
            dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
            let randomData: [[Double]] = randomWalkGenerator.getRandomWalkSeries(parameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
            
            var i: Int = 0
            while i < parameters.pointCount {
                
                let x = randomData[0][i]
                let y = randomData[1][i]
                
                dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
                
                i += 1
            }
            
            
            let renderSeries = SCIFastLineRenderableSeries()
            renderSeries.dataSeries = dataSeries
            renderSeries.strokeStyle = SCISolidPenStyle(colorCode: color, withThickness: 0.5)
            
            renderableSeries.add(renderSeries)
            
            color = color + 0x00000101;
            
            series += 1
            
        }
        
        invalidateElement()
        
    }
    
    override func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
    
}

