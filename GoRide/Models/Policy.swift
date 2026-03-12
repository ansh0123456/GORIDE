//
//  Policy.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

struct Policy: Equatable, Codable {
    let policyId: UUID
    var vehicleId: UUID
    var policyText: String
    
    init(vehicleId: UUID, policyText: String) {
        self.policyId = UUID()
        self.vehicleId = vehicleId
        self.policyText = policyText
    }
    
    static func ==(lhs: Policy, rhs: Policy) -> Bool {
        return lhs.policyId == rhs.policyId
    }
}

class PolicyDataModel {
    
    static let shared = PolicyDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var policies: [Policy] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("policies").appendingPathExtension("plist")
        loadPolicies()
    }
    
    // MARK: - Public Methods
    
    func getAllPolicies() -> [Policy] {
        return policies
    }
    
    func addPolicy(_ policy: Policy) {
        policies.append(policy)
        savePolicies()
    }
    
    func updatePolicy(_ policy: Policy) {
        if let index = policies.firstIndex(where: { $0.policyId == policy.policyId }) {
            policies[index] = policy
            savePolicies()
        }
    }
    
    func deletePolicy(at index: Int) {
        policies.remove(at: index)
        savePolicies()
    }
    
    // MARK: - Private Methods
    
    private func loadPolicies() {
        if let savedPolicies = loadPoliciesFromDisk() {
            policies = savedPolicies
        } else {
            policies = loadSamplePolicies()
        }
    }
    
    private func loadPoliciesFromDisk() -> [Policy]? {
        guard let codedPolicies = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Policy].self, from: codedPolicies)
    }
    
    private func savePolicies() {
        let propertyListEncoder = PropertyListEncoder()
        let codedPolicies = try? propertyListEncoder.encode(policies)
        try? codedPolicies?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSamplePolicies() -> [Policy] {
        let policy1 = Policy(vehicleId: UUID(), policyText: "Fuel must be refilled to the same level as at pickup. No smoking inside the vehicle.")
        let policy2 = Policy(vehicleId: UUID(), policyText: "Late returns will be charged an additional 50% of the daily rate per extra hour.")
        let policy3 = Policy(vehicleId: UUID(), policyText: "Valid driving license required at the time of pickup. Minimum age: 21 years.")
        return [policy1, policy2, policy3]
    }
}
