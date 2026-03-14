//
//  VehicleDetailViewController.swift
//  GoRide
//
//  Created by Ansh Taneja on 14/03/26.
//

import UIKit

class VehicleDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var vehicleVariantLabel: UILabel!

    @IBOutlet weak var price120Label: UILabel!
    @IBOutlet weak var price240Label: UILabel!
    @IBOutlet weak var unlimitedPriceLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amenitiesLabel: UILabel!
    @IBOutlet weak var policiesLabel: UILabel!

    @IBOutlet weak var bookButton: UIButton!
    
    // MARK: - Properties
    
    var vehicle: Vehicle?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        // Aesthetic improvements
        bookButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1.0)
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.layer.cornerRadius = 8
        bookButton.clipsToBounds = true
        
        vehicleImageView.contentMode = .scaleAspectFit
        vehicleImageView.backgroundColor = .systemGray6
    }
    
    private func configureUI() {
        guard let vehicle = vehicle else { return }
        
        // 1. Basic Info
        title = vehicle.brand
        vehicleNameLabel.text = vehicle.vehicleName
        vehicleVariantLabel.text = "(\(vehicle.model))"
        descriptionLabel.text = vehicle.description
        
        // 2. Pricing Tiers (Mapping logic similar to Cell)
        let basePrice = Int(vehicle.pricePerDay)
        price120Label.text = "₹\(basePrice)"
        price240Label.text = "₹\(Int(Double(basePrice) * 1.2))"
        unlimitedPriceLabel.text = "₹\(Int(Double(basePrice) * 1.4))"
        
        // 3. Load Image
        let images = VehicleImageDataModel.shared.getAllVehicleImages()
        if let vehicleImage = images.first(where: { $0.vehicleId == vehicle.vehicleId }) {
            vehicleImageView.image = UIImage(named: vehicleImage.imageURL)
        } else {
            // Fallback to SF Symbol based on category
            switch vehicle.category {
            case .bike: vehicleImageView.image = UIImage(systemName: "bicycle")
            case .sedan: vehicleImageView.image = UIImage(systemName: "car.side.fill")
            case .suv: vehicleImageView.image = UIImage(systemName: "suv.side.fill")
            case .hatchback: vehicleImageView.image = UIImage(systemName: "car.fill")
            }
            vehicleImageView.tintColor = .darkGray
        }
        
        // 4. Amenities
        let allAmenities = AmenityDataModel.shared.getAllAmenities()
        let vehicleAmenityIDs = VehicleAmenityDataModel.shared.getAllVehicleAmenities()
            .filter { $0.vehicleId == vehicle.vehicleId }
            .map { $0.amenityId }
        
        let amenityNames = allAmenities
            .filter { vehicleAmenityIDs.contains($0.amenityId) }
            .map { $0.name }
        
        // Base specs + custom amenities
        let baseSpecs = [
            "\(vehicle.seatingCapacity) Seater",
            vehicle.fuelType.rawValue,
            vehicle.transmission.rawValue,
            "Full to Full Fuel"
        ]
        
        amenitiesLabel.text = (baseSpecs + amenityNames).joined(separator: " • ")
        
        // 5. Policies
        let policies = PolicyDataModel.shared.getAllPolicies()
        if let vehiclePolicy = policies.first(where: { $0.vehicleId == vehicle.vehicleId }) {
            policiesLabel.text = vehiclePolicy.policyText
        } else {
            policiesLabel.text = "Standard rental and insurance policies apply. Please see the rental agreement for full details."
        }
    }
    
    // MARK: - Actions
    
    @IBAction func bookNowTapped(_ sender: UIButton) {
        guard let vehicle = vehicle else { return }
        
        print("Booking process started for: \(vehicle.vehicleName)")
        
        let alert = UIAlertController(title: "Confirm Booking", message: "Would you like to proceed with booking \(vehicle.vehicleName)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            print("Booking confirmed!")
            // Here you would typically lead to a payment or confirmation screen
        }))
        present(alert, animated: true)
    }
}
