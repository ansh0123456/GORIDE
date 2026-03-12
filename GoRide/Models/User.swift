//
//  User.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

enum UserRole: String, Codable {
    case customer
    case owner
}

struct User: Equatable, Codable {
    let userId: UUID
    var name: String
    var email: String
    var phoneNumber: String
    var password: String
    var role: UserRole
    var profilePhoto: String?
    var driverLicense: String?
    var createdAt: Date
    
    init(name: String, email: String, phoneNumber: String, password: String, role: UserRole, profilePhoto: String?, driverLicense: String?, createdAt: Date) {
        self.userId = UUID()
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.role = role
        self.profilePhoto = profilePhoto
        self.driverLicense = driverLicense
        self.createdAt = createdAt
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId
    }
}

class UserDataModel {
    
    static let shared = UserDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var users: [User] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("users").appendingPathExtension("plist")
        loadUsers()
    }
    
    // MARK: - Public Methods
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func addUser(_ user: User) {
        users.append(user)
        saveUsers()
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.userId == user.userId }) {
            users[index] = user
            saveUsers()
        }
    }
    
    func deleteUser(at index: Int) {
        users.remove(at: index)
        saveUsers()
    }
    
    // MARK: - Private Methods
    
    private func loadUsers() {
        if let savedUsers = loadUsersFromDisk() {
            users = savedUsers
        } else {
            users = loadSampleUsers()
        }
    }
    
    private func loadUsersFromDisk() -> [User]? {
        guard let codedUsers = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([User].self, from: codedUsers)
    }
    
    private func saveUsers() {
        let propertyListEncoder = PropertyListEncoder()
        let codedUsers = try? propertyListEncoder.encode(users)
        try? codedUsers?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleUsers() -> [User] {
        let user1 = User(name: "John Doe", email: "john@example.com", phoneNumber: "9876543210", password: "password123", role: .customer, profilePhoto: nil, driverLicense: "DL001", createdAt: Date())
        let user2 = User(name: "Jane Smith", email: "jane@example.com", phoneNumber: "9876543211", password: "password456", role: .owner, profilePhoto: nil, driverLicense: "DL002", createdAt: Date())
        let user3 = User(name: "Bob Wilson", email: "bob@example.com", phoneNumber: "9876543212", password: "password789", role: .customer, profilePhoto: nil, driverLicense: "DL003", createdAt: Date())
        return [user1, user2, user3]
    }
}
