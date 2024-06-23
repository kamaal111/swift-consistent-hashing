//
//  SwiftConsistentHashing.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import CryptoKit
import Foundation
import Collections

public class ConsistentHashRing {
    public typealias Node = String
    public typealias RingHash = String

    private(set) var ring: [RingHash: Node]
    private(set) var keys: OrderedSet<RingHash>
    private var replicas: Int
    private var hashingAlgorithm: ConsistentHashRingHashingAlgorithms

    public init(replicas: Int, hashingAlgorithm: ConsistentHashRingHashingAlgorithms = .sha256) {
        self.ring = [:]
        self.keys = OrderedSet()
        self.replicas = replicas
        self.hashingAlgorithm = hashingAlgorithm
    }

    public func addNode(_ node: Node) {
        for i in 0..<replicas {
            let key = hashingAlgorithm.hash("\(node)_\(i)")
            ring[key] = node
            keys.append(key)
        }
        keys.sort()
    }

    public func removeNode(_ node: Node) {
        for i in 0..<replicas {
            let key = hashingAlgorithm.hash("\(node)_\(i)")
            ring.removeValue(forKey: key)
            keys.remove(key)
        }
    }

    public func getNode(at key: RingHash) -> Node? {
        guard !keys.isEmpty else { return nil }

        let hashedKey = hashingAlgorithm.hash(key)
        let matchingKey = keys.first(where: { key in key >= hashedKey }) ?? keys.first!
        return ring[matchingKey]
    }
}

public enum ConsistentHashRingHashingAlgorithms {
    case sha256

    func hash(_ message: String) -> String {
        switch self {
        case .sha256:
            let data = message.data(using: .utf8)!
            return SHA256
                .hash(data: data)
                .compactMap({ byte in String(format: "%02x", byte) })
                .joined()
        }
    }
}
