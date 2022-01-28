//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation

public struct Mempool: Decodable {
    public let count: Int
    public let vSize: Int
    public let totalFee: UInt64
    public let feeHistogram: FeeHistogram
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.vSize = try container.decode(Int.self, forKey: .vSize)
        self.totalFee = try container.decode(UInt64.self, forKey: .totalFee)
        self.feeHistogram = try container.decode(FeeHistogram.self, forKey: .feeHistogram)
    }
    
    enum CodingKeys: String, CodingKey {
        case count
        case vSize = "vsize"
        case totalFee = "total_fee"
        case feeHistogram = "fee_histogram"
    }
    
    public struct FeeHistogram: Decodable {
        public let bars: [Bar]
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.bars = try container.decode([Bar].self)
        }
        
        public struct Bar: Decodable {
            public let feeRate: Double
            public let vSize: Int
            
            public init(from decoder: Decoder) throws {
                var container = try decoder.unkeyedContainer()
                self.feeRate = try container.decode(Double.self)
                self.vSize = try container.decode(Int.self)
            }
        }
    }
}
