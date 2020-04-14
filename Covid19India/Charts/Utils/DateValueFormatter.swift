//
//  LineChartTimeViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
////  Copyright © 2017 jc. All rights reserved.

import Foundation

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}