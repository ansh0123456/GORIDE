//
//  Owner.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

enum VerificationStatus: String, Codable {
    case pending
    case verified
    case rejected
}

struct Owner: Equatable, Codable {
    let ownerId: UUID
    var userId: UUID
    var listedVehicles: [UUID]
    var rating: Double
    var verificationStatus: VerificationStatus
    
    init(userId: UUID, listedVehicles: [UUID], rating: Double, verificationStatus: VerificationStatus) {
        self.ownerId = UUID()
        self.userId = userId
        self.listedVehicles = listedVehicles
        self.rating = rating
        self.verificationStatus = verificationStatus
    }
    
    static func ==(lhs: Owner, rhs: Owner) -> Bool {
        return lhs.ownerId == rhs.ownerId
    }
}

class OwnerDataModel {
    
    static let shared = OwnerDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var owners: [Owner] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("owners").appendingPathExtension("plist")
        loadOwners()
    }
    
    // MARK: - Public Methods
    
    func getAllOwners() -> [Owner] {
        return owners
    }
    
    func addOwner(_ owner: Owner) {
        owners.append(owner)
        saveOwners()
    }
    
    func updateOwner(_ owner: Owner) {
        if let index = owners.firstIndex(where: { $0.ownerId == owner.ownerId }) {
            owners[index] = owner
            saveOwners()
        }
    }
    
    func deleteOwner(at index: Int) {
        owners.remove(at: index)
        saveOwners()
    }
    
    // MARK: - Private Methods
    
    private func loadOwners() {
        if let savedOwners = loadOwnersFromDisk() {
            owners = savedOwners
        } else {
            owners = loadSampleOwners()
        }
    }
    
    private func loadOwnersFromDisk() -> [Owner]? {
        guard let codedOwners = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Owner].self, from: codedOwners)
    }
    
    private func saveOwners() {
        let propertyListEncoder = PropertyListEncoder()
        let codedOwners = try? propertyListEncoder.encode(owners)
        try? codedOwners?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleOwners() -> [Owner] {
        let owner1 = Owner(userId: UUID(), listedVehicles: [], rating: 4.5, verificationStatus: .verified)
        let owner2 = Owner(userId: UUID(), listedVehicles: [], rating: 4.0, verificationStatus: .pending)
        let owner3 = Owner(userId: UUID(), listedVehicles: [], rating: 3.8, verificationStatus: .verified)
        return [owner1, owner2, owner3]
    }
}
