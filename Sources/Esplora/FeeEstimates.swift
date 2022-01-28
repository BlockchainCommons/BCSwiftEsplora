//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation

public struct FeeEstimates: Decodable {
    public let estimates: [Int: Double]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String : Double].self)
        self.estimates = dict.reduce(into: [:]) {
            guard let targetBlocks = Int($1.0) else {
                return
            }
            $0[targetBlocks] = $1.1
        }
    }
}
