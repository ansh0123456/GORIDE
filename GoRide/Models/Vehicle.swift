//
//  Vehicle.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

// MARK: - Enums

enum VehicleType: String, Codable {
    case bike = "Bike"
    case sedan = "Sedan"
    case suv = "SUV"
    case hatchback = "Hatchback"
}

enum TransmissionType: String, Codable {
    case manual = "Manual"
    case automatic = "Automatic"
}

enum FuelType: String, Codable {
    case petrol = "Petrol"
    case diesel = "Diesel"
    case electric = "Electric"
    case hybrid = "Hybrid"
}

// MARK: - Vehicle

struct Vehicle: Equatable, Codable {
    let vehicleId: UUID
    var ownerId: UUID
    var vehicleName: String
    var brand: String
    var model: String
    var year: Int
    var vehicleType: VehicleType
    var transmission: TransmissionType
    var fuelType: FuelType
    var fuelCapacity: Double
    var engine: String
    var seatingCapacity: Int
    var pricePerDay: Double
    var location: String
    var description: String
    var availabilityStatus: Bool
    var createdAt: Date
    
    init(ownerId: UUID, vehicleName: String, brand: String, model: String, year: Int, vehicleType: VehicleType, transmission: TransmissionType, fuelType: FuelType, fuelCapacity: Double, engine: String, seatingCapacity: Int, pricePerDay: Double, location: String, description: String, availabilityStatus: Bool, createdAt: Date) {
        self.vehicleId = UUID()
        self.ownerId = ownerId
        self.vehicleName = vehicleName
        self.brand = brand
        self.model = model
        self.year = year
        self.vehicleType = vehicleType
        self.transmission = transmission
        self.fuelType = fuelType
        self.fuelCapacity = fuelCapacity
        self.engine = engine
        self.seatingCapacity = seatingCapacity
        self.pricePerDay = pricePerDay
        self.location = location
        self.description = description
        self.availabilityStatus = availabilityStatus
        self.createdAt = createdAt
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.vehicleId == rhs.vehicleId
    }
}

class VehicleDataModel {
    
    static let shared = VehicleDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var vehicles: [Vehicle] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("vehicles").appendingPathExtension("plist")
        loadVehicles()
    }
    
    // MARK: - Public Methods
    
    func getAllVehicles() -> [Vehicle] {
        return vehicles
    }
    
    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
        saveVehicles()
    }
    
    func updateVehicle(_ vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.vehicleId == vehicle.vehicleId }) {
            vehicles[index] = vehicle
            saveVehicles()
        }
    }
    
    func deleteVehicle(at index: Int) {
        vehicles.remove(at: index)
        saveVehicles()
    }
    
    // MARK: - Private Methods
    
    private func loadVehicles() {
        if let savedVehicles = loadVehiclesFromDisk() {
            vehicles = savedVehicles
        } else {
            vehicles = loadSampleVehicles()
        }
    }
    
    private func loadVehiclesFromDisk() -> [Vehicle]? {
        guard let codedVehicles = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Vehicle].self, from: codedVehicles)
    }
    
    private func saveVehicles() {
        let propertyListEncoder = PropertyListEncoder()
        let codedVehicles = try? propertyListEncoder.encode(vehicles)
        try? codedVehicles?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleVehicles() -> [Vehicle] {
        let vehicle1 = Vehicle(ownerId: UUID(), vehicleName: "Swift Dzire", brand: "Maruti Suzuki", model: "Dzire", year: 2023, vehicleType: .sedan, transmission: .manual, fuelType: .petrol, fuelCapacity: 37.0, engine: "1.2L Petrol", seatingCapacity: 5, pricePerDay: 1500.0, location: "New Delhi", description: "Well maintained sedan perfect for city drives.", availabilityStatus: true, createdAt: Date())
        let vehicle2 = Vehicle(ownerId: UUID(), vehicleName: "Hyundai Creta", brand: "Hyundai", model: "Creta", year: 2024, vehicleType: .suv, transmission: .automatic, fuelType: .diesel, fuelCapacity: 50.0, engine: "1.5L Diesel", seatingCapacity: 5, pricePerDay: 2500.0, location: "Mumbai", description: "Spacious SUV for road trips.", availabilityStatus: true, createdAt: Date())
        let vehicle3 = Vehicle(ownerId: UUID(), vehicleName: "Royal Enfield Classic 350", brand: "Royal Enfield", model: "Classic 350", year: 2023, vehicleType: .bike, transmission: .manual, fuelType: .petrol, fuelCapacity: 13.0, engine: "349cc Single Cylinder", seatingCapacity: 2, pricePerDay: 800.0, location: "Bangalore", description: "Iconic cruiser bike for weekend rides.", availabilityStatus: true, createdAt: Date())
        return [vehicle1, vehicle2, vehicle3]
    }
}

// MARK: - VehicleImage

struct VehicleImage: Equatable, Codable {
    let imageId: UUID
    var vehicleId: UUID
    var imageURL: String
    
