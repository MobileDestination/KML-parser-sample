//
//  KMLGeometry.swift
//
//  Created by Sergey Blazhko on 1/18/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import CoreLocation

import AEXML

class KMLMultiGeometry: KMLElement {
    override lazy var allovedChildrenTags: Set<String>? = {
        return [KMLTag.Point.toString,
                KMLTag.LineString.toString,
                KMLTag.Polygon.toString]
    }()
    
    var points: [KMLPoint]?
    var polygons: [KMLPolygon]?
    var lineStrings: [KMLLineString]?
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        
        for element in element.children {
            switch KMLTag(rawValue: element.name) {
            case KMLTag.Point?:
                if points == nil {
                    points = []
                }
                points?.append(KMLPoint.init(element))
           
            case KMLTag.Polygon?:
                if polygons == nil {
                    polygons = []
                }
                polygons?.append(KMLPolygon.init(element))
            
            case KMLTag.LineString?:
                if lineStrings == nil {
                    lineStrings = []
                }
                lineStrings?.append(KMLLineString.init(element))

            default: break
            }
        }
    }
}

class KMLPolygon: KMLElement {
    
    var outerBoundaryCoordinates: [CLLocationCoordinate2D] = []
    var innerBoundariesCoordinates: [[CLLocationCoordinate2D]] = []
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        if let outBoundElement = element.childForKey("outerBoundaryIs"),
            let coordinatesString = coordinatesForElement(outBoundElement) {
            outerBoundaryCoordinates = coordinatesString.parseMultipleCoordinates()
        }
        
        for child in element.children {
            if child.name == "innerBoundaryIs",
                let coordinatesString = coordinatesForElement(child) {
                let coordinates: [CLLocationCoordinate2D] = coordinatesString.parseMultipleCoordinates()
                innerBoundariesCoordinates.append(coordinates)
            }
        }
    }
    
    private func coordinatesForElement(_ element: AEXMLElement) -> String? {
        if let linearRingElement = element.childForKey("LinearRing"),
            let coordinatesElement = linearRingElement.childForKey("coordinates") {
            return coordinatesElement.value
        }
        return nil
    }
}

class KMLLineString: KMLElement {

    var coordinates: [CLLocationCoordinate2D] = []
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        if let coordElement = element.childForKey("coordinates") {
            coordinates = coordElement.string.parseMultipleCoordinates()
        }
    }
}

class KMLPoint: KMLElement {
    
    var coordinates: CLLocationCoordinate2D!
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        
        if let coordElement = element.childForKey("coordinates") {
            coordinates = coordElement.string.parseSingleCoordinate()
        }
    }
}

private extension String {
    func parseMultipleCoordinates() -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        let lines: [String] = components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for line: String in lines {
            coordinates.append(line.parseSingleCoordinate())
        }
        
        return coordinates
    }

    func parseSingleCoordinate() -> CLLocationCoordinate2D {
        //in KML firts value is longitude, second value - latitude
        let points: [String] = components(separatedBy: ",")
        //atof - str to double
        return CLLocationCoordinate2DMake(atof(points[1]), atof(points[0]))
    }
}
