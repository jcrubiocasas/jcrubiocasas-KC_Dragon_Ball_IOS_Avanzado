//
//  SplashViewController.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 20/10/24.
//

import UIKit
import AVKit
import AVFoundation

/// `SplashViewController`: controlador de vista inicial para reproducir un video y determinar la navegación según la autenticación.
class SplashViewController: UIViewController {
    
    // MARK: - Properties
    var player: AVPlayer?                         // Reproductor de video
    var playerViewController: AVPlayerViewController?  // Controlador para mostrar el video
    private var apiProvider: ApiProviderProtocol   // Proveedor de API para verificar datos de autenticación
    var tituloImageView: UIImageView!              // Imagen de título que se superpone al video

    // MARK: - Initializers
    
    /// Inicializador personalizado que establece el proveedor de API.
    init(apiProvider: ApiProviderProtocol = ApiProvider()) {
        self.apiProvider = apiProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    /// Configuración inicial del controlador y preparación de la reproducción de video.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayback()
    }
    
    // MARK: - Video Playback Setup
    
    /// Configura la reproducción de video desde el archivo local y presenta el `AVPlayerViewController`.
    private func setupVideoPlayback() {
        DispatchQueue.main.async {
            if let filePath = Bundle.main.path(forResource: "Dragon Ball", ofType: "mp4") {
                let videoURL = URL(fileURLWithPath: filePath)
                self.player = AVPlayer(url: videoURL)
                self.playerViewController = AVPlayerViewController()
                self.playerViewController?.player = self.player
                self.playerViewController?.showsPlaybackControls = false
                self.playerViewController?.modalPresentationStyle = .fullScreen
                self.present(self.playerViewController!, animated: true) {
                    self.player?.play()
                    self.configureTitleImage()
                    self.addTitleImageOverlay()
                    self.addTapGestureRecognizer()
                }
                NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            } else {
                print("No se encontró el archivo de video.")
            }
        }
    }

    // MARK: - Title Image Configuration
    
    /// Configura la vista de imagen del título para que aparezca sobre el video.
    private func configureTitleImage() {
        tituloImageView = UIImageView(image: UIImage(named: "title"))
        tituloImageView.contentMode = .scaleAspectFit
        tituloImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Agrega la imagen del título sobre el video con restricciones de Auto Layout.
    private func addTitleImageOverlay() {
        if let overlayView = self.playerViewController?.contentOverlayView {
            overlayView.addSubview(self.tituloImageView)
            setupTitleImageConstraints(in: overlayView)
        }
    }
    
    /// Define las restricciones de Auto Layout para la imagen del título.
    private func setupTitleImageConstraints(in overlayView: UIView) {
        NSLayoutConstraint.activate([
            tituloImageView.topAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.topAnchor),
            tituloImageView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            tituloImageView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            tituloImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    // MARK: - Tap Gesture Setup
    
    /// Agrega un recognizer de toque para adelantar o finalizar el video cuando se toca la pantalla.
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.playerViewController?.view.addGestureRecognizer(tapGesture)
    }
    
    /// Gestiona la acción de adelantar el video 20 segundos o terminarlo al tocar la pantalla.
    @objc func handleTap() {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let videoDuration = player.currentItem?.duration ?? CMTime.zero
        let timeToAdd: CMTime = CMTimeMake(value: 20, timescale: 1)
        let remainingTime = CMTimeSubtract(videoDuration, currentTime)
        if CMTimeCompare(remainingTime, timeToAdd) <= 0 {
            player.seek(to: videoDuration)
            self.videoDidFinish()
        } else {
            let newTime = CMTimeAdd(currentTime, timeToAdd)
            player.seek(to: newTime)
        }
    }
    
    // MARK: - Video Completion Handling
    
    /// Llamado cuando el video termina; redirige al usuario a la vista correspondiente.
    @objc func videoDidFinish() {
        DispatchQueue.main.async {
            self.playerViewController?.dismiss(animated: true, completion: {
                self.checkTokenAndRedirect()
            })
        }
    }

    // MARK: - Token Verification and Navigation
    
    /// Verifica el token de usuario en el Keychain y redirige a la pantalla de login o héroes.
    private func checkTokenAndRedirect() {
        DispatchQueue.main.async {
            if let savedToken = KeychainManager.shared.getData(for: "KeepCodingToken") {
                print("Token recuperado: \(savedToken)")
                self.redirectToHeroesView()
            } else {
                print("No se encontró ningún token para esta cuenta.")
                self.redirectToLoginView()
            }
        }
    }
    
    /// Redirige a la vista de `HeroesViewController` en modo de presentación completa.
    private func redirectToHeroesView() {
        let heroesVC = HeroesViewController()
        heroesVC.modalPresentationStyle = .fullScreen
        heroesVC.modalTransitionStyle = .coverVertical
        self.present(heroesVC, animated: true, completion: nil)
    }
    
    /// Redirige a la vista de `LoginViewController` en modo de presentación completa.
    private func redirectToLoginView() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .coverVertical
        self.present(loginVC, animated: true, completion: nil)
    }
}
