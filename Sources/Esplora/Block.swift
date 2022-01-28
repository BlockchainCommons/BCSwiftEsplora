//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

public struct Block: Decodable {
    public let id: Data
    public let height: Int
    public let version: Int
    public let timestamp: Date
    public let txCount: Int
    public let size: Int
    public let weight: Int
    public let merkleRoot: Data
    public let previousBlockHash: Data
    public let medianTime: Date
    public let nonce: Int
    public let bits: Int
    public let difficulty: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(HexData.self, forKey: .id).data
        self.height = try container.decode(Int.self, forKey: .height)
        self.version = try container.decode(Int.self, forKey: .version)
        self.timestamp = try container.decode(UnixEpochDate.self, forKey: .timestamp).date
        self.txCount = try container.decode(Int.self, forKey: .txCount)
        self.size = try container.decode(Int.self, forKey: .size)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.merkleRoot = try container.decode(HexData.self, forKey: .merkleRoot).data
        self.previousBlockHash = try container.decode(HexData.self, forKey: .previousBlockHash).data
        self.medianTime = try container.decode(UnixEpochDate.self, forKey: .medianTime).date
        self.nonce = try container.decode(Int.self, forKey: .nonce)
        self.bits = try container.decode(Int.self, forKey: .bits)
        self.difficulty = try container.decode(Int.self, forKey: .difficulty)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case height
        case version
        case timestamp
        case txCount = "tx_count"
        case size
        case weight
        case merkleRoot = "merkle_root"
        case previousBlockHash = "previousblockhash"
        case medianTime = "mediantime"
        case nonce
        case bits
        case difficulty
    }
}
