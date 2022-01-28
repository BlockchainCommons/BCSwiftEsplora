//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation
import WolfBase

public struct UTXO: Decodable {
    public let txid: Data
    public let index: Int
    public let txStatus: TransactionStatus
    public let value: UInt64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.txid = try container.decode(HexData.self, forKey: .txid).data
        self.index = try container.decode(Int.self, forKey: .index)
        self.txStatus = try container.decode(TransactionStatus.self, forKey: .status)
        self.value = try container.decode(UInt64.self, forKey: .value)
    }
    
    enum CodingKeys: String, CodingKey {
        case txid
        case index = "vout"
        case status
        case value
    }
}
