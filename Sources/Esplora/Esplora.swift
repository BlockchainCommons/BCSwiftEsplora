import Foundation
import WolfAPI
import WolfBase

public enum EsploraError: Error {
    case invalidHex
}

public class Esplora: API {
    public static let defaultHost = "blockstream.info"

    public init(host: String? = nil, port: Int? = nil, session: URLSession? = nil) {
        let endpoint = Endpoint(
            scheme: .https,
            host: host ?? Self.defaultHost,
            port: port
        )
        super.init(endpoint: endpoint, authorization: nil, session: session)
    }
}

// MARK: - Transactions

extension Esplora {
    /// Returns information about the transaction.
    ///
    /// Available fields: txid, version, locktime, size, weight, fee, vin, vout and status (see transaction format for /// details).
    ///
    /// `GET /tx/:txid`
    public func transaction(txid: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Transaction {
        try await call(
            returning: Transaction.self,
            network: network,
            path: ["tx", txid.hex],
            mock: mock
        )
    }

    /// Returns the transaction confirmation status.
    ///
    /// Available fields: confirmed (boolean), block_height (optional) and block_hash (optional).
    ///
    /// `GET /tx/:txid/status`
    public func transactionStatus(txid: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> TransactionStatus {
        try await call(
            returning: TransactionStatus.self,
            network: network,
            path: ["tx", txid.hex, "status"],
            mock: mock
        )
    }

    /// Returns the raw transaction as binary data.
    ///
    /// `GET /tx/:txid/raw`
    public func transactionRaw(txid: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            network: network,
            path: ["tx", txid.hex, "raw"],
            mock: mock
        )
    }

    // Returns a merkle inclusion proof for the transaction using bitcoind's merkleblock format.
    //
    // `GET /tx/:txid/merkleblock-proof`
    //
    // Not currently implemented.

    /// Returns a merkle inclusion proof for the transaction using Electrum's `blockchain.transaction.get_merkle` format.
    ///
    /// `GET /tx/:txid/merkle-proof`
    public func transactionMerkleProof(txid: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> MerkleProof {
        try await call(
            returning: MerkleProof.self,
            network: network,
            path: ["tx", txid.hex, "merkle-proof"],
            mock: mock
        )
    }

    /// Returns the spending status of a transaction output.
    ///
    /// `GET /tx/:txid/outspend/:vout`
    public func transactionOutputStatus(txid: Data, index: Int, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> TransactionOutputStatus {
        try await call(
            returning: TransactionOutputStatus.self,
            network: network,
            path: makePath(network, ["tx", txid.hex, "outspend", index]),
            mock: mock
        )
    }

    /// Returns the spending status of all transaction outputs.
    ///
    /// `GET /tx/:txid/outspends`
    public func transactionOutputStatus(txid: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [TransactionOutputStatus] {
        try await call(
            returning: [TransactionOutputStatus].self,
            network: network,
            path: makePath(network, ["tx", txid.hex, "outspends"]),
            mock: mock
        )
    }

    /// Broadcast a raw transaction to the network.
    ///
    /// `POST /tx`
    public func broadcastTransaction(tx: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            returning: HexData.self,
            method: .post,
            network: network,
            path: makePath(network, ["tx"]),
            body: RequestBody(data: tx.hex.utf8Data),
            mock: mock
        ).data
    }
}

// MARK: - Addresses

extension Esplora {
    /// Get information about an address/scripthash.
    ///
    /// Available fields: `address`/`scripthash`, `chain_stats` and `mempool_stats`.
    ///
    /// `{chain,mempool}_stats` each contain an object with `tx_count`, `funded_txo_count`, `funded_txo_sum`, `spent_txo_count` and `spent_txo_sum`.
    ///
    /// `GET /address/:address`
    /// `GET /scripthash/:hash`
    public func addressInfo(address: String, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> AddressInfo {
        try await call(
            returning: AddressInfo.self,
            network: network,
            path: makePath(network, ["address", address]),
            mock: mock
        )
    }

    /// Get transaction history for the specified address/scripthash, sorted with newest first.
    ///
    /// Returns up to 50 mempool transactions plus the first 25 confirmed transactions. You can request more confirmed transactions using `:last_seen_txid` (see below).
    ///
    /// `GET /address/:address/txs`
    /// `GET /scripthash/:hash/txs`
    public func addressHistory(address: String, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Transaction] {
        try await call(
            returning: [Transaction].self,
            network: network,
            path: makePath(network, ["address", address, "txs"]),
            mock: mock
        )
    }

    /// Get confirmed transaction history for the specified address/scripthash, sorted with newest first.
    ///
    /// Returns 25 transactions per page. More can be requested by specifying the last txid seen by the previous query.
    ///
    /// `GET /address/:address/txs/chain[/:last_seen_txid]`
    /// `GET /scripthash/:hash/txs/chain[/:last_seen_txid]`
    public func addressHistory(address: String, lastSeenTXID: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Transaction] {
        try await call(
            returning: [Transaction].self,
            network: network,
            path: makePath(network, ["address", address, "txs", "chain", lastSeenTXID.hex]),
            mock: mock
        )
    }

    /// Get unconfirmed transaction history for the specified address/scripthash.
    ///
    /// Returns up to 50 transactions (no paging).
    ///
    /// `GET /address/:address/txs/mempool`
    /// `GET /scripthash/:hash/txs/mempool`
    public func addressUnconfirmedHistory(address: String, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Transaction] {
        try await call(
            returning: [Transaction].self,
            network: network,
            path: makePath(network, ["address", address, "txs", "mempool"]),
            mock: mock
        )
    }

    /// Get the list of unspent transaction outputs associated with the address/scripthash.
    ///
    /// Available fields: txid, vout, value and status (with the status of the funding tx).
    ///
    /// `GET /address/:address/utxo`
    /// `GET /scripthash/:hash/utxo`
    public func addressUTXOs(address: String, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [UTXO] {
        try await call(
            returning: [UTXO].self,
            network: network,
            path: makePath(network, ["address", address, "utxo"]),
            mock: mock
        )
    }

    /// Search for addresses beginning with :prefix.
    ///
    /// Returns a JSON array with up to 10 results.
    ///
    /// `GET /address-prefix/:prefix`
    public func addressesWithPrefix(_ prefix: String, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [String] {
        try await call(
            returning: [String].self,
            network: network,
            path: makePath(network, ["address-prefix", prefix]),
            mock: mock
        )
    }
}
 
// MARK: - Blocks

extension Esplora {
    /// Returns information about a block.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash`
    public func block(hash: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Block {
        try await call(
            returning: Block.self,
            network: network,
            path: makePath(network, ["block", hash.hex]),
            mock: mock
        )
    }
    
    /// Returns the hex-encoded block header.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash/header`
    public func blockHeader(hash: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            returning: HexData.self,
            network: network,
            path: makePath(network, ["block", hash.hex, "header"]),
            mock: mock
        ).data
    }
    
    /// Returns the block status.
    ///
    /// Available fields: `in_best_chain` (boolean, false for orphaned blocks), `next_best` (the hash of the /next block, only available for blocks in the best chain).
    ///
    /// `GET /block/:hash/status`
    public func blockStatus(hash: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> BlockStatus {
        try await call(
            returning: BlockStatus.self,
            network: network,
            path: makePath(network, ["block", hash.hex, "status"]),
            mock: mock
        )
    }

    /// Returns a list of transactions in the block (up to 25 transactions beginning at `start_index`).
    /// Transactions returned here do not have the status field, since all the transactions share the same /block and confirmation status.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash/txs[/:start_index]`
    public func blockTransactions(hash: Data, startIndex: Int? = nil, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Transaction] {
        try await call(
            returning: [Transaction].self,
            network: network,
            path: makePath(network, ["block", hash.hex, "txs", startIndex as Any]),
            mock: mock
        )
    }

    /// Returns a list of all txids in the block.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash/txids`
    public func blockTransactionIDs(hash: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Data] {
        try await call(
            returning: [HexData].self,
            network: network,
            path: makePath(network, ["block", hash.hex, "txids"]),
            mock: mock
        ).map { $0.data }
    }

    /// Returns the transaction at index :index within the specified block.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash/txid/:index`
    public func blockTransactionID(hash: Data, index: Int, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            returning: HexData.self,
            network: network,
            path: makePath(network, ["block", hash.hex, "txid", index]),
            mock: mock
        ).data
    }

    /// Returns the raw block representation in binary.
    ///
    /// The response from this endpoint can be cached indefinitely.
    ///
    /// `GET /block/:hash/raw`
    public func blockRaw(hash: Data, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            network: network,
            path: makePath(network, ["block", hash.hex, "raw"]),
            mock: mock
        )
    }

    /// Returns the hash of the block currently at `height`.
    ///
    /// `GET /block-height/:height`
    ///
    /// https://github.com/Blockstream/esplora/blob/master/API.md#get-block-heightheight
    public func blockHash(at height: Int, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Data {
        try await call(
            returning: HexData.self,
            network: network,
            path: makePath(network, ["block-height", height]),
            mock: mock
        ).data
    }

    /// Returns the 10 newest blocks starting at the tip or at `startHeight` if specified.
    ///
    /// `GET /blocks[/:start_height]`
    ///
    /// https://github.com/Blockstream/esplora/blob/master/API.md#get-blocksstart_height
    public func newestBlocks(startHeight: Int? = nil, network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Block] {
        try await call(
            returning: [Block].self,
            network: network,
            path: makePath(network, ["blocks", startHeight as Any]),
            mock: mock
        )
    }

    /// Returns the height of the last block.
    ///
    /// `GET /blocks/tip/height`
    ///
    /// https://github.com/Blockstream/esplora/blob/master/API.md#get-blockstipheight
    public func currentBlockHeight(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Int {
        try await call(
            returning: Int.self,
            network: network,
            path: makePath(network, ["blocks", "tip", "height"]),
            mock: mock
        )
    }
    
    /// Returns the hash of the last block.
    ///
    /// `GET /blocks/tip/hash`
    ///
    /// https://github.com/Blockstream/esplora/blob/master/API.md#get-blockstiphash
    public func latestBlockHash(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> String {
        try await call(
            returning: String.self,
            network: network,
            path: makePath(network, ["blocks", "tip", "hash"]),
            mock: mock
        )
    }
}

// MARK: - Mempool

extension Esplora {
    /// Get mempool backlog statistics. Returns an object with:
    ///
    /// * `count`: the number of transactions in the mempool
    /// * `vsize`: the total size of mempool transactions in virtual bytes
    /// * `total_fee`: the total fee paid by mempool transactions in satoshis
    /// * `fee_histogram`: mempool fee-rate distribution histogram
    ///
    /// An array of `(feerate, vsize)` tuples, where each entry's `vsize` is the total `vsize` of transactions paying more than `feerate` but less than the previous entry's `feerate` (except for the first entry, which has no upper bound). This matches the format used by the Electrum RPC protocol for `mempool.get_fee_histogram`.
    ///
    /// `GET /mempool`
    public func mempool(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> Mempool {
        try await call(
            returning: Mempool.self,
            network: network,
            path: makePath(network, ["mempool"]),
            mock: mock
        )
    }

    /// Get the full list of txids in the mempool as an array.
    ///
    /// The order of the txids is arbitrary and does not match bitcoind's.
    ///
    /// `GET /mempool/txids`
    public func mempoolTXIDs(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Data] {
        try await call(
            returning: [HexData].self,
            network: network,
            path: makePath(network, ["mempool", "txids"]),
            mock: mock
        ).map { $0.data }
    }

    /// Get a list of the last 10 transactions to enter the mempool.
    ///
    /// Each `MempoolTransaction` object contains simplified overview data, with the following fields: `txid`, `fee`, `vSize` and `value`.
    ///
    /// `GET /mempool/recent`
    public func mempoolRecentTransactions(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [MempoolTransaction] {
        try await call(
            returning: [MempoolTransaction].self,
            network: network,
            path: makePath(network, ["mempool", "recent"]),
            mock: mock
        )
    }
}

// MARK: - Fee estimates

extension Esplora {
    /// Get an object where the key is the confirmation target (in number of blocks) and the value is the estimated feerate (in sat/vB).
    ///
    /// The available confirmation targets are 1-25, 144, 504 and 1008 blocks.
    ///
    /// `GET /fee-estimates`
    public func feeEstimates(network: EsploraNetwork = .mainnet, mock: Mock? = nil) async throws -> [Int: Double] {
        try await call(
            returning: FeeEstimates.self,
            network: network,
            path: makePath(network, ["fee-estimates"]),
            mock: mock
        ).estimates
    }
}
