//
//  Customer.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

struct Customer: Equatable, Codable {
    let customerId: UUID
    var userId: UUID
    var bookingHistory: [UUID]
    var savedVehicles: [UUID]
    var preferredVehicleType: String?
    
    init(userId: UUID, bookingHistory: [UUID], savedVehicles: [UUID], preferredVehicleType: String?) {
        self.customerId = UUID()
        self.userId = userId
        self.bookingHistory = bookingHistory
        self.savedVehicles = savedVehicles
        self.preferredVehicleType = preferredVehicleType
    }
    
    static func ==(lhs: Customer, rhs: Customer) -> Bool {
        return lhs.customerId == rhs.customerId
    }
}

class CustomerDataModel {
    
    static let shared = CustomerDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var customers: [Customer] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("customers").appendingPathExtension("plist")
        loadCustomers()
    }
    
    // MARK: - Public Methods
    
    func getAllCustomers() -> [Customer] {
        return customers
    }
    
    func addCustomer(_ customer: Customer) {
        customers.append(customer)
        saveCustomers()
    }
    
    func updateCustomer(_ customer: Customer) {
        if let index = customers.firstIndex(where: { $0.customerId == customer.customerId }) {
            customers[index] = customer
            saveCustomers()
        }
    }
    
    func deleteCustomer(at index: Int) {
        customers.remove(at: index)
        saveCustomers()
    }
    
    // MARK: - Private Methods
    
    private func loadCustomers() {
        if let savedCustomers = loadCustomersFromDisk() {
            customers = savedCustomers
        } else {
            customers = loadSampleCustomers()
        }
    }
    
    private func loadCustomersFromDisk() -> [Customer]? {
        guard let codedCustomers = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Customer].self, from: codedCustomers)
    }
    
    private func saveCustomers() {
        let propertyListEncoder = PropertyListEncoder()
        let codedCustomers = try? propertyListEncoder.encode(customers)
        try? codedCustomers?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleCustomers() -> [Customer] {
        let customer1 = Customer(userId: UUID(), bookingHistory: [], savedVehicles: [], preferredVehicleType: "Sedan")
        let customer2 = Customer(userId: UUID(), bookingHistory: [], savedVehicles: [], preferredVehicleType: "SUV")
        let customer3 = Customer(userId: UUID(), bookingHistory: [], savedVehicles: [], preferredVehicleType: "Bike")
        return [customer1, customer2, customer3]
    }
}
