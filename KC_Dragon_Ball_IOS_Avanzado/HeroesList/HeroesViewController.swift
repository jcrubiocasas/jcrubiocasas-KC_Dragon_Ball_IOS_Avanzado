//
//  HeroesViewController.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 16/10/24.
//

import UIKit

/// Enum que define las secciones en el CollectionView de héroes
enum SectionsHeroes {
    case main // Sección principal que contiene todos los héroes
}

class HeroesViewController: UIViewController {
    
    // MARK: - UI Properties
    private var busquedaOculta: Bool = true
    private var isMusicPlaying = false // Estado que indica si la música está en reproducción o no
    private var musicButton: UIButton? // Referencia al botón de música para modificar su apariencia
    
    @IBOutlet weak var navigationBar: UINavigationBar!           // Barra de navegación personalizada
    @IBOutlet weak var collectionView: UICollectionView!         // CollectionView para mostrar la lista de héroes
    @IBOutlet weak var tiraBusqueda: UIView!                     // Vista para la barra de búsqueda
    @IBOutlet weak var campoBusqueda: UITextField!               // Campo de texto para ingresar búsqueda
    @IBOutlet weak var espaciadoTiraBusqueda: NSLayoutConstraint! // Restricción para ajustar la tira de búsqueda

    private var viewModel: HeroesViewModel                       // ViewModel que controla la lógica de negocio
    private var audioPlayer = AudioPlayer()                      // Instancia para manejar la reproducción de música
    
    /// Diffable Data Source para gestionar los datos de CollectionView
    private var dataSource: UICollectionViewDiffableDataSource<SectionsHeroes, Hero>?
    
    // MARK: - Initializers
    
    /// Inicializador del controlador de vista con el ViewModel
    /// - Parameter viewModel: Instancia de `HeroesViewModel` (opcional)
    init(viewModel: HeroesViewModel = HeroesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()       // Configura el CollectionView
        configureNavigationBar()        // Configura los botones de la barra de navegación
        campoBusqueda.delegate = self   // Establece el delegado del campo de búsqueda
        setBinding()                    // Configura el binding con el ViewModel
        viewModel.loadData(filter: nil) // Carga inicial de datos de héroes sin filtro
    }
    
    // MARK: - Navigation Bar Configuration
    
    /// Configura los botones de la barra de navegación con acciones personalizadas
    func configureNavigationBar() {
        let navigationItem = UINavigationItem(title: "HEROES")
        
        // Botón de logout
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.tintColor = .systemRed
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        // Botón de música
        let musicButton = UIButton(type: .system)
        let musicImage = UIImage(systemName: "music.note.list")
        musicButton.setImage(musicImage, for: .normal)
        musicButton.tintColor = .systemRed
        musicButton.addTarget(self, action: #selector(musicTapped), for: .touchUpInside)
        let musicBarButtonItem = UIBarButtonItem(customView: musicButton)
        self.musicButton = musicButton
        
        // Botón de búsqueda
        let searchButton = UIButton(type: .system)
        let searchImage = UIImage(systemName: "magnifyingglass")
        searchButton.setImage(searchImage, for: .normal)
        searchButton.tintColor = .systemRed
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        // Añadir los botones a la barra de navegación
        navigationItem.leftBarButtonItems = [logoutBarButtonItem, musicBarButtonItem]
        navigationItem.rightBarButtonItem = searchBarButtonItem
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    // MARK: - ViewModel Binding
    
    /// Configura el binding del ViewModel con la vista
    func setBinding() {
        viewModel.statusHeroes.bind { [weak self] status in
            switch status {
            case .dataUpdated:
                print("Datos actualizados: \(self?.viewModel.heroes.count ?? 0) héroes")
                var snapshot = NSDiffableDataSourceSnapshot<SectionsHeroes, Hero>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self?.viewModel.heroes ?? [], toSection: .main)
                self?.dataSource?.apply(snapshot)
            case .error(let msg):
                let alert = UIAlertController(title: "KeepCoding DragonBall", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            case .none:
                break
            }
        }
    }
    
    // MARK: - Collection View Configuration
    
    /// Configura el CollectionView y su layout
    func configureCollectionView() {
        collectionView.delegate = self
        let nib = UINib(nibName: "HeroesCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HeroesCollectionViewCell")
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroesCollectionViewCell", for: indexPath) as! HeroesCollectionViewCell
            let hero = self.viewModel.heroAt(index: indexPath.row)
            cell.configure(with: hero!)
            return cell
        })
        
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 10
        let cellWidth = (view.frame.size.width - padding * 3) / 2
        layout.itemSize = CGSize(width: cellWidth, height: 150)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Button Actions
    
    /// Acción al pulsar el botón de logout
    @objc func logoutTapped() {
        if KeychainManager.shared.deleteData(for: "KeepCodingToken") {
            debugPrint("Token borrado del Keychain")
        }
        
        StoreDataProvider.shared.clearBBDD()
        debugPrint("Base de datos borrada")
        
        let splashVC = SplashViewController()
        splashVC.modalPresentationStyle = .fullScreen
        splashVC.modalTransitionStyle = .coverVertical
        self.present(splashVC, animated: true, completion: nil)
    }
    
    /// Acción al pulsar el botón de música
    @objc func musicTapped() {
        if isMusicPlaying {
            audioPlayer.stopMusic()
            musicButton?.tintColor = .systemRed
        } else {
            audioPlayer.playMusic()
            musicButton?.tintColor = .systemGreen
        }
        isMusicPlaying.toggle()
    }
    
    /// Acción al pulsar el botón de búsqueda
    @objc func searchTapped() {
        mostrarBusqueda(valorBusquedaOculta: !busquedaOculta)
    }
    
    /// Muestra u oculta la barra de búsqueda con animación
    func mostrarBusqueda(valorBusquedaOculta: Bool) {
        if busquedaOculta == valorBusquedaOculta { return }
        
        espaciadoTiraBusqueda.constant = valorBusquedaOculta ? 10 : 50
        busquedaOculta = valorBusquedaOculta
        tiraBusqueda.isHidden = valorBusquedaOculta
        campoBusqueda.text = ""
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) { [weak self] in
            self?.tiraBusqueda.alpha = valorBusquedaOculta ? 0 : 1
            self?.view.layoutIfNeeded()
        }
    }
}

// MARK: - Extensions

// Extension para UICollectionViewDelegate y UITextFieldDelegate
extension HeroesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // Acción al seleccionar un héroe en el CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedHero = viewModel.heroAt(index: indexPath.row) else { return }
        let heroDetailVC = HeroDetailViewController(hero: selectedHero)
        heroDetailVC.modalPresentationStyle = .fullScreen
        heroDetailVC.modalTransitionStyle = .coverVertical
        present(heroDetailVC, animated: true, completion: nil)
    }
    
    // Ajusta el tamaño de las celdas en el CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let cellWidth = (collectionView.bounds.width - padding * 3) / 2
        return CGSize(width: cellWidth, height: 150)
    }
    
    // MARK: - Text Field Methods
        
    /// Acción cada vez que el texto en el campo de búsqueda cambia
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        // Realiza la búsqueda en tiempo real
        if currentText.isEmpty {
            viewModel.loadData(filter: nil)
        } else {
            viewModel.loadData(filter: currentText)
        }
        return true
    }
    
    /// Acción cuando el usuario presiona "Intro" en el teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        debugPrint("Se pulsó INTRO, ocultando teclado.")
        return true
    }
}
