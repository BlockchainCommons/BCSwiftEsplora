//
//  DecodeTests.swift
//  
//
//  Created by Wolf McNally on 1/26/22.
//

import XCTest
import Esplora
import WolfAPI
import WolfBase

class DecodeTests: XCTestCase {
    func testDecodeConfirmedTransactionStatus() throws {
        let json = """
            {
                "confirmed": true,
                "block_height": 720514,
                "block_hash": "00000000000000000006e0a49103f576090adc289de5d3e965a158929a2887f4",
                "block_time": 1643232826
            }
        """
        let status = try JSONDecoder().decode(TransactionStatus.self, from: json.utf8Data)
        switch status {
        case .confirmed(let confirmation):
            XCTAssertEqual(confirmation.blockHeight, 720514)
        default:
            XCTFail()
        }
    }

    func testDecodeUnconfirmedTransactionStatus() throws {
        let json = """
            { "confirmed": false }
        """
        let status = try JSONDecoder().decode(TransactionStatus.self, from: json.utf8Data)
        switch status {
        case .unconfirmed:
            break
        case .confirmed:
            XCTFail()
        }
    }
    
    func testDecodeTransactionOutput() throws {
        let json = """
            {
                "scriptpubkey": "0014732aad737f3f51e04681f70a377dee7ce43debf2",
                "scriptpubkey_asm": "OP_0 OP_PUSHBYTES_20 732aad737f3f51e04681f70a377dee7ce43debf2",
                "scriptpubkey_type": "v0_p2wpkh",
                "scriptpubkey_address": "bc1qwv426uml8ag7q35p7u9rwl0w0njrm6lju4uzvx",
                "value": 5066933
            }
        """
        let txout = try JSONDecoder().decode(TransactionOutput.self, from: json.utf8Data)
        XCTAssertEqual(txout.value, 5066933)
    }
    
    func testDecodeTransactionInput1() throws {
        let json = """
            {
                "txid": "173ae7d3fa6f06f756dc96ce83d0b1268f964ee7b9985f4b4233b17f0f3cf756",
                "vout": 4,
                "prevout": {
                    "scriptpubkey": "a914f2151bcd7c6b1a55bdfe2bb04c15dd131c05e80a87",
                    "scriptpubkey_asm": "OP_HASH160 OP_PUSHBYTES_20 f2151bcd7c6b1a55bdfe2bb04c15dd131c05e80a OP_EQUAL",
                    "scriptpubkey_type": "p2sh",
                    "scriptpubkey_address": "3Pm2jcp3N9hSNVqNEeSrYuGrhWQnqyKb65",
                    "value": 152941176
                },
                "scriptsig": "16001476e4db8a1d5c4c238775df63899f71dfda0197f4",
                "scriptsig_asm": "OP_PUSHBYTES_22 001476e4db8a1d5c4c238775df63899f71dfda0197f4",
                "witness": ["304402203753f910af75da7775a40363531f4d2f6e9ad44c165960e04749030048f4814602202ae2a07375aa017cf9c906eff5f9af81eb584fb05477a64c1ac4869f389617f901", "030c9daf8f58ccd1733de05574964eaf2810c5d6e2375dee0f49603151cf589e1d"],
                "is_coinbase": false,
                "sequence": 4294967294,
                "inner_redeemscript_asm": "OP_0 OP_PUSHBYTES_20 76e4db8a1d5c4c238775df63899f71dfda0197f4"
            }
        """
        let txin = try JSONDecoder().decode(TransactionInput.self, from: json.utf8Data)
        XCTAssertEqual(txin.previousTxid, "173ae7d3fa6f06f756dc96ce83d0b1268f964ee7b9985f4b4233b17f0f3cf756".hexData!)
    }
    
