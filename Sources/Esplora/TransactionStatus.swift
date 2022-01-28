//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

public enum TransactionStatus: Decodable {
    case unconfirmed
    case confirmed(Confirmation)
    
    public var isConfirmed: Bool {
        switch self {
        case .unconfirmed:
            return false
        case .confirmed:
            return true
        }
    }
    
    public var confirmation: Confirmation? {
        switch self {
        case .unconfirmed:
            return nil
        case .confirmed(let confirmation):
            return confirmation
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if try container.decode(Bool.self, forKey: .isConfirmed) {
            let blockHeight = try container.decode(Int.self, forKey: .blockHeight)
            let blockHash = try container.decode(HexData.self, forKey: .blockHash).data
            let blockTime = try container.decode(UnixEpochDate.self, forKey: .blockTime).date
            self = .confirmed(.init(blockHeight: blockHeight, blockHash: blockHash, blockTime: blockTime))
        } else {
            self = .unconfirmed
        }
    }
    
    public struct Confirmation {
        public let blockHeight: Int
        public let blockHash: Data
        public let blockTime: Date

        public init(blockHeight: Int, blockHash: Data, blockTime: Date) {
            self.blockHeight = blockHeight
            self.blockHash = blockHash
            self.blockTime = blockTime
        }
    }

    enum CodingKeys: String, CodingKey {
        case isConfirmed = "confirmed"
        case blockHeight = "block_height"
        case blockHash = "block_hash"
        case blockTime = "block_time"
    }
}
