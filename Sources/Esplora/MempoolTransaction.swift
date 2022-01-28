//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation
import WolfBase

public struct MempoolTransaction: Decodable {
    public let txid: Data
    public let fee: UInt64
    public let vSize: Int
    public let value: UInt64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.txid = try container.decode(HexData.self, forKey: .txid).data
        self.vSize = try container.decode(Int.self, forKey: .vSize)
        self.fee = try container.decode(UInt64.self, forKey: .fee)
        self.value = try container.decode(UInt64.self, forKey: .value)
    }

    enum CodingKeys: String, CodingKey {
        case txid
        case fee
        case vSize = "vsize"
        case value
    }
}
