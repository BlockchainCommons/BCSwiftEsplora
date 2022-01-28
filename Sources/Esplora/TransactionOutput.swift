//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

public struct TransactionOutput: Decodable {
    public let scriptPubKey: Data
    public let scriptPubKeyAsm: String
    public let scriptPubKeyType: String
    public let scriptPubKeyAddress: String?
    public let value: UInt64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.scriptPubKey = try container.decode(HexData.self, forKey: .scriptPubKey).data
        self.scriptPubKeyAsm = try container.decode(String.self, forKey: .scriptPubKeyAsm)
        self.scriptPubKeyType = try container.decode(String.self, forKey: .scriptPubKeyType)
        self.scriptPubKeyAddress = try container.decodeIfPresent(String.self, forKey: .scriptPubKeyAddress)
        self.value = try container.decode(UInt64.self, forKey: .value)
    }
    
    enum CodingKeys: String, CodingKey {
        case scriptPubKey = "scriptpubkey"
        case scriptPubKeyAsm = "scriptpubkey_asm"
        case scriptPubKeyType = "scriptpubkey_type"
        case scriptPubKeyAddress = "scriptpubkey_address"
        case value
    }
}
