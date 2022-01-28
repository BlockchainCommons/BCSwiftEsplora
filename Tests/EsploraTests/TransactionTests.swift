import XCTest
import Esplora
import WolfBase

class TransactionTests: XCTestCase {
    let api = Esplora()
    let testTxid = "dcfdf520e9cf87c76ef3f4cae37dbc5da5bfc5c59d309e10dde2922166b9a38f".hexData!
    let testBlockHeight = 720514

    func testTransaction() async throws {
        let transaction = try await api.transaction(txid: testTxid)
        XCTAssertEqual(transaction.txid, testTxid)
    }
    
    func testTransactionStatus() async throws {
        switch try await api.transactionStatus(txid: testTxid) {
        case .confirmed:
            break
        default:
            XCTFail()
        }
    }
    
    func testTransactionRaw() async throws {
        let transaction = try await api.transactionRaw(txid: testTxid)
        XCTAssertEqual(transaction.prefix(100).hex, "010000000001010000000000000000000000000000000000000000000000000000000000000000ffffffff4c0382fe0a1362696e616e63652f37393050003d027ee3c9cbfabe6d6dce9d6e4b16884b1ff04403d8b5fd1dc43f9b75f0a4e8f2df4c749e7b")
    }
    
    func testTransactionMerkleProof() async throws {
        let proof = try await api.transactionMerkleProof(txid: testTxid)
        XCTAssertEqual(proof.merkle[0], "b10c8c37c8fd414461e9a3d919a570b170da94567bb5a6f7138be8e99fced1d9".hexData!)
    }
    
    func testTransactionOutputStatus() async throws {
        let status1 = try await api.transactionOutputStatus(txid: testTxid, index: 0)
        XCTAssertFalse(status1.isSpent)
        
        let txid2 = "f3e6066078e815bb24db0dfbff814f738943bddaaa76f8beba360cfe2882480a".hexData!
        let status2 = try await api.transactionOutputStatus(txid: txid2, index: 0)
        XCTAssertTrue(status2.isSpent)
        XCTAssertEqual(status2.spent!.txid, "dda95219914c83bb60932b6d54edf41fe134137bce931708c12a0cd50d81cfe6".hexData!)
    }
    
    func testTransactionOutputStatus2() async throws {
        let statuses = try await api.transactionOutputStatus(txid: testTxid)
        XCTAssertTrue(statuses.count == 4)
    }
    
    func testBroadcastTransaction() async throws {
        let badTransaction = "00112233".hexData!
        do {
            _ = try await api.broadcastTransaction(tx: badTransaction)
            XCTFail("Should throw.")
        } catch { }
    }
}
