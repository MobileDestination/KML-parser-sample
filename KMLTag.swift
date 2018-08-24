//
//  KMLTag.swift
//
//  Created by Sergey Blazhko on 1/17/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

enum KMLTag: String {

    //containers
    case Folder
    case Document
    
    //features
    case Placemark

    //geometry
    case MultiGeometry
    case Polygon
    case LineString
    case Point

    //style
    case Style
    case PolyStyle
    case LineStyle
    case IconStyle
    case BalloonStyle
    
    case Icon
    
    var toString: String {
        return rawValue
    }
    
    static var allContainerTags: Set<KMLTag> {
        return Set.init(arrayLiteral: .Folder, .Document)
    }
    
    static var allFeatureTags: Set<KMLTag> {
        return Set.init(arrayLiteral:.Placemark)
    }

    static var allGeometryTags: Set<KMLTag> {
        return Set.init(arrayLiteral:.MultiGeometry, .Polygon, .LineString, .Point)
    }

    static var allStyleTags: Set<KMLTag> {
        return Set.init(arrayLiteral: .Style, .PolyStyle,
                        .LineStyle, .IconStyle, .BalloonStyle, .Icon)
    }

}

extension KMLTag {
    var toKMLElementType: KMLElement.Type {
        switch self {
            //container
            case .Folder:
                return KMLElement.self
            case .Document:
                return KMLDocument.self
            
            //feature
            case .Placemark:
                return KMLPlacemark.self
            
            //geometry
            case .MultiGeometry:
                return KMLMultiGeometry.self
            case .Polygon:
                return KMLPolygon.self
            case .LineString:
                return KMLLineString.self
            case .Point:
                return KMLPoint.self
            
            //style
            case .Style:
                return KMLStyle.self
            case .PolyStyle:
                return KMLPolyStyle.self
            case .LineStyle:
                return KMLLineStyle.self
            case .IconStyle:
                return KMLIconStyle.self
            case .BalloonStyle:
                return KMLBalloonStyle.self
            
            case .Icon:
                return KMLIcon.self
        }
    }
}

