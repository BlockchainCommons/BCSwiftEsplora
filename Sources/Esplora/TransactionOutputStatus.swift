//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation
import WolfBase

public enum TransactionOutputStatus: Decodable {
    case unspent
    case spent(Spent)
    
    public var isSpent: Bool {
        switch self {
        case .unspent:
            return false
        case .spent:
            return true
        }
    }
    
    public var spent: Spent? {
        switch self {
        case .unspent:
            return nil
        case .spent(let spent):
            return spent;
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if try container.decode(Bool.self, forKey: .isSpent) {
            let txid = try container.decode(HexData.self, forKey: .txid).data
            let index = try container.decode(Int.self, forKey: .index)
            let status = try container.decode(TransactionStatus.self, forKey: .status)
            self = .spent(.init(txid: txid, index: index, status: status))
        } else {
            self = .unspent
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case isSpent = "spent"
        case txid
        case index = "vin"
        case status
    }
    
    public struct Spent {
        public let txid: Data
        public let index: Int
        public let status: TransactionStatus
    }
}
