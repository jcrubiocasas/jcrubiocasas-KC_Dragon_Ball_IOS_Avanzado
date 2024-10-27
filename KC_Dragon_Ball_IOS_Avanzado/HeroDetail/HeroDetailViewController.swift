

import UIKit
import MapKit
import Kingfisher

class HeroDetailViewController: UIViewController {
        
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var collectionViewTransformations: UICollectionView!
    
    private let hero: Hero
    private var viewModel: HeroDetailViewModel
    private var locationManager: CLLocationManager = CLLocationManager()
    
    init(hero: Hero) {
        self.hero = hero
        self.viewModel = HeroDetailViewModel(hero: hero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setupCollectionView()
        botonVolver()
        displayHeroDetails()
        setBinding()
        //viewModel.loadData(id: hero.id)
        checkLocationAuthorizationStatus()
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsUserTrackingButton = true
    }
    
    private func botonVolver() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Hero List", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        closeButton.frame = CGRect(x: 20, y: 40, width: 100, height: 40)
        view.addSubview(closeButton)
    }
    
    private func setBinding() {
        viewModel.statusHeroDetail.bind { [weak self] status in
            switch status {
            case .locationUpdated:
                self?.collectionViewTransformations.isHidden =  false
                self?.updateMapAnnotations()
            case .transformationsUpdated:
                self?.collectionViewTransformations.reloadData()
                self?.collectionViewTransformations.isHidden = self?.viewModel.heroTransformations.isEmpty ?? true
            case .error(let msg):
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            case .none:
                break
            }
        }
    }
    
    private func displayHeroDetails() {
        let processor = RoundCornerImageProcessor(cornerRadius: heroImage.frame.size.width / 2)
        
        if let imageURL = viewModel.getHeroPhotoURL() {
            heroImage.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"), options: [.processor(processor)])
        } else {
            heroImage.image = UIImage(systemName: "photo")
        }
        
        heroImage.layer.cornerRadius = heroImage.frame.size.width / 2
        heroImage.clipsToBounds = true
        nameLabel.text = viewModel.getHeroName()
        detailText.text = viewModel.getHeroDescription()
    }
    
    // Configuración del CollectionView para mostrar una fila horizontal
    private func setupCollectionView() {
        collectionViewTransformations.delegate = self
        collectionViewTransformations.dataSource = self
        
        let nib = UINib(nibName: "HeroDetailCollectionViewCell", bundle: nil)
        collectionViewTransformations.register(nib, forCellWithReuseIdentifier: "HeroDetailCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 120)  // Ajusta el tamaño según lo necesites
        collectionViewTransformations.collectionViewLayout = layout
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(viewModel.annotations)
        
        if let annotation = viewModel.annotations.first {
            mapView.region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            mapView.showsUserLocation = false
            mapView.showsUserTrackingButton = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}

// Extensión para el mapa
extension HeroDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? HeroAnnotation else { return nil }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.identifier)  {
            return annotationView
        }
        return HeroAnnotationView(annotation: annotation, reuseIdentifier: HeroAnnotationView.identifier)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        debugPrint("Accessory tapped")
    }
}

// Extensión para la CollectionView
extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.heroTransformations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroDetailCollectionViewCell", for: indexPath) as! HeroDetailCollectionViewCell
        let transformation = viewModel.heroTransformations[indexPath.row]
        cell.configure(with: transformation)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.heroTransformations[indexPath.row]
        let transformationDetailVC = HeroTransformationDetailViewController(transformation: transformation)
        
        // Envolver en un UINavigationController
        let navController = UINavigationController(rootViewController: transformationDetailVC)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
}
