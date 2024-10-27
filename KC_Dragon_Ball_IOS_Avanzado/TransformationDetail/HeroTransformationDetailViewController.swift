//
//  HeroTransformationDetailViewController.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 27/10/24.
//

import UIKit

/// Controlador de vista que muestra los detalles de una transformación de héroe.
class HeroTransformationDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var transformationTestView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transdormationImage: UIImageView!
    
    // MARK: - Properties
    
    private let transformation: Transformation
    
    // MARK: - Initializers
    
    /// Inicializa el controlador con una transformación específica.
    /// - Parameter transformation: Transformación del héroe a mostrar.
    init(transformation: Transformation) {
        self.transformation = transformation
        super.init(nibName: "HeroTransformationDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        displayTransformationDetails()
    }
    
    // MARK: - UI Setup
    
    /// Muestra los detalles de la transformación, incluyendo el nombre, descripción y foto.
    private func displayTransformationDetails() {
        nameLabel.text = transformation.name
        transformationTestView.text = transformation.info
        
        if let imageUrl = URL(string: transformation.photo) {
            transdormationImage.kf.setImage(with: imageUrl, placeholder: UIImage(systemName: "photo"))
        } else {
            transdormationImage.image = UIImage(systemName: "photo")
        }
    }
    
    /// Configura un botón de cierre para la vista.
    private func setupCloseButton() {
        let closeButton = UIBarButtonItem(title: "Cerrar", style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    // MARK: - Actions
    
    /// Cierra la vista de detalle al pulsar el botón de cerrar.
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
