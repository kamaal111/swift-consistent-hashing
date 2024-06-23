//
//  ConsistentHashRingTests.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Testing
@testable import SwiftConsistentHashing

@Suite
struct ConsistentHashRingTests {
    @Test
    func addNode() throws {
        let replicaAmount = 10
        let hashRing = ConsistentHashRing<String>(replicas: replicaAmount)

        let inputNodes = [
            "mario",
            "maria",
        ]
        for (index, inputNode) in inputNodes.enumerated() {
            hashRing.addNode(inputNode)

            #expect(hashRing.keys.count == ((index + 1) * replicaAmount))
            #expect(hashRing.keys.count == hashRing.ring.count)
        }
    }

    @Test
    func removeNode() throws {
        let replicaAmount = 20
        let hashRing = ConsistentHashRing<String>(replicas: replicaAmount)

        let inputNodes = [
            "kevin",
            "rock",
            "apple",
        ]
        for inputNode in inputNodes {
            hashRing.addNode(inputNode)
        }
        #expect(hashRing.ring.values.count == (replicaAmount * inputNodes.count))

        for i in (0..<inputNodes.count).shuffled().prefix(inputNodes.count - 1) {
            var inputNodes = inputNodes
            let nodeToRemove = inputNodes.remove(at: i)
            hashRing.removeNode(nodeToRemove)

            #expect(!hashRing.ring.values.contains(nodeToRemove))

            var nodesFound = Set<String>()
            for i in 0..<50 {
                let node = try #require(hashRing.getNode(at: "request_\(i)"))
                #expect(inputNodes.contains(node))
                nodesFound.insert(node)
            }

            #expect(!nodesFound.contains(nodeToRemove))
        }
    }

    @Test
    func getNode() throws {
        let replicaAmount = 30
        let hashRing = ConsistentHashRing<String>(replicas: replicaAmount)

        let inputNodes = [
            "kamaal",
            "john",
            "jane",
        ]
        for inputNode in inputNodes {
            hashRing.addNode(inputNode)
        }

        var nodesFound = [String: Int]()
        for i in 0..<50 {
            let node = try #require(hashRing.getNode(at: "request_\(i)"))
            #expect(inputNodes.contains(node))
            nodesFound[node] = (nodesFound[node] ?? 0) + 1
        }

        #expect(nodesFound.keys.sorted() == inputNodes.sorted())
    }
}
