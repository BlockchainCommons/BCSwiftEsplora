# BCSwiftEsplora

A pure Swift interface to the [Esplora block explorer](https://github.com/Blockstream/esplora) REST API.

Takes full advantage of Swift 5.5's concurrency architecture.

## Building

Add to your project like any other Swift Package.

## Usage

See the unit tests for examples of every API call.

```swift
import Esplora

/// Find the last transaction in the latest block and print the addresses of its outputs.
func testEsplora() async throws {
    // Instantiate the API.
    let esplora = Esplora(host: "blockstream.info")
    
    // Get the current blockchain height.
    let blockHeight = try await esplora.currentBlockHeight()
    print(blockHeight)
    // 720712
    
    // Get the hash (ID) of the most recent block.
    let latestBlockHash = try await esplora.blockHash(at: blockHeight)
    print(latestBlockHash.hex)
    // 000000000000000000054fa746a7a19ba190f5dacad05087c8dfc725ff1f6ef8
    
    // Get the time the latest block was added.
    let latestBlock = try await esplora.block(hash: latestBlockHash)
    print(latestBlock.timestamp)
    // 2022-01-28 07:12:51 +0000
    
    // Get the IDs of all the transactions in the block
    let latestBlockTXIDs = try await esplora.blockTransactionIDs(hash: latestBlockHash)
    // Extract the ID of the last transaction in the block
    let latestTXID = latestBlockTXIDs.last!
    print(latestTXID.hex)
    // b10f61f106284c626d2d9bbc874c1d3e723cdacbaa508338b219620457dc7b52
    
    // Get the transaction and print all of its output addresses
    let tx = try await esplora.transaction(txid: latestTXID)
    let txAddresses = tx.outputs.compactMap { $0.scriptPubKeyAddress }
    print(txAddresses)
    // ["bc1qm34lsc65zpw79lxes69zkqmk6ee3ewf0j77s3h", "bc1qslxt46qzcp0uqeq09wnhfz7cxeepvmgysqt2ve"]
}

/// Print the estimated fee in number of satoshis/vB needed to confirm a transaction within the next 3 blocks.
func testFeeEstimate() async throws {
    let esplora = Esplora(host: "blockstream.info")
    let estimates = try await esplora.feeEstimates()
    print(estimates[3]!)
    // 5.074
}
```
