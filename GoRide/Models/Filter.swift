//
//  Filter.swift
//  GoRide
//
//  Created by Ansh Taneja on 10/03/26.
//

import Foundation

enum FilterType: String, Codable {
    case bike = "Bike"
    case sedan = "Sedan"
    case suv = "SUV"
    case hatchback = "Hatchback"
}

struct Filter: Equatable, Codable {
    let filterId: UUID
    var filterType: FilterType
    
    init(filterType: FilterType) {
        self.filterId = UUID()
        self.filterType = filterType
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.filterId == rhs.filterId
    }
}

class FilterDataModel {
    
    static let shared = FilterDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var filters: [Filter] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("filters").appendingPathExtension("plist")
        loadFilters()
    }
    
    // MARK: - Public Methods
    
    func getAllFilters() -> [Filter] {
        return filters
    }
    
    func addFilter(_ filter: Filter) {
        filters.append(filter)
        saveFilters()
    }
    
    func updateFilter(_ filter: Filter) {
        if let index = filters.firstIndex(where: { $0.filterId == filter.filterId }) {
            filters[index] = filter
            saveFilters()
        }
    }
    
    func deleteFilter(at index: Int) {
        filters.remove(at: index)
        saveFilters()
    }
    
    // MARK: - Private Methods
    
    private func loadFilters() {
        if let savedFilters = loadFiltersFromDisk() {
            filters = savedFilters
        } else {
            filters = loadSampleFilters()
        }
    }
    
    private func loadFiltersFromDisk() -> [Filter]? {
        guard let codedFilters = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Filter].self, from: codedFilters)
    }
    
    private func saveFilters() {
        let propertyListEncoder = PropertyListEncoder()
        let codedFilters = try? propertyListEncoder.encode(filters)
        try? codedFilters?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleFilters() -> [Filter] {
        let filter1 = Filter(filterType: .bike)
        let filter2 = Filter(filterType: .sedan)
        let filter3 = Filter(filterType: .suv)
        let filter4 = Filter(filterType: .hatchback)
        return [filter1, filter2, filter3, filter4]
    }
}
