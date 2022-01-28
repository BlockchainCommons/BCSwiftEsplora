import XCTest
import Esplora
import WolfBase
import WolfAPI

class AddressTests: XCTestCase {
    let api = Esplora()
    let testAddress = "16FuTPaeRSPVxxCnwQmdyx2PQWxX6HWzhQ"
    
    func testAddressInfo() async throws {
        let info = try await api.addressInfo(address: testAddress)
        XCTAssertEqual(info.address, testAddress)
        XCTAssertEqual(info.chainStats.fundedTXOSum, 13911000000)
    }
    
    func testAddressHistory() async throws {
        let transactions = try await api.addressHistory(address: testAddress)
        XCTAssertEqual(transactions.count, 25)
        let transactions2 = try await api.addressHistory(address: testAddress, lastSeenTXID: transactions.last!.txid)
        XCTAssertEqual(transactions2.count, 25)
        let transactions3 = try await api.addressHistory(address: testAddress, lastSeenTXID: transactions2.last!.txid)
        XCTAssertEqual(transactions3.count, 12)
    }
    
    func testAddressUnconfirmedHistory1() async throws {
        let transactions = try await api.addressUnconfirmedHistory(address: testAddress)
        XCTAssert(transactions.isEmpty)
    }
    
    func getUnconfirmedTransaction() async throws -> Transaction {
        try await api.transaction(txid: api.mempoolTXIDs().first!)
    }
    
    func getUnconfirmedAddress() async throws -> String {
        try await getUnconfirmedTransaction().outputs.compactMap({ $0.scriptPubKeyAddress }).first!
    }
    
    func testAddressUnconfirmedHistory2() async throws {
        let address = try await getUnconfirmedAddress()
        let transactions = try await api.addressUnconfirmedHistory(address: address)
        XCTAssert(!transactions.isEmpty)
    }
    
    func testAddressUTXOs() async throws {
        // let blockHash = try await api.blockHash(at: 550001)
        // let txid = try await api.blockTransactionIDs(hash: blockHash).first!
        // let tx = try await api.transaction(txid: txid)
        // let addresses = tx.outputs.compactMap({ $0.scriptPubKeyAddress })
        // let address = addresses.first!
        // print(address)
        
        // Use a mock here because the number of UTXOs may change in the future.
        let address = "13hQVEstgo4iPQZv9C7VELnLWF7UWtF4Q3"
        let json = #"[{"txid":"7349c0debe5984f39d9088d08a6b2bf8d0bff492e25f5e31c4467920643f14f0","vout":0,"status":{"confirmed":true,"block_height":502946,"block_hash":"0000000000000000002fef4cbbabd92e904394107adccd48be84784077868c42","block_time":1515296732},"value":1770265049},{"txid":"0e216f34d75ef1e8265f0bf2bb1a8c628777986f6ca5704034380e4f6a8fdf8a","vout":0,"status":{"confirmed":true,"block_height":547294,"block_hash":"00000000000000000005ffd7a782aed3330e853b1a1d84417d1af09d07ae3be9","block_time":1540494742},"value":888},{"txid":"f9899a428766b79f649224c86d9d9abf77a06a6cad8353a6fab3ba4668582562","vout":0,"status":{"confirmed":true,"block_height":524584,"block_hash":"000000000000000000148ceddeeb9e29588fa94839f028f168f3610c68dee2d0","block_time":1527388604},"value":1262246497},{"txid":"b691cbd8eacf206a3417e182fa6d93b83eea33d57d4c89a8c6ddf5c2319df98b","vout":0,"status":{"confirmed":true,"block_height":547291,"block_hash":"00000000000000000000cf38d46506689c8a2530c643ae8d3bdc42fd897179cb","block_time":1540493835},"value":888},{"txid":"b5fca652a084e01b71ceff244d4c9c4dbb30299a2e0ff80e9fe02b4afb37529b","vout":0,"status":{"confirmed":true,"block_height":500285,"block_hash":"000000000000000000868be59ee0ff19110739b35ecf2558a4649ec7901b2128","block_time":1513787008},"value":1695783402},{"txid":"db1166960befa97d481bb0d1ae3dcfb1a2a43b737edab6e32a32b457f9e17dfa","vout":0,"status":{"confirmed":true,"block_height":500530,"block_hash":"00000000000000000079bb4131e4e6e222f7daba47a14d182676fac69ceedc6b","block_time":1513945614},"value":2194712129}]"#
        let utxos = try await api.addressUTXOs(address: address, mock: Mock(string: json))
        XCTAssertEqual(utxos.count, 6)
        XCTAssertEqual(utxos.reduce(0, { $0 + $1.value }), 6923008853)
    }
    
    func testAddressesWithPrefix() async throws {
        let addresses1 = try await api.addressesWithPrefix("13hQV")
        XCTAssert(addresses1.count >= 10)
        let addresses2 = try await api.addressesWithPrefix("13hQV1")
        XCTAssert(addresses2.count >= 2)
    }
}
