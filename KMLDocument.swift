//
//  KMLDocument.swift
//
//  Created by Sergey Blazhko on 1/16/18.
//  Copyright © 2018 Sergey Blazhko. All rights reserved.
//

import Foundation

import AEXML

class KMLDocument: KMLElement {
   
    override lazy var allovedChildrenTags: Set<String>? = {
        return [KMLTag.Placemark.toString,
                KMLTag.Style.toString,
                KMLTag.Document.toString]
    }()
    
    var documents: [KMLDocument]?
    var placemarks: [KMLPlacemark]?
    var docStyles: [KMLStyle]?
    
    convenience init? (data: Data) {
        guard let xmlDoc = try? AEXMLDocument.init(xml: data) else {
            print("Can't parse XML")
            return nil
        }
       
        let element: AEXMLElement = xmlDoc.root["Document"]
        self.init(failableElement: element)
    }
    
    convenience init? (string: String) {
        guard let xmlDoc = try? AEXMLDocument(xml: string) else {
            print("Can't parse XML")
            return nil
        }
        
        let element: AEXMLElement = xmlDoc.root["Document"]
        self.init(failableElement: element)
    }
    
    
    
    override init?(failableElement: AEXMLElement) {
        super.init(failableElement: failableElement)
        parseElement(failableElement)
        
        //not needs return KMLDocument withoun any placemarks and documents
        if !hasElementsIn(documents) && !hasElementsIn(placemarks) {
            return nil
        }
    }
    
    private func hasElementsIn(_ array: [Any]? ) -> Bool {
        return array != nil && array?.isEmpty == false
    }
    
    private func parseElement(_ element: AEXMLElement) {        
        for child: AEXMLElement in element.children {
            if allovedChildrenTags?.contains(child.name) == true {
                if let childKMLTag: KMLTag = KMLTag(rawValue: child.name) {
                    switch childKMLTag {
                    case .Placemark:
                        if placemarks == nil {
                            placemarks = []
                        }
                        
                        let placemark = KMLPlacemark(child)
                        placemarks!.append(placemark)
                        
                    case .Style:
                        if docStyles == nil {
                            docStyles = []
                        }
                        
                        let style = KMLStyle(child)
                        docStyles!.append(style)
                        
                    case .Document:
                        if let doc = KMLDocument.init(failableElement: child) {
                            if documents == nil {
                                documents = []
                            }
                            documents!.append(doc)
                        }

                        
                    default:
                        break
                    }
                }
            }
        }

    }
    
}
