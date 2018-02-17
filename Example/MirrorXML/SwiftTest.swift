//
//  SwiftTest.swift
//  MirrorXML_Example
//
//  Created by Mike Spears on 2018-02-15.
//  Copyright © 2018 samesimilar@gmail.com. All rights reserved.
//

import Foundation
import MirrorXML

public class SwiftTest : NSObject {
    func test() {
        
        let ownerName = try! MXMatch(path: "/opml/head/ownerName")
        ownerName.exitHandler = { print($0.text ?? "")}
        
        let body = try! MXMatch(path: "//body")
        body.entryHandler = { (elm) in
            let outline = try! MXMatch(path: "outline", namespaces: nil)
            
            
            outline.entryHandler = { (elm) in
                let root = MXMatch.matchRoot()
                root.exitHandler = { (elm) in
                    print (elm.attributes["text"] ?? "No text")
                }
                return [root]
            }
            outline.exitHandler = { (elm) in
                print(elm.attributes["description"] ?? "")
            }

            return [outline]
        }
        
        
        let parser = MXParser(matches: [ownerName, body])
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "subscriptionList", withExtension: "opml")!)
        
        parser.parseDataChunk(data)
        parser.dataFinished()
        
        
    }
    
    func attributedString() -> NSAttributedString {
        let html = try! String(contentsOf: Bundle.main.url(forResource: "markdownish", withExtension: "html")!)
        
        let parser = MXHTMLToAttributedString()
        return parser.convertHTMLString(html)
    }
}
