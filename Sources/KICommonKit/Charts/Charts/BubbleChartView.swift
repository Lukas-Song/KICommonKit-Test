//
//  BubbleChartView.swift
//  Charts
//
//  Bubble chart implementation:
//    Copyright 2015 Pierre-Marc Airoldi
//    Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@available(iOS 13.0, *)
open class BubbleChartView: BarLineChartViewBase, BubbleChartDataProvider
{
    open override func initialize()
    {
        super.initialize()
        
        renderer = BubbleChartRenderer(dataProvider: self, animator: chartAnimator, viewPortHandler: viewPortHandler)
    }
    
    // MARK: - BubbleChartDataProvider
    
    open var bubbleData: BubbleChartData? { return data as? BubbleChartData }
}
