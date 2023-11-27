//
//  ArrayExtensions.swift
//  BookAppTest
//
//  Created by oleksiy humenyuk on 20.11.2023.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
