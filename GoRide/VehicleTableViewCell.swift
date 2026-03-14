//
//  VehicleTableViewCell.swift
//  GoRide
//
//  Created by Ansh Taneja on 12/03/26.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {
    
    // Vehicle Image
    @IBOutlet weak var vehicleImageView: UIImageView!
    
    // Name & Variant
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var vehicleVariantLabel: UILabel!
    
    // Spec icons
    @IBOutlet weak var seatingIcon: UIImageView!
    @IBOutlet weak var fuelPolicyIcon: UIImageView!
    @IBOutlet weak var fuelTypeIcon: UIImageView!
    @IBOutlet weak var transmissionIcon: UIImageView!
    
    // Spec labels
    @IBOutlet weak var seatingLabel: UILabel!
    @IBOutlet weak var fuelPolicyLabel: UILabel!
    @IBOutlet weak var fuelTypeLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    
    // Price buttons (3 pricing tiers)
    @IBOutlet weak var price1Button: UIButton!
    @IBOutlet weak var price2Button: UIButton!
    @IBOutlet weak var price3Button: UIButton!
    
    // Additional info
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    // Book Now button
    @IBOutlet weak var bookNowButton: UIButton!
    
    // Pricing Data
    var pricingPlans: [VehiclePricingPlan] = []
    var selectedPricingPlan: VehiclePricingPlan?
    
    // Callback for Book Now tap
    var onBookNowTapped: ((VehiclePricingPlan) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        // Vehicle image
        vehicleImageView.contentMode = .scaleAspectFit
        vehicleImageView.clipsToBounds = true
        
        let orangeColor = UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1.0)
        
        // Initial setup for pricing buttons
        for btn in [price1Button, price2Button, price3Button] {
            btn?.layer.borderWidth = 0.5
            btn?.layer.cornerRadius = 4
            btn?.clipsToBounds = true
            btn?.titleLabel?.numberOfLines = 2
            btn?.titleLabel?.textAlignment = .center
        }
        
        // Book Now button
        bookNowButton.backgroundColor = orangeColor
        bookNowButton.setTitleColor(.white, for: .normal)
        bookNowButton.layer.cornerRadius = 5
        bookNowButton.clipsToBounds = true
    }
    
    func configure(with vehicle: Vehicle) {
        // Name & variant
        vehicleNameLabel.text = vehicle.vehicleName
        vehicleVariantLabel.text = "(\(vehicle.model))"
        
        // Specs
        seatingLabel.text = "\(vehicle.seatingCapacity) Seater"
        fuelPolicyLabel.text = "Full to Full"
        fuelTypeLabel.text = vehicle.fuelType.rawValue
        transmissionLabel.text = vehicle.transmission.rawValue
        
        // Pricing tiers (base, 2x, 3x days estimate)
        let basePrice = Int(vehicle.pricePerDay)
        
        pricingPlans = [
            VehiclePricingPlan(id: UUID(), vehicleId: vehicle.vehicleId, price: Double(basePrice), kmsLimit: "120Kms Free", type: .limited),
            VehiclePricingPlan(id: UUID(), vehicleId: vehicle.vehicleId, price: Double(basePrice) * 1.2, kmsLimit: "240Kms Free", type: .extended),
            VehiclePricingPlan(id: UUID(), vehicleId: vehicle.vehicleId, price: Double(basePrice) * 1.4, kmsLimit: "Unlimited Kms", type: .unlimited)
        ]
        
        // Format titles for buttons
        setButtonTitle(for: price1Button, price: pricingPlans[0].price, subtitle: pricingPlans[0].kmsLimit)
        setButtonTitle(for: price2Button, price: pricingPlans[1].price, subtitle: pricingPlans[1].kmsLimit)
        setButtonTitle(for: price3Button, price: pricingPlans[2].price, subtitle: pricingPlans[2].kmsLimit)
        
        // Select the first plan by default
        selectPlan(at: 0)
        
        // Additional info
        additionalInfoLabel.text = "*Additional ₹ 11/KM | Exclusive Taxes"
        
        // Book Now
        bookNowButton.setTitle("Book Now", for: .normal)
        
        // Spec Icons
        seatingIcon.image = UIImage(systemName: "person.2.fill")
        fuelPolicyIcon.image = UIImage(systemName: "fuelpump.fill")
        fuelTypeIcon.image = UIImage(systemName: "flame.fill")
        transmissionIcon.image = UIImage(systemName: "gearshape.fill")
        
        [seatingIcon, fuelPolicyIcon, fuelTypeIcon, transmissionIcon].forEach {
            $0?.tintColor = .darkGray
        }
        
        // Load vehicle image dynamically from VehicleImageDataModel
        let images = VehicleImageDataModel.shared.getAllVehicleImages()
        let assetName: String
        
        if let vehicleImage = images.first(where: { $0.vehicleId == vehicle.vehicleId }) {
            assetName = vehicleImage.imageURL
        } else {
            // Fallback for legacy hardcoded values if not in DataModel
            switch vehicle.vehicleName {
            case "Hyundai Aura": assetName = "hyundai_aura_side"
            case "Hyundai Creta": assetName = "hyundai_creta_front"
            case "Royal Enfield Classic 350": assetName = "re_classic350_side"
            case "Swift Dzire", "Maruti Swift": assetName = "maruti_swift_front"
            case "Toyota Fortuner": assetName = "toyota_fortuner_front"
            case "Honda Activa 6G": assetName = "honda_activa_side"
            default: assetName = ""
            }
        }
        
        if !assetName.isEmpty, let image = UIImage(named: assetName) {
            vehicleImageView.image = image
            vehicleImageView.tintColor = nil // Remove tint for actual images
        } else {
            // Fallback to SF Symbol
            switch vehicle.category {
            case .bike: vehicleImageView.image = UIImage(systemName: "bicycle")
            case .sedan: vehicleImageView.image = UIImage(systemName: "car.side.fill")
            case .suv: vehicleImageView.image = UIImage(systemName: "suv.side.fill")
            case .hatchback: vehicleImageView.image = UIImage(systemName: "car.fill")
            }
            vehicleImageView.tintColor = .darkGray
        }
    }
    
    private func setButtonTitle(for button: UIButton?, price: Double, subtitle: String) {
        let titleParam = "₹\(Int(price))\n\(subtitle)"
        button?.setTitle(titleParam, for: .normal)
    }
    
    private func selectPlan(at index: Int) {
        guard index >= 0 && index < pricingPlans.count else { return }
        selectedPricingPlan = pricingPlans[index]
        updatePricingUI(selectedIndex: index)
    }
    
    private func updatePricingUI(selectedIndex: Int) {
        let orangeColor = UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1.0)
        let grayColor = UIColor.lightGray
        let textGrayColor = UIColor.darkGray
        let lightOrangeBg = UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 0.05)
        
        let buttons = [price1Button, price2Button, price3Button]
        
        for (index, btn) in buttons.enumerated() {
            guard let button = btn else { continue }
            
            if index == selectedIndex {
                button.layer.borderColor = orangeColor.cgColor
                button.layer.borderWidth = 1.5
                button.backgroundColor = lightOrangeBg
                button.setTitleColor(orangeColor, for: .normal)
                button.titleLabel?.font = .boldSystemFont(ofSize: 12)
            } else {
                button.layer.borderColor = grayColor.cgColor
                button.layer.borderWidth = 0.5
                button.backgroundColor = .clear
                button.setTitleColor(textGrayColor, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 12)
            }
        }
    }
    
    @IBAction func price1Tapped(_ sender: UIButton) {
        selectPlan(at: 0)
    }
    
    @IBAction func price2Tapped(_ sender: UIButton) {
        selectPlan(at: 1)
    }
    
    @IBAction func price3Tapped(_ sender: UIButton) {
        selectPlan(at: 2)
    }
    
    @IBAction func bookNowTapped(_ sender: UIButton) {
        if let plan = selectedPricingPlan {
            onBookNowTapped?(plan)
        }
    }
}
