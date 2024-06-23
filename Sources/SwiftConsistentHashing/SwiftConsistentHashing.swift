//
//  SwiftConsistentHashing.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import CryptoKit
import Foundation
import Collections

public class ConsistentHashRing<Node: DataProtocol> {
    public typealias RingHash = String

    private(set) var ring: [RingHash: Node]
    private(set) var keys: OrderedSet<RingHash>
    private let replicas: Int
    private let hashingAlgorithm: ConsistentHashRingHashingAlgorithms

    public init(replicas: Int, hashingAlgorithm: ConsistentHashRingHashingAlgorithms = .sha256) {
        self.ring = [:]
        self.keys = OrderedSet()
        self.replicas = replicas
        self.hashingAlgorithm = hashingAlgorithm
    }

    public func addNode(_ node: Node) {
        let nodeString = decodeNodeForKey(node)
        for i in 0..<replicas {
            let key = hashingAlgorithm.hash(encodeKey("\(nodeString)_\(i)"))
            ring[key] = node
            keys.append(key)
        }
        keys.sort()
    }

    public func removeNode(_ node: Node) {
        let nodeString = decodeNodeForKey(node)
        for i in 0..<replicas {
            let key = hashingAlgorithm.hash(encodeKey("\(nodeString)_\(i)"))
            ring.removeValue(forKey: key)
            keys.remove(key)
        }
    }

    public func getNode(at key: RingHash) -> Node? {
        guard !keys.isEmpty else { return nil }

        let hashedKey = hashingAlgorithm.hash(encodeKey(key))
        let matchingKey = keys.first(where: { key in key >= hashedKey }) ?? keys.first!
        return ring[matchingKey]
    }

    private func encodeKey(_ key: RingHash) -> some DataProtocol {
        key.data(using: .utf8)!
    }

    private func decodeNodeForKey(_ node: Node) -> String {
        String(decoding: node, as: UTF8.self)
    }
}

public enum ConsistentHashRingHashingAlgorithms {
    case sha256

    func hash(_ data: some DataProtocol) -> String {
        switch self {
        case .sha256:
            SHA256
                .hash(data: data)
                .compactMap({ byte in String(format: "%02x", byte) })
                .joined()
        }
    }
}
