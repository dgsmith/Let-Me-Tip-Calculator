//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by Grayson Smith on 8/4/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    public func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        switch complication.style {
            
        default:
            break
        }
        
    }

    
    public func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }

    
}
