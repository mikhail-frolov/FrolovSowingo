// Name: Mikhail Frolov
// IOS DEV TEST
// ProductCell.swift

import Foundation
import UIKit

// To strikestrough the price
extension String {
   
    func strike() -> NSMutableAttributedString {
    
        let attributedString = NSMutableAttributedString(string: self)
        let range = attributedString.mutableString.range(of: self)
        
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: range)
        attributedString.addAttribute(.strikethroughColor, value: UIColor.secondaryLabel, range: range)
        
        return attributedString
    
    }
}


protocol FavoriteButtonDelegate {
    func didToggleFavoriteButton(for id: String)
}

class ProductCell: UICollectionViewCell {
    
    var mainImage: UIImageView!
    var favoriteButton: UIButton!
    var bestSellerBadge: UIImageView!
    var productTitleLabel: UILabel!
    var yourPriceLabel: UILabel!
    var listPriceLabel: UILabel!
    var separator: UIView!
    
    var delegate: FavoriteButtonDelegate?
    
    var product: Product? {
    
        didSet {
            updateCell()
        }
        
    }
    
    var favorite: FavouriteProduct?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellImage()
        setupFavoriteButton()
        setupTypography()
        setupBestSellerBadge()
        setupSeparator()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension ProductCell {
   
    private func updateCell() {
    
        guard let product = product else { return }
        
        let favButton = UIImage(named: "fav_button")
        let favButtonFilled = UIImage(named: "fav_button_filled")
  
        if let favoriteProduct = favorite, favoriteProduct.productID == product.id {
        
            favoriteButton.setBackgroundImage(favoriteProduct.isFavourite ? favButtonFilled : favButton, for: .normal)
        
        } else {
        
            favoriteButton.setBackgroundImage(favButton, for: .normal)
        
        }
        
        if let imgURL = product.mainImage {
        
            APIManager.shared.downloadImage(from: imgURL) { image in
                DispatchQueue.main.async {
                    self.mainImage.image = image
                }
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.mainImage.image = UIImage(systemName: "photo.fill")
            
            }
        }
        
        if let badgeURL = product.advertisingBadges.badges?.first?.badgeImageUrl {
          
            APIManager.shared.downloadImage(from: badgeURL) { image in
                DispatchQueue.main.async {
                    self.bestSellerBadge.image = image
                }
            }
            
        } else {
            
            DispatchQueue.main.async {
                self.bestSellerBadge.image = nil
            
            }
        }
        
        productTitleLabel.text = product.name
        
        if let vendorInventory = product.vendorInventory.first {
      
                yourPriceLabel.text = vendorInventory.price.formatted(.currency(code: "CAD"))
                
                let listPrice = vendorInventory.listPrice.formatted(.currency(code: "CAD"))
                listPriceLabel.attributedText = listPrice.strike()
           
        }
    }
    
    private func setupCellImage() {
      
        mainImage = UIImageView(frame: bounds)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(systemName: "photo.fill")
        mainImage.image = img
        mainImage.contentMode = .scaleAspectFit
        addSubview(mainImage)
    
    }
    
    private func setupFavoriteButton() {
    
        favoriteButton = UIButton(frame: bounds)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        addSubview(favoriteButton)
    
    }
    
    private func setupTypography() {
    
        productTitleLabel = UILabel(frame: bounds)
        yourPriceLabel = UILabel(frame: bounds)
        listPriceLabel = UILabel(frame: bounds)
        
        productTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        productTitleLabel.textColor = .label
        productTitleLabel.numberOfLines = 0
        productTitleLabel.textAlignment = .natural
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(productTitleLabel)
        
        yourPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        yourPriceLabel.textColor = .label
        yourPriceLabel.textAlignment = .right
        yourPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yourPriceLabel)
        
        listPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        listPriceLabel.textColor = .secondaryLabel
        listPriceLabel.textAlignment = .right
        listPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(listPriceLabel)
    }
    
    private func setupBestSellerBadge() {
       
        bestSellerBadge = UIImageView(frame: bounds)
        bestSellerBadge.translatesAutoresizingMaskIntoConstraints = false
        bestSellerBadge.contentMode = .scaleAspectFit
        addSubview(bestSellerBadge)
    
    }
    
    private func setupSeparator() {
       
        separator = UIView(frame: bounds)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        
        addSubview(separator)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
        
            mainImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainImage.heightAnchor.constraint(equalToConstant: 100),
            mainImage.widthAnchor.constraint(equalTo: mainImage.heightAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor),
            
            bestSellerBadge.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 12),
            bestSellerBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bestSellerBadge.heightAnchor.constraint(equalToConstant: 23),
            bestSellerBadge.widthAnchor.constraint(equalToConstant: 100),
            bestSellerBadge.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            productTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            productTitleLabel.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 12),
            productTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            productTitleLabel.heightAnchor.constraint(equalToConstant: 100),
            
            listPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 12),
            listPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            listPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            yourPriceLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 12),
            yourPriceLabel.trailingAnchor.constraint(equalTo: listPriceLabel.leadingAnchor, constant: -8),
            yourPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor)
     
        ])
    }
    
    @objc func didPressButton() {
       
        guard let product = product else { return }
        
        delegate?.didToggleFavoriteButton(for: product.id)
    
    }
}
