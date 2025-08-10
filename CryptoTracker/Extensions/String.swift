//
//  String.swift
//  CryptoTracker
//
//  Created by Prathmesh on 12/10/23.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