    func testDecodeTransactionInput2() throws {
        let json = """
            {
                "txid": "1da017b7a11babdea17d2324edb41cf893011bf86fd270295c4ecf6d790f45fc",
                "vout": 1,
                "prevout": {
                    "scriptpubkey": "0020701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                    "scriptpubkey_asm": "OP_0 OP_PUSHBYTES_32 701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                    "scriptpubkey_type": "v0_p2wsh",
                    "scriptpubkey_address": "bc1qwqdg6squsna38e46795at95yu9atm8azzmyvckulcc7kytlcckxswvvzej",
                    "value": 376589779
                },
                "scriptsig": "",
                "scriptsig_asm": "",
                "witness": ["", "3044022017edb9c89a9ff9eaf72ff6bd476f7e68e6b17d5511ea9c1171c3499c8e98125a0220056796949dfe439a538c893a17644fab1557ca0764efe2c069cb3bf34a6c588001", "3044022078d2ff8d1341e9f2f70a2dc84768f7072e872b0aa680208ea4292b3b92ec2468022072e3c90197f960695b8806e3233358c5dd182fd03326fb8f4817705a75cdedcb01", "52210375e00eb72e29da82b89367947f29ef34afb75e8654f6ea368e0acdfd92976b7c2103a1b26313f430c4b15bb1fdce663207659d8cac749a0e53d70eff01874496feff2103c96d495bfdd5ba4145e3e046fee45e84a8a48ad05bd8dbb395c011a32cf9f88053ae"],
                "is_coinbase": false,
                "sequence": 4294967295,
                "inner_witnessscript_asm": "OP_PUSHNUM_2 OP_PUSHBYTES_33 0375e00eb72e29da82b89367947f29ef34afb75e8654f6ea368e0acdfd92976b7c OP_PUSHBYTES_33 03a1b26313f430c4b15bb1fdce663207659d8cac749a0e53d70eff01874496feff OP_PUSHBYTES_33 03c96d495bfdd5ba4145e3e046fee45e84a8a48ad05bd8dbb395c011a32cf9f880 OP_PUSHNUM_3 OP_CHECKMULTISIG"
            }
        """
        let txin = try JSONDecoder().decode(TransactionInput.self, from: json.utf8Data)
        XCTAssertEqual(txin.sequence, 4294967295)
    }
    
    func testDecodeTransaction() throws {
        let json = """
        {
            "txid": "01c0cf156d8d7396358c60533d03cd0a5ee6ccdabc3b724eddc02e5e6068908f",
            "version": 1,
            "locktime": 0,
            "vin": [{
                "txid": "1da017b7a11babdea17d2324edb41cf893011bf86fd270295c4ecf6d790f45fc",
                "vout": 1,
                "prevout": {
                    "scriptpubkey": "0020701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                    "scriptpubkey_asm": "OP_0 OP_PUSHBYTES_32 701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                    "scriptpubkey_type": "v0_p2wsh",
                    "scriptpubkey_address": "bc1qwqdg6squsna38e46795at95yu9atm8azzmyvckulcc7kytlcckxswvvzej",
                    "value": 376589779
                },
                "scriptsig": "",
                "scriptsig_asm": "",
                "witness": ["", "3044022017edb9c89a9ff9eaf72ff6bd476f7e68e6b17d5511ea9c1171c3499c8e98125a0220056796949dfe439a538c893a17644fab1557ca0764efe2c069cb3bf34a6c588001", "3044022078d2ff8d1341e9f2f70a2dc84768f7072e872b0aa680208ea4292b3b92ec2468022072e3c90197f960695b8806e3233358c5dd182fd03326fb8f4817705a75cdedcb01", "52210375e00eb72e29da82b89367947f29ef34afb75e8654f6ea368e0acdfd92976b7c2103a1b26313f430c4b15bb1fdce663207659d8cac749a0e53d70eff01874496feff2103c96d495bfdd5ba4145e3e046fee45e84a8a48ad05bd8dbb395c011a32cf9f88053ae"],
                "is_coinbase": false,
                "sequence": 4294967295,
                "inner_witnessscript_asm": "OP_PUSHNUM_2 OP_PUSHBYTES_33 0375e00eb72e29da82b89367947f29ef34afb75e8654f6ea368e0acdfd92976b7c OP_PUSHBYTES_33 03a1b26313f430c4b15bb1fdce663207659d8cac749a0e53d70eff01874496feff OP_PUSHBYTES_33 03c96d495bfdd5ba4145e3e046fee45e84a8a48ad05bd8dbb395c011a32cf9f880 OP_PUSHNUM_3 OP_CHECKMULTISIG"
            }],
            "vout": [{
                "scriptpubkey": "76a914e739d7ecde8bf854cbcab08d06a6d4efb6e39f8188ac",
                "scriptpubkey_asm": "OP_DUP OP_HASH160 OP_PUSHBYTES_20 e739d7ecde8bf854cbcab08d06a6d4efb6e39f81 OP_EQUALVERIFY OP_CHECKSIG",
                "scriptpubkey_type": "p2pkh",
                "scriptpubkey_address": "1N5cPM7Uk1ex2mHYFXtfyX8hXqKaJc47YG",
                "value": 5000000
            }, {
                "scriptpubkey": "76a914ac91e4d3acc5972f60a2e6f572deb9063df6587688ac",
                "scriptpubkey_asm": "OP_DUP OP_HASH160 OP_PUSHBYTES_20 ac91e4d3acc5972f60a2e6f572deb9063df65876 OP_EQUALVERIFY OP_CHECKSIG",
                "scriptpubkey_type": "p2pkh",
                "scriptpubkey_address": "1GjTzsuBqXmj6kUUypJciZ2Wczp3EQLamN",
                "value": 69594023
            }, {
                "scriptpubkey": "0020701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                "scriptpubkey_asm": "OP_0 OP_PUSHBYTES_32 701a8d401c84fb13e6baf169d59684e17abd9fa216c8cc5b9fc63d622ff8c58d",
                "scriptpubkey_type": "v0_p2wsh",
                "scriptpubkey_address": "bc1qwqdg6squsna38e46795at95yu9atm8azzmyvckulcc7kytlcckxswvvzej",
                "value": 301955756
            }],
            "size": 416,
            "weight": 902,
            "fee": 40000,
            "status": {
                "confirmed": true,
                "block_height": 720514,
                "block_hash": "00000000000000000006e0a49103f576090adc289de5d3e965a158929a2887f4",
                "block_time": 1643232826
            }
        }
        """
        let tx = try JSONDecoder().decode(Transaction.self, from: json.utf8Data)
        print(tx)
    }
    
