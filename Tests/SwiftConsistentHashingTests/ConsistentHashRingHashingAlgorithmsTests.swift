//
//  ConsistentHashRingHashingAlgorithmsTests.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Testing
@testable import SwiftConsistentHashing

@Suite
struct ConsistentHashRingHashingAlgorithmsTests {
    @Test
    func sha256KeepsHashingTheSame() async throws {
        let algorithm: ConsistentHashRingHashingAlgorithms = .sha256

        #expect(algorithm.hash("kamaal".data(using: .utf8)!) == "d65cf15e9d991a2c3bad9b1e1dffaaaa2244de1a2c30da129e709d3e4f43150f")
    }
}