    init(vehicleId: UUID, imageURL: String) {
        self.imageId = UUID()
        self.vehicleId = vehicleId
        self.imageURL = imageURL
    }
    
    static func ==(lhs: VehicleImage, rhs: VehicleImage) -> Bool {
        return lhs.imageId == rhs.imageId
    }
}

class VehicleImageDataModel {
    
    static let shared = VehicleImageDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var vehicleImages: [VehicleImage] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("vehicleImages").appendingPathExtension("plist")
        loadVehicleImages()
    }
    
    // MARK: - Public Methods
    
    func getAllVehicleImages() -> [VehicleImage] {
        return vehicleImages
    }
    
    func addVehicleImage(_ vehicleImage: VehicleImage) {
        vehicleImages.append(vehicleImage)
        saveVehicleImages()
    }
    
    func updateVehicleImage(_ vehicleImage: VehicleImage) {
        if let index = vehicleImages.firstIndex(where: { $0.imageId == vehicleImage.imageId }) {
            vehicleImages[index] = vehicleImage
            saveVehicleImages()
        }
    }
    
    func deleteVehicleImage(at index: Int) {
        vehicleImages.remove(at: index)
        saveVehicleImages()
    }
    
    // MARK: - Private Methods
    
    private func loadVehicleImages() {
        if let savedVehicleImages = loadVehicleImagesFromDisk() {
            vehicleImages = savedVehicleImages
        } else {
            vehicleImages = loadSampleVehicleImages()
        }
    }
    
    private func loadVehicleImagesFromDisk() -> [VehicleImage]? {
        guard let codedVehicleImages = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([VehicleImage].self, from: codedVehicleImages)
    }
    
    private func saveVehicleImages() {
        let propertyListEncoder = PropertyListEncoder()
        let codedVehicleImages = try? propertyListEncoder.encode(vehicleImages)
        try? codedVehicleImages?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleVehicleImages() -> [VehicleImage] {
        let image1 = VehicleImage(vehicleId: UUID(), imageURL: "https://example.com/car1.jpg")
        let image2 = VehicleImage(vehicleId: UUID(), imageURL: "https://example.com/car2.jpg")
        let image3 = VehicleImage(vehicleId: UUID(), imageURL: "https://example.com/bike1.jpg")
        return [image1, image2, image3]
    }
}

// MARK: - VehicleAmenity (Junction)

struct VehicleAmenity: Equatable, Codable {
    let vehicleId: UUID
    let amenityId: UUID
    
    init(vehicleId: UUID, amenityId: UUID) {
        self.vehicleId = vehicleId
        self.amenityId = amenityId
    }
    
    static func ==(lhs: VehicleAmenity, rhs: VehicleAmenity) -> Bool {
        return lhs.vehicleId == rhs.vehicleId && lhs.amenityId == rhs.amenityId
    }
}

class VehicleAmenityDataModel {
    
    static let shared = VehicleAmenityDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var vehicleAmenities: [VehicleAmenity] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("vehicleAmenities").appendingPathExtension("plist")
        loadVehicleAmenities()
    }
    
    // MARK: - Public Methods
    
    func getAllVehicleAmenities() -> [VehicleAmenity] {
        return vehicleAmenities
    }
    
    func addVehicleAmenity(_ vehicleAmenity: VehicleAmenity) {
        vehicleAmenities.append(vehicleAmenity)
        saveVehicleAmenities()
    }
    
    func deleteVehicleAmenity(vehicleId: UUID, amenityId: UUID) {
        vehicleAmenities.removeAll { $0.vehicleId == vehicleId && $0.amenityId == amenityId }
        saveVehicleAmenities()
    }
    
    func deleteVehicleAmenity(at index: Int) {
        vehicleAmenities.remove(at: index)
        saveVehicleAmenities()
    }
    
    func getAmenities(forVehicleId vehicleId: UUID) -> [VehicleAmenity] {
        return vehicleAmenities.filter { $0.vehicleId == vehicleId }
    }
    
    // MARK: - Private Methods
    
    private func loadVehicleAmenities() {
        if let savedVehicleAmenities = loadVehicleAmenitiesFromDisk() {
            vehicleAmenities = savedVehicleAmenities
        } else {
            vehicleAmenities = loadSampleVehicleAmenities()
        }
    }
    
    private func loadVehicleAmenitiesFromDisk() -> [VehicleAmenity]? {
        guard let codedVehicleAmenities = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([VehicleAmenity].self, from: codedVehicleAmenities)
    }
    
    private func saveVehicleAmenities() {
        let propertyListEncoder = PropertyListEncoder()
        let codedVehicleAmenities = try? propertyListEncoder.encode(vehicleAmenities)
        try? codedVehicleAmenities?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleVehicleAmenities() -> [VehicleAmenity] {
        let va1 = VehicleAmenity(vehicleId: UUID(), amenityId: UUID())
        let va2 = VehicleAmenity(vehicleId: UUID(), amenityId: UUID())
        let va3 = VehicleAmenity(vehicleId: UUID(), amenityId: UUID())
        return [va1, va2, va3]
    }
}
