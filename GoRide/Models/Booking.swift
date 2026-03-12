//
//  Booking.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

enum BookingStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

struct Booking: Equatable, Codable {
    let bookingId: UUID
    var customerId: UUID
    var vehicleId: UUID
    var pickupDate: Date
    var returnDate: Date
    var totalPrice: Double
    var bookingStatus: BookingStatus
    var createdAt: Date
    
    init(customerId: UUID, vehicleId: UUID, pickupDate: Date, returnDate: Date, totalPrice: Double, bookingStatus: BookingStatus, createdAt: Date) {
        self.bookingId = UUID()
        self.customerId = customerId
        self.vehicleId = vehicleId
        self.pickupDate = pickupDate
        self.returnDate = returnDate
        self.totalPrice = totalPrice
        self.bookingStatus = bookingStatus
        self.createdAt = createdAt
    }
    
    static func ==(lhs: Booking, rhs: Booking) -> Bool {
        return lhs.bookingId == rhs.bookingId
    }
}

class BookingDataModel {
    
    static let shared = BookingDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var bookings: [Booking] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("bookings").appendingPathExtension("plist")
        loadBookings()
    }
    
    // MARK: - Public Methods
    
    func getAllBookings() -> [Booking] {
        return bookings
    }
    
    func addBooking(_ booking: Booking) {
        bookings.append(booking)
        saveBookings()
    }
    
    func updateBooking(_ booking: Booking) {
        if let index = bookings.firstIndex(where: { $0.bookingId == booking.bookingId }) {
            bookings[index] = booking
            saveBookings()
        }
    }
    
    func deleteBooking(at index: Int) {
        bookings.remove(at: index)
        saveBookings()
    }
    
    // MARK: - Private Methods
    
    private func loadBookings() {
        if let savedBookings = loadBookingsFromDisk() {
            bookings = savedBookings
        } else {
            bookings = loadSampleBookings()
        }
    }
    
    private func loadBookingsFromDisk() -> [Booking]? {
        guard let codedBookings = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Booking].self, from: codedBookings)
    }
    
    private func saveBookings() {
        let propertyListEncoder = PropertyListEncoder()
        let codedBookings = try? propertyListEncoder.encode(bookings)
        try? codedBookings?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleBookings() -> [Booking] {
        let booking1 = Booking(customerId: UUID(), vehicleId: UUID(), pickupDate: Date(), returnDate: Date().addingTimeInterval(86400 * 3), totalPrice: 4500.0, bookingStatus: .confirmed, createdAt: Date())
        let booking2 = Booking(customerId: UUID(), vehicleId: UUID(), pickupDate: Date(), returnDate: Date().addingTimeInterval(86400 * 5), totalPrice: 12500.0, bookingStatus: .pending, createdAt: Date())
        let booking3 = Booking(customerId: UUID(), vehicleId: UUID(), pickupDate: Date().addingTimeInterval(-86400 * 7), returnDate: Date().addingTimeInterval(-86400 * 4), totalPrice: 2400.0, bookingStatus: .completed, createdAt: Date())
        return [booking1, booking2, booking3]
    }
}
