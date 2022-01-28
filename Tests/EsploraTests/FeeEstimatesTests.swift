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

class FeeEstimatesTests: XCTestCase {
    let api = Esplora()

    func testFeeEstimates() async throws {
        let estimates = try await api.feeEstimates()
        XCTAssertEqual(Array(estimates.keys).sorted(), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 144, 504, 1008])
    }
}