    func testDecodeTransactions() throws {
        let json = #"{"txid":"4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b","version":1,"locktime":0,"vin":[{"txid":"0000000000000000000000000000000000000000000000000000000000000000","vout":4294967295,"prevout":null,"scriptsig":"04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73","scriptsig_asm":"OP_PUSHBYTES_4 ffff001d OP_PUSHBYTES_1 04 OP_PUSHBYTES_69 5468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73","is_coinbase":true,"sequence":4294967295}],"vout":[{"scriptpubkey":"4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac","scriptpubkey_asm":"OP_PUSHBYTES_65 04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f OP_CHECKSIG","scriptpubkey_type":"p2pk","value":5000000000}],"size":204,"weight":816,"fee":0,"status":{"confirmed":true,"block_height":0,"block_hash":"000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f","block_time":1231006505}}"#
        let tx = try JSONDecoder().decode(Transaction.self, from: json.utf8Data)
        XCTAssertEqual(tx.inputs[0].scriptSig!.suffix(69).utf8!, "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks")
    }
    
    func testDecodeMerkleProof() throws {
        let json = #"{"block_height":720514,"merkle":["b10c8c37c8fd414461e9a3d919a570b170da94567bb5a6f7138be8e99fced1d9","ffd38aa5d1d4ae612115d5afbf4f11e297609d172fd1c8573d16ecc421427130","bd5f637b7521f703f0a82f97d02c3fc5313d30807d88e874860282f9fb646955","c23fd3b09dbabcaba5428f327d720eda7129afde5dee1e680af8997e7b91eb09","a4a7004ac784ad37bd89a75b7bad9e0de59072d6af8c52952d88d77d4475453d","9c5474739e9c58a879753d6dc6d948ab7e52485e487fb1a9b97097545c4076ad","1b2d0b6f9ef4822bb1357984e9209d547a72d605e044dde6c429c4631c4a132d","bc1484ff6f7e3e0c809ef5a4126c61d18bc82f00d174c55f120a78138e0d6cf3","06a7663f10eb4f27e2ac6d388bd5a3a4ba8a27cc9479e5f5295194113e205e6b","67280f1ca5d020a51ea55677257902466b20d61d67e4eedc978e62e6bf377740","fd0a08fc9a8ff409d24723e7e3890a9653fe065756a04aa7d816e98297c35012","a7b2b4d557adffe74b2a97d844653517c9fced589a8cd84e4ab55e6a65909114"],"pos":0}"#
        let proof = try JSONDecoder().decode(MerkleProof.self, from: json.utf8Data)
        XCTAssertEqual(proof.merkle[0], "b10c8c37c8fd414461e9a3d919a570b170da94567bb5a6f7138be8e99fced1d9".hexData!)
    }

    func testTransactionOutputStatus1() throws {
        let json = #"{"spent":false}"#
        let status = try JSONDecoder().decode(TransactionOutputStatus.self, from: json.utf8Data)
        XCTAssertFalse(status.isSpent)
    }

    func testTransactionOutputStatus2() throws {
        let json = #"{"spent":true,"txid":"f3e6066078e815bb24db0dfbff814f738943bddaaa76f8beba360cfe2882480a","vin":12,"status":{"confirmed":true,"block_height":266668,"block_hash":"00000000000000066283fa21e3d99992e9a3eef59aa5f423928d44084719166b","block_time":1383031777}}"#
        let status = try JSONDecoder().decode(TransactionOutputStatus.self, from: json.utf8Data)
        XCTAssertTrue(status.isSpent)
        XCTAssertEqual(status.spent!.txid, "f3e6066078e815bb24db0dfbff814f738943bddaaa76f8beba360cfe2882480a".hexData!)
    }
    
