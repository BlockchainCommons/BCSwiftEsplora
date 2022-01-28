//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

public struct BlockStatus: Decodable {
    public let isInBestChain: Bool
    public let height: Int
    public let nextBlockHash: Data?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isInBestChain = try container.decode(Bool.self, forKey: .isInBestChain)
        self.height = try container.decode(Int.self, forKey: .height)
        self.nextBlockHash = try container.decodeIfPresent(HexData.self, forKey: .nextBlockHash)?.data
    }
    
    enum CodingKeys: String, CodingKey {
        case isInBestChain = "in_best_chain"
        case height
        case nextBlockHash = "next_best"
    }
}
