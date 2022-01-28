//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation

public struct AddressInfo: Decodable {
    public let address: String
    public let chainStats: Stats
    public let mempoolStats: Stats
    
    enum CodingKeys: String, CodingKey {
        case address
        case chainStats = "chain_stats"
        case mempoolStats = "mempool_stats"
    }
    
    public struct Stats: Decodable {
        public let fundedTXOCount: Int
        public let fundedTXOSum: UInt64
        public let spentTXOCount: Int
        public let spentTXOSum: UInt64
        public let txCount: Int
        
        enum CodingKeys: String, CodingKey {
            case fundedTXOCount = "funded_txo_count"
            case fundedTXOSum = "funded_txo_sum"
            case spentTXOCount = "spent_txo_count"
            case spentTXOSum = "spent_txo_sum"
            case txCount = "tx_count"
        }
    }
}
