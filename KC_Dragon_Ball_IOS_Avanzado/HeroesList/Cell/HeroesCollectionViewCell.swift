//
//  HeroesCollectionViewCell.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 22/10/24.
//

import UIKit
import Kingfisher

class HeroesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    /*
    static var identifier: String {
        String(describing: HeroesCollectionViewCell.self)
    }
     */
    static let identifier: String = "HeroesCollectionViewCell"
    
    
    
    func configure(with hero: Hero) {
        heroNameLabel.text = hero.name
        
        // Verificar si la URL de la imagen es válida
        if let imageURL = URL(string: hero.photo) {
            // Usar Kingfisher para descargar y mostrar la imagen
            heroImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder_image"))
        } else {
            // Si no es una URL válida, mostrar una imagen por defecto
            heroImage.image = UIImage(named: "default_image")
        }
    }
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Personalización adicional de la celda si es necesario
        heroImage.layer.cornerRadius = 10
        heroImage.clipsToBounds = true
    }
    
    
    
    
    /*
    // Configurar la celda con los datos del héroe
    func configure(with hero: Hero) {
        heroNameLabel.text = hero.name
        // Verifica si la URL de la imagen es válida
        if let imageURL = URL(string: hero.photo) {
            // Usar Kingfisher para descargar y mostrar la imagen
            heroImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder_image"))
        } else {
            // Si no es una URL válida, mostrar una imagen por defecto
            heroImage.image = UIImage(named: "default_image")
        }
    }
     */
}
