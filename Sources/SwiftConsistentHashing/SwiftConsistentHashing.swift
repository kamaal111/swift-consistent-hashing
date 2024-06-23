//
//  SwiftConsistentHashing.swift
//  
//
//  Created by Kamaal M Farah on 23/06/2024.
//

import Foundation
import CommonCrypto

public enum ConsistentHashRingHashingAlgorithms {
    case sha256

    func hash(_ message: String) -> String? {
        switch self {
        case .sha256: SHA256.hash(message)
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

private enum SHA256 {
    static func hash(_ message: String) -> String? {
        guard let encodedMessage = message.data(using: .utf8) else { return nil }

        return hexStringFromData(input: digest(input: encodedMessage as NSData))
    }

    static private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)

        return NSData(bytes: hash, length: digestLength)
    }

    static private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        return bytes.reduce("") { result, byte in
            result + String(format:"%02x", UInt8(byte))
        }
    }
}
