//
//  Review.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

struct Review: Equatable, Codable {
    let reviewId: UUID
    var customerId: UUID
    var vehicleId: UUID
    var rating: Double
    var comment: String
    var createdAt: Date
    
    init(customerId: UUID, vehicleId: UUID, rating: Double, comment: String, createdAt: Date) {
        self.reviewId = UUID()
        self.customerId = customerId
        self.vehicleId = vehicleId
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
    }
    
    static func ==(lhs: Review, rhs: Review) -> Bool {
        return lhs.reviewId == rhs.reviewId
    }
}

class ReviewDataModel {
    
    static let shared = ReviewDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var reviews: [Review] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("reviews").appendingPathExtension("plist")
        loadReviews()
    }
    
    // MARK: - Public Methods
    
    func getAllReviews() -> [Review] {
        return reviews
    }
    
    func addReview(_ review: Review) {
        reviews.append(review)
        saveReviews()
    }
    
    func updateReview(_ review: Review) {
        if let index = reviews.firstIndex(where: { $0.reviewId == review.reviewId }) {
            reviews[index] = review
            saveReviews()
        }
    }
    
    func deleteReview(at index: Int) {
        reviews.remove(at: index)
        saveReviews()
    }
    
    // MARK: - Private Methods
    
    private func loadReviews() {
        if let savedReviews = loadReviewsFromDisk() {
            reviews = savedReviews
        } else {
            reviews = loadSampleReviews()
        }
    }
    
    private func loadReviewsFromDisk() -> [Review]? {
        guard let codedReviews = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Review].self, from: codedReviews)
    }
    
    private func saveReviews() {
        let propertyListEncoder = PropertyListEncoder()
        let codedReviews = try? propertyListEncoder.encode(reviews)
        try? codedReviews?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleReviews() -> [Review] {
        let review1 = Review(customerId: UUID(), vehicleId: UUID(), rating: 4.5, comment: "Great car, very clean and well maintained!", createdAt: Date())
        let review2 = Review(customerId: UUID(), vehicleId: UUID(), rating: 3.0, comment: "Decent bike but fuel efficiency could be better.", createdAt: Date())
        let review3 = Review(customerId: UUID(), vehicleId: UUID(), rating: 5.0, comment: "Amazing SUV! Perfect for our family road trip.", createdAt: Date())
        return [review1, review2, review3]
    }
}
