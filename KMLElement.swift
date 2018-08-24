//
//  KMLElement.swift
//
//  Created by Sergey Blazhko on 1/16/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation
import CoreLocation

import AEXML

class KMLElement {
    
    var name: String?
    
    lazy var allovedChildrenTags: Set<String>? = { return nil }()
    
    init(_ element: AEXMLElement) {
        if let nameElement = element.childForKey("name") {
            name = nameElement.value
        }
    }
    
    init?(failableElement element: AEXMLElement) {
        if let nameElement = element.childForKey("name") {
            name = nameElement.value
        }
    }
}

extension AEXMLElement {
    func childForKey(_ key: String) -> AEXMLElement? {
        let element = self[key]
        
        switch element.error {
        case .elementNotFound?:
            print("AEXMLElement for key: \(key) not found")
            return nil
            
        case .rootElementMissing?:
            print("No root element for AEXMLElement for key: \(key)")
            return nil
            
        case .parsingFailed?:
            print("AEXMLElement for key: \(key) parsing failed")
            return nil
            
        case .none:
            return element
        }
    }
}
