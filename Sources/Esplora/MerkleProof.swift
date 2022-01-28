//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation
import WolfBase

public struct MerkleProof: Decodable {
    /// The height of the block the transaction was confirmed in.
    public let blockHeight: Int
    
    /// A list of transaction hashes the current hash is paired with, recursively, in order to trace up to obtain merkle root of the block, deepest pairing first.
    public let merkle: [Data]
    
    /// The 0-based index of the position of the transaction in the ordered list of transactions in the block.
    public let pos: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.blockHeight = try container.decode(Int.self, forKey: .blockHeight)
        self.merkle = try container.decode([HexData].self, forKey: .merkle).map({ $0.data })
        self.pos = try container.decode(Int.self, forKey: .pos)
    }
    
    enum CodingKeys: String, CodingKey {
        case blockHeight = "block_height"
        case merkle
        case pos
    }
}
