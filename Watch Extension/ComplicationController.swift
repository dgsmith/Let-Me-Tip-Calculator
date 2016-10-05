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
        
        if let template = getTemplate(forFamily: complication.family) {
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
        } else {
            handler(nil)
        }
        
    }

    
    public func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(getTemplate(forFamily: complication.family))
    }

    func getTemplate(forFamily family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        switch family {
        case .modularSmall:
            let modular = CLKComplicationTemplateModularSmallSimpleImage()
            modular.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Modular"))
            modular.tintColor = #colorLiteral(red: 0.1725490196, green: 0.6, blue: 0.8274509804, alpha: 1)
            return modular
        case .utilitarianSmall:
            let utilitarian = CLKComplicationTemplateUtilitarianSmallSquare()
            utilitarian.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Utilitarian"))
            utilitarian.tintColor = #colorLiteral(red: 0.1725490196, green: 0.6, blue: 0.8274509804, alpha: 1)
            return utilitarian
        case .circularSmall:
            let circular = CLKComplicationTemplateCircularSmallSimpleImage()
            circular.imageProvider = CLKImageProvider(onePieceImage: #imageLiteral(resourceName: "Complication/Circular"))
            circular.tintColor = #colorLiteral(red: 0.1725490196, green: 0.6, blue: 0.8274509804, alpha: 1)
            return circular
        default:
            return nil
        }
    }
    
}
