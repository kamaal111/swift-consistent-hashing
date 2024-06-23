//
//  SwiftConsistentHashing.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import CryptoKit
import Foundation

public enum ConsistentHashRingHashingAlgorithms {
    case sha256

    func hash(_ message: String) -> String {
        switch self {
        case .sha256: SHA256
                .hash(data: message.data(using: .utf8)!)
                .compactMap({ byte in String(format: "%02x", byte) })
                .joined()
        }
    }
}

public class ConsistentHashRing {
    private var ring: [Int: String]
    private var keys: Set<Int>
    private var replicas: Int
    private var hashingAlgorithm: ConsistentHashRingHashingAlgorithms

    public init(replicas: Int, hashingAlgorithm: ConsistentHashRingHashingAlgorithms = .sha256) {
        self.ring = [:]
        self.keys = Set()
        self.replicas = replicas
        self.hashingAlgorithm = hashingAlgorithm
    }

    public func addNode() { }

    public func removeNode() { }

    public func getNode() { }
}
