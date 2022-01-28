//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import Foundation
import WolfBase

extension Data {
    public var nilIfEmpty: Data? {
        isEmpty ? nil : self
    }
}

extension String {
    public var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

public struct TransactionInput: Decodable {
    public let previousTxid: Data
    public let previousIndex: Int
    public let previousOutput: TransactionOutput?
    public let scriptSig: Data?
    public let scriptSigAsm: String?
    public let innerRedeemScriptAsm: String?
    public let innerWitnessScriptAsm: String?
    public let witness: [Data?]?
    public let isCoinbase: Bool
    public let sequence: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.previousTxid = try container.decode(HexData.self, forKey: .previousTxid).data
        self.previousIndex = try container.decode(Int.self, forKey: .previousIndex)
        self.previousOutput = try container.decodeIfPresent(TransactionOutput.self, forKey: .previousOutput)
        self.scriptSig = try container.decodeIfPresent(HexData.self, forKey: .scriptSig)?.data.nilIfEmpty
        self.scriptSigAsm = try container.decodeIfPresent(String.self, forKey: .scriptSigAsm)?.nilIfEmpty
        self.innerRedeemScriptAsm = try container.decodeIfPresent(String.self, forKey: .innerRedeemScriptAsm)?.nilIfEmpty
        self.innerWitnessScriptAsm = try container.decodeIfPresent(String.self, forKey: .innerWitnessScriptAsm)?.nilIfEmpty
        self.witness = try container.decodeIfPresent([HexData].self, forKey: .witness)?.map { $0.data.nilIfEmpty }
        self.isCoinbase = try container.decode(Bool.self, forKey: .isCoinbase)
        self.sequence = try container.decode(Int.self, forKey: .sequence)
    }
    
    enum CodingKeys: String, CodingKey {
        case previousTxid = "txid"
        case previousIndex = "vout"
        case previousOutput = "prevout"
        case scriptSig = "scriptsig"
        case scriptSigAsm = "scriptsig_asm"
        case innerRedeemScriptAsm = "inner_redeemscript_asm"
        case innerWitnessScriptAsm = "inner_witnessscript_asm"
        case witness
        case isCoinbase = "is_coinbase"
        case sequence
    }
}
