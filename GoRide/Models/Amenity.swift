//
//  Amenity.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

struct Amenity: Equatable, Codable {
    let amenityId: UUID
    var name: String
    
    init(name: String) {
        self.amenityId = UUID()
        self.name = name
    }
    
    static func ==(lhs: Amenity, rhs: Amenity) -> Bool {
        return lhs.amenityId == rhs.amenityId
    }
}

class AmenityDataModel {
    
    static let shared = AmenityDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var amenities: [Amenity] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("amenities").appendingPathExtension("plist")
        loadAmenities()
    }
    
    // MARK: - Public Methods
    
    func getAllAmenities() -> [Amenity] {
        return amenities
    }
    
    func addAmenity(_ amenity: Amenity) {
        amenities.append(amenity)
        saveAmenities()
    }
    
    func updateAmenity(_ amenity: Amenity) {
        if let index = amenities.firstIndex(where: { $0.amenityId == amenity.amenityId }) {
            amenities[index] = amenity
            saveAmenities()
        }
    }
    
    func deleteAmenity(at index: Int) {
        amenities.remove(at: index)
        saveAmenities()
    }
    
    // MARK: - Private Methods
    
    private func loadAmenities() {
        if let savedAmenities = loadAmenitiesFromDisk() {
            amenities = savedAmenities
        } else {
            amenities = loadSampleAmenities()
        }
    }
    
    private func loadAmenitiesFromDisk() -> [Amenity]? {
        guard let codedAmenities = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Amenity].self, from: codedAmenities)
    }
    
    private func saveAmenities() {
        let propertyListEncoder = PropertyListEncoder()
        let codedAmenities = try? propertyListEncoder.encode(amenities)
        try? codedAmenities?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleAmenities() -> [Amenity] {
        let amenity1 = Amenity(name: "Music System")
        let amenity2 = Amenity(name: "Toolkit")
        let amenity3 = Amenity(name: "ABS System")
        let amenity4 = Amenity(name: "Bluetooth")
        let amenity5 = Amenity(name: "USB Charger")
        let amenity6 = Amenity(name: "AUX Input")
        let amenity7 = Amenity(name: "Spare Tyre")
        let amenity8 = Amenity(name: "Power Steering")
        let amenity9 = Amenity(name: "Power Windows")
        let amenity10 = Amenity(name: "Full Boot Space")
        return [amenity1, amenity2, amenity3, amenity4, amenity5, amenity6, amenity7, amenity8, amenity9, amenity10]
    }
}

