//
//  ConsistentHashRingTests.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Testing
import Foundation
@testable import SwiftConsistentHashing

@Suite
struct ConsistentHashRingTests {
    @Test func hashingWithCodableObjects() async throws {
        let hashRing = ConsistentHashRing<Data>(replicas: 5)
        let inputNodes = [
            TestInputNode(name: "base"),
            TestInputNode(name: "camp"),
        ]
        let inputNodesAsData = try inputNodes
            .map({ node in try JSONEncoder().encode(node) })

        for inputNode in inputNodesAsData {
            hashRing.addNode(inputNode)
        }

        let node = try #require(hashRing.getNode(at: "anything888"))
        let decodedNode = try JSONDecoder().decode(TestInputNode.self, from: node)

        #expect(decodedNode == inputNodes[0])
    }

    @Test
    func addNode() throws {
        let replicaAmount = 10
        let hashRing = ConsistentHashRing<Data>(replicas: replicaAmount)

        let inputNodes = [
            "mario",
            "maria",
        ]
            .map({ inputNode in inputNode.data(using: .japaneseEUC) })
        for (index, inputNode) in inputNodes.enumerated() {
            let inputNode = try #require(inputNode)
            hashRing.addNode(inputNode)

            #expect(hashRing.keys.count == ((index + 1) * replicaAmount))
            #expect(hashRing.keys.count == hashRing.ring.count)
        }
    }

    @Test
    func removeNode() throws {
        let replicaAmount = 20
        let hashRing = ConsistentHashRing<Data>(replicas: replicaAmount)

        let inputNodes = [
            "kevin",
            "rock",
            "apple",
        ]
            .map({ inputNode in inputNode.data(using: .isoLatin2) })
        for inputNode in inputNodes {
            let inputNode = try #require(inputNode)
            hashRing.addNode(inputNode)
        }
        #expect(hashRing.ring.values.count == (replicaAmount * inputNodes.count))

        for i in (0..<inputNodes.count).shuffled().prefix(inputNodes.count - 1) {
            var inputNodes = inputNodes
            let nodeToRemove = inputNodes.remove(at: i)
            let unwrappedNodeToRemove = try #require(nodeToRemove)
            hashRing.removeNode(unwrappedNodeToRemove)

            #expect(!hashRing.ring.values.contains(unwrappedNodeToRemove))

            var nodesFound = Set<Data>()
            for i in 0..<50 {
                let node = try #require(hashRing.getNode(at: "request_\(i)"))
                #expect(inputNodes.contains(node))
                nodesFound.insert(node)
            }

            #expect(!nodesFound.contains(unwrappedNodeToRemove))
        }
    }

    @Test
    func getNode() throws {
        let replicaAmount = 30
        let hashRing = ConsistentHashRing<Data>(replicas: replicaAmount)

        let inputNodes = [
            "kamaal",
            "john",
            "jane",
        ]
            .map({ inputNode in inputNode.data(using: .ascii) })
        for inputNode in inputNodes {
            let inputNode = try #require(inputNode)
            hashRing.addNode(inputNode)
        }

        for i in 0..<50 {
            let node = try #require(hashRing.getNode(at: "request_\(i)"))
            #expect(inputNodes.contains(node))
        }
    }
}

struct TestInputNode: Codable, Hashable {
    let name: String
}
