import XCTest
import Esplora

final class BlockTests: XCTestCase {
    let api = Esplora()
    let testBlockHeight = 720514
    let testBlockHash = "00000000000000000006e0a49103f576090adc289de5d3e965a158929a2887f4".hexData!
    let testBlockHeader = "0000e0200a0c5f7db2fe6bab4caa909ef8667f9d205b6887f52e02000000000000000000de0d0f96fe958ae6daf5906d17259ca49c11bdde7b2f99ce4e9a13fa43c90cb53abef16180900a17541ca8e9".hexData!
    let testTransactionID = "dcfdf520e9cf87c76ef3f4cae37dbc5da5bfc5c59d309e10dde2922166b9a38f".hexData!
    
    func testBlock() async throws {
        let block = try await api.block(hash: testBlockHash)
        XCTAssertEqual(block.height, testBlockHeight)
    }
    
    func testBlockHeader() async throws {
        let header = try await api.blockHeader(hash: testBlockHash)
        XCTAssertEqual(header, testBlockHeader)
    }
    
    func testBlockStatus() async throws {
        let status = try await api.blockStatus(hash: testBlockHash)
        XCTAssertEqual(status.height, testBlockHeight)
        XCTAssertEqual(status.isInBestChain, true)
        XCTAssertNotNil(status.nextBlockHash)
    }
    
    func testBlockTransactions() async throws {
        // Block 180_000
        let blockHash = "00000000000004ff83b6c10460b239ef4a6aa320e5fffd6c7bcedefa8c78593c".hexData!
        let txsCount = try await api.blockTransactionIDs(hash: blockHash).count
        XCTAssertEqual(txsCount, 235)
        var totalTransactions = 0
        for startIndex in stride(from: 0, to: txsCount, by: 25) {
            let transactions = try await api.blockTransactions(hash: blockHash, startIndex: startIndex)
            totalTransactions += transactions.count
        }
        XCTAssertEqual(totalTransactions, txsCount)
    }
    
    func testBlockTransactionIDs() async throws {
        let ids = try await api.blockTransactionIDs(hash: testBlockHash)
        XCTAssertEqual(ids[0], testTransactionID)
    }
    
    func testBlockTransactionID() async throws {
        let id = try await api.blockTransactionID(hash: testBlockHash, index: 0)
        XCTAssertEqual(id, testTransactionID)
    }
    
    func testBlockRaw() async throws {
        let raw = try await api.blockRaw(hash: testBlockHash)
        XCTAssertEqual(raw.prefix(256).hex, "0000e0200a0c5f7db2fe6bab4caa909ef8667f9d205b6887f52e02000000000000000000de0d0f96fe958ae6daf5906d17259ca49c11bdde7b2f99ce4e9a13fa43c90cb53abef16180900a17541ca8e9fd7c0a010000000001010000000000000000000000000000000000000000000000000000000000000000ffffffff4c0382fe0a1362696e616e63652f37393050003d027ee3c9cbfabe6d6dce9d6e4b16884b1ff04403d8b5fd1dc43f9b75f0a4e8f2df4c749e7b1a67a21f0200000000000000034700008dde0000ffffffff04026e1f26000000001976a914c499d0604392cc2051d7476056647d1c1bfc3f3888ac0000000000000000266a24aa21a9")
    }

    func testBlockHashAt() async throws {
        let hash = try await api.blockHash(at: testBlockHeight)
        XCTAssertEqual(hash, testBlockHash)
    }
    
    func testNewestBlocks() async throws {
        let blocks = try await api.newestBlocks(startHeight: testBlockHeight)
        XCTAssertEqual(blocks.count, 10)
        XCTAssertEqual(blocks[0].id, testBlockHash)
    }

    func testCurrentBlockHeight() async throws {
        let height = try await api.currentBlockHeight()
        XCTAssert(height >= testBlockHeight)
    }
    
    func testLatestBlockHash() async throws {
        let hash = try await api.latestBlockHash()
        XCTAssertEqual(hash.count, 64)
    }
}
