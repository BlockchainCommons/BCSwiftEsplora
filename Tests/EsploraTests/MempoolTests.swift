//
//  File.swift
//  
//
//  Created by Wolf McNally on 1/27/22.
//

import Foundation

import XCTest
import Esplora
import WolfBase

class MempoolTests: XCTestCase {
    let api = Esplora()

    func testMempool() async throws {
        let mempool = try await api.mempool()
        XCTAssertEqual(mempool.vSize, mempool.feeHistogram.bars.reduce(0, { $0 + $1.vSize } ))
    }
    
    func testMempoolTXIDs() async throws {
        let txids = try await api.mempoolTXIDs()
        XCTAssert(!txids.isEmpty)
    }
    
    func testMempoolRecentTransactions() async throws {
        let transactions = try await api.mempoolRecentTransactions()
        XCTAssert(transactions.count == 10)
    }
}
