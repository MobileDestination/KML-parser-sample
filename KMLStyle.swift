//
//  KMLStyle.swift
//
//  Created by Sergey Blazhko on 1/18/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation
import MapKit

import AEXML


class KMLStyle: KMLElement {
    
    override lazy var allovedChildrenTags: Set<String>? = {
        return Set.init(KMLTag.allStyleTags.compactMap({ (tag) -> String? in
            //Style hasn't Style as child. Icon is child of IconStyle, not Style
            switch tag {
            case .Style:
                return nil
            case .Icon:
                return nil
            default:
                return tag.toString
            }
        }))
    }()
    
    var styleId: String?
    
    var polyStyle: KMLPolyStyle?
    var lineStyle: KMLLineStyle?
    var iconStyle: KMLIconStyle?
    var balloonStyle: KMLBalloonStyle?
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        //style has style ID (as link to document's style)
        //or style with desctiption
        if let globalStyleId: String = element.attributes["id"] {
            styleId = globalStyleId
        } else {
            if let polyStyleElement = element.childForKey("PolyStyle") {
                polyStyle = KMLPolyStyle.init(polyStyleElement)
            }
            if let lineStyleElement = element.childForKey("LineStyle") {
                lineStyle = KMLLineStyle.init(lineStyleElement)
            }
            if let iconStyleElement = element.childForKey("IconStyle") {
                iconStyle = KMLIconStyle.init(iconStyleElement)
            }
            if let balloonStyleElement = element.childForKey("BalloonStyle") {
                balloonStyle = KMLBalloonStyle.init(balloonStyleElement)
            }

        }
    }

}

 class KMLColorStyleGroup: KMLElement {
    enum KMLColorMode: String {
        case normal
        case random
    }
    
     var color: UIColor = UIColor.black
    
     override init(_ element: AEXMLElement) {
        super.init(element)

        if let colorElement = element.childForKey("color") {
            
            if let colorModeElement = element.childForKey("colorMode") {
                switch KMLColorMode(rawValue: colorModeElement.string) {
                case .normal?: color = UIColor(hex: colorElement.string)
                case .random?: fatalError("Random KML color mode not implemented")
                case .none: fatalError("Undefined KML color mode")
                }
            } else {
                color = UIColor(hex: colorElement.string)
            }
        }
    }
}

 class KMLPolyStyle: KMLColorStyleGroup {
    //polygon should be filled or not
    var fill: Bool = true
    
    //should draw outline borders (outerBoundaryCoordinates) or not
    var outline: Bool = true
    
    override init(_ element: AEXMLElement) {
        super.init(element)
        
        if let fillElement = element.childForKey("fill") {
            fill = Bool(fillElement.value)
        }
        
        if let outlineElement = element.childForKey("outline") {
            outline = Bool(outlineElement.value)
        }
    }
}

 class KMLLineStyle: KMLColorStyleGroup {
    var width: Double = 1

    override init(_ element: AEXMLElement) {
        super.init(element)
        
        if let widthElement = element.childForKey("width"),
            let w = widthElement.double{
            width = w
        }
    }
}

 class KMLIconStyle: KMLColorStyleGroup {
    
    override lazy var allovedChildrenTags: Set<String>? = {
        return [KMLTag.Icon.toString]
    }()
    
    var scale: Double = 1.0
    var heading: Double = 0.0
    var icon: KMLIcon?

    override init(_ element: AEXMLElement) {
        super.init(element)
        
        if let iconElement = element.childForKey("Icon") {
            icon = KMLIcon.init(iconElement)
        }
        
        if let scaleElement = element.childForKey("scale"),
            let dou = scaleElement.double {
            scale = dou
        }
        
        if let headingElement = element.childForKey("heading"),
            let head = headingElement.double {
            heading = head
        }
    }

}

 class KMLBalloonStyle: KMLElement {
    var bgColor: UIColor = UIColor.lightGray
    var textColor: UIColor = UIColor.black
    var text: String?

    override init(_ element: AEXMLElement) {
        
        super.init(element)

        if let textElement = element.childForKey("text") {
            text = textElement.value
        }
        
        if let bgColorElement = element.childForKey("bgColor") {
            bgColor = UIColor.init(hex: bgColorElement.string)
        }
        
        if let textColorElement = element.childForKey("textColor") {
            textColor = UIColor.init(hex: textColorElement.string)
        }
    }

}

 class KMLIcon: KMLElement {
    var href: String!
    var url: URL? {
        return URL.init(string: href)
    }
    
    override init(_ element: AEXMLElement) {
        super.init(element)

        if let linkElement = element.childForKey("href") {
            href = linkElement.value
        }
    }
}

fileprivate extension Bool {
    init(_ string: String?) {
        guard let string = string else { self = false; return }
        
        switch string.lowercased() {
        case "true", "yes", "1":
            self = true
        default:
            self = false
        }
    }
}
