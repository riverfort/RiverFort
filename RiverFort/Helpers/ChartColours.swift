//
//  ChartColours.swift
//  RiverFort
//
//  Created by Qiuyang Nie on 09/04/2021.
//

import Foundation
import UIKit

struct ChartColours {
    
    static func getPriceLineFillColour() -> CGGradient {
        let gradientColors = [UIColor(rgb: 0x003399).cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0]                                                                                     // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        return gradient!
    }
    
    static func getADTV20LineFillColour() -> CGGradient {
        let gradientColors = [UIColor(rgb: 0x400080).cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0]                                                                                     // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        return gradient!
    }
    
    static func getADTV60LineFillColour() -> CGGradient {
//        let gradientColors = [UIColor(rgb: 0xbf80ff).cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let gradientColors = [UIColor.yellowSea.cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0]                                                                                     // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        return gradient!
    }
    
    static func getDarkSharePriceLineFillColour() -> CGGradient {
        let gradientColors = [UIColor(rgb: 0xffffff).cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0]                                                                                     // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        return gradient!
    }
    
    static func getLightSharePriceLineFillColour() -> CGGradient {
        let gradientColors = [UIColor(rgb: 0x000000).cgColor, UIColor.clear.cgColor] as CFArray                                       // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0]                                                                                     // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        return gradient!
    }
}
