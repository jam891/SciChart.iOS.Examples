//
//  SCSECGChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSECGChartView: SCSBaseChartView {
    
    var newData: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .fifo)
    var oldData: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .fifo)
    let sourceData: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
    
    var timer: Timer!
    var currentIndex: Int32 = 0
    var totalCount = 0.0
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
        newData.fifoCapacity = 1500
        oldData.fifoCapacity = 1500
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.04,
                                                           target: self,
                                                           selector: #selector(SCSECGChartView.updateECGData),
                                                           userInfo: nil,
                                                           repeats: true)
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer.invalidate()
        }
    }
    
    // MARK: Internal Function
    
    func updateECGData() {
        var i = 0
        while i < 10 {
            appendPoint(400)
            i += 1
        }
        
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(4.5))
        xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(-400), max: SCIGeneric(1200))
        
        yAxes.add(yAxis)

    }
    
    fileprivate func addDataSeries() {
        SCSDataManager.loadData(into: sourceData, from: "WaveformData")
        
        let wave1 = SCIFastLineRenderableSeries()
        wave1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFb3e8f6, withThickness: 1)
        wave1.dataSeries = newData
        renderableSeries.add(wave1)
        
        let wave2 = SCIFastLineRenderableSeries()
        wave2.strokeStyle = SCISolidPenStyle(colorCode: 0xFFb3e8f6, withThickness: 1)
        wave2.dataSeries = oldData
        renderableSeries.add(wave2)
        
        invalidateElement()
    }
    
    fileprivate func appendPoint(_ point: Double) {
        if currentIndex >= 1800 {
            currentIndex = 0
            let swap = oldData
            oldData = newData
            newData = swap
            totalCount = 0
        }
        
        let voltage = SCIGenericFloat(sourceData.yValues().value(at: currentIndex))*1000
        let time = totalCount / point
        newData.appendX(SCIGeneric(time), y: SCIGeneric(voltage))
        oldData.appendX(SCIGeneric(time), y: SCIGeneric(Double.nan))
        invalidateElement()
        currentIndex += 1
        totalCount += 1
    }
    
}
