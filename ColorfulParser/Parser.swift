//
//  Parser.swift
//  ColorfulParser
//
//  Created by Artem Misesin on 6/30/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation
import Kanna

class Parser {
    
    var wordsArray: [String] = []
    
    func getHTML(from url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func parse(data: Data){
        wordsArray = []
        if let doc = HTML(html: data, encoding: .utf8) {
            
            // getting all the links from the page source code
            for link in doc.css("a") {
                
                // getting rid of the junk
                if link.text! != "" && !link.text!.contains("  "){
                    var result = link.text!.replacingOccurrences(of: "\n", with: " ")
                    result = result.replacingOccurrences(of: "\t", with: "")
                    if wordsArray.last != result {
                        wordsArray.append(result)
                    }
                }
            }
        }
    }
    
    var amountOfData: Int {
        return wordsArray.count
    }

}