    func testAddressInfo() throws {
        let json = #"{"address":"bc1qq7gm20tgeauggamlh7m54fu9e54vkdyzxzy5rh","chain_stats":{"funded_txo_count":1,"funded_txo_sum":94641,"spent_txo_count":0,"spent_txo_sum":0,"tx_count":1},"mempool_stats":{"funded_txo_count":0,"funded_txo_sum":0,"spent_txo_count":1,"spent_txo_sum":94641,"tx_count":1}}"#
        let info = try JSONDecoder().decode(AddressInfo.self, from: json.utf8Data)
        XCTAssertEqual(info.chainStats.fundedTXOSum, info.mempoolStats.spentTXOSum)
    }
    
    func testMempool() throws {
        let json = #"{"count":811,"vsize":412270,"total_fee":3632256,"fee_histogram":[[10.029498,50229],[9.032258,50227],[7.178016,50777],[6.000139,70350],[5.014647,51225],[2.0,50343],[1.0102464,51666],[1.0,37453]]}"#
        let mempool = try JSONDecoder().decode(Mempool.self, from: json.utf8Data)
        XCTAssertEqual(mempool.feeHistogram.bars.count, 8)
    }
    
    func testMempoolTransaction() throws {
        let json = #"[{"txid":"a8d826af0027ecf5bfe180fadff4b0bdd07e451c53a8a48efbb89d8219adf8b6","fee":1078,"vsize":211,"value":1386470},{"txid":"8aa5ffd6dc8e553dd851037c63012c9aaaa904dd1a7f7276e717034d6947d111","fee":730,"vsize":143,"value":13547198},{"txid":"2daad4e5f6e5958a8c5ca55f3f57b53bf3d2cccc758090668d54a5bebdfecacc","fee":45491,"vsize":348,"value":171006753},{"txid":"f2cd037262b3df95d944ed21d9043bf5b4cc01de39a4956a54d27e2a4e056580","fee":1793,"vsize":141,"value":458515},{"txid":"e68e866c2abe3952d65863cd7ea0f3af156365e9f350204195e2fc97b17a9e7d","fee":39927,"vsize":110,"value":395074},{"txid":"5014a1420ba12f5be381895395e1d6fa7d4146c0a15dddef87f7107f573ae37f","fee":1482,"vsize":141,"value":194855857},{"txid":"8d5d3897f11052962479147026c1c815148a5bf80c7a132e49e35b292f48b321","fee":664,"vsize":165,"value":328719},{"txid":"5618f46c305d368b673db481104e671ef56222a2e46371ea4c82382e00a4afed","fee":166,"vsize":165,"value":1009296},{"txid":"c2f18a83b67c5eed9f7ab9f96f8395b7519527013dbb59d5e5e5b54e6188098e","fee":3525,"vsize":140,"value":10613873},{"txid":"5a2359adc7ea4736a5317800452d7c96271f96e358177f5a043a2817d3071d6c","fee":420,"vsize":140,"value":901219}]"#

        let transactions = try JSONDecoder().decode([MempoolTransaction].self, from: json.utf8Data)
        XCTAssertEqual(transactions.count, 10)
    }
    
    func testFeeEstimates() async throws {
        let json = #"{"11":2.326,"20":1.0,"4":5.631,"6":4.9799999999999995,"17":1.02,"5":4.9799999999999995,"1":8.421,"7":4.9799999999999995,"16":1.02,"9":4.645,"19":1.0,"21":1.0,"13":1.307,"3":6.954,"22":1.0,"23":1.0,"24":1.0,"144":1.0,"504":1.0,"18":1.0,"1008":1.0,"15":1.081,"25":1.0,"2":8.421,"8":4.645,"14":1.121,"12":2.237,"10":4.645}"#
        let estimates = try await Esplora().feeEstimates(mock: Mock(string: json))
        XCTAssertEqual(Array(estimates.keys).sorted(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 144, 504, 1008])
    }
    
    func testUTXO() throws {
        let json = #"{"txid":"143540c0323d13a55c328bcfa2d48663b7b4a21d4d1482e51f52e31cdfbaec8f","vout":0,"status":{"confirmed":false},"value":227480}"#
        let utxo = try JSONDecoder().decode(UTXO.self, from: json.utf8Data)
        XCTAssertEqual(utxo.value, 227480)
    }
}
