//
//  HeroDetailCollectionViewCell.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 27/10/24.
//

import UIKit
import Kingfisher

class HeroDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var transformationImage: UIImageView!
    @IBOutlet weak var transformationLabel: UILabel!
    
    // Configurar la celda con un objeto Transformation
        func configure(with transformation: Transformation) {
            transformationLabel.text = transformation.name
            
            // Cargar la imagen usando Kingfisher
            if let imageURL = URL(string: transformation.photo) {
                transformationImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder_image"))
            } else {
                transformationImage.image = UIImage(named: "default_image")
            }
            
            // Personalización adicional, como hacer la imagen redonda
            //transformationImage.layer.cornerRadius = transformationImage.frame.size.width / 2
            //transformationImage.clipsToBounds = true
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Ajustes de estilo adicionales si es necesario
            transformationImage.layer.cornerRadius = 10
            transformationImage.clipsToBounds = true
        }
    

}
