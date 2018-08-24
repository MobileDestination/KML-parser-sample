//
//  KMLPlacemark.swift
//
//  Created by Sergey Blazhko on 1/18/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation

import AEXML

class KMLPlacemark: KMLElement {
    
    override lazy var allovedChildrenTags: Set<String>? = {
        return [KMLTag.Style.toString,
                KMLTag.Point.toString,
                KMLTag.MultiGeometry.toString]
    }()
    
    var id: String!
    
    var styleUrl: String?
    var description: String?
    
    var point: KMLPoint?
    var multigeometry: KMLMultiGeometry?
    
    var style: KMLStyle?
    
    required override init(_ element: AEXMLElement) {
        super.init(element)
        id = element.attributes["id"]
        print("Name = \(String(describing: self.name))")

        if let desc = element.childForKey("description")?.value {
            let elements: [String] = desc.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            description = elements.joined(separator: " ")
        }
        
        if let pointElement = element.childForKey("Point") {
            point = KMLPoint.init(pointElement)
        } else if let multyElement = element.childForKey("MultiGeometry") {
                multigeometry = KMLMultiGeometry.init(multyElement)
        }
        
        if let styleElement = element.childForKey("Style") {
            style = KMLStyle.init(styleElement)
        }
    }
}
