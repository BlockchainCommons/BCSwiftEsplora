//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

public struct Transaction: Decodable {
    public let txid: Data
    public let version: Int
    public let lockTime: Int
    public let inputs: [TransactionInput]
    public let outputs: [TransactionOutput]
    public let size: Int
    public let weight: Int
    public let fee: UInt64
    public let status: TransactionStatus
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.txid = try container.decode(HexData.self, forKey: .txid).data
        self.version = try container.decode(Int.self, forKey: .version)
        self.lockTime = try container.decode(Int.self, forKey: .lockTime)
        self.inputs = try container.decode([TransactionInput].self, forKey: .inputs)
        self.outputs = try container.decode([TransactionOutput].self, forKey: .outputs)
        self.size = try container.decode(Int.self, forKey: .size)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.fee = try container.decode(UInt64.self, forKey: .fee)
        self.status = try container.decode(TransactionStatus.self, forKey: .status)
    }
    
    enum CodingKeys: String, CodingKey {
        case txid
        case version
        case lockTime = "locktime"
        case inputs = "vin"
        case outputs = "vout"
        case size
        case weight
        case fee
        case status
    }
}
