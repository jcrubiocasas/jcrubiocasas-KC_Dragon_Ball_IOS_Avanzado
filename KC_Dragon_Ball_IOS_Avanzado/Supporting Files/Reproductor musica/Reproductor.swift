//
//  Reproductor.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 27/10/24.
//

import AVFoundation

/// Clase que gestiona la reproducción de audio en la aplicación.
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    
    /// Instancia del reproductor de audio.
    var audioPlayer: AVAudioPlayer?
    
    // MARK: - Playback Control
    
    /// Inicia la reproducción de música con una configuración de repetición infinita.
    func playMusic() {
        // Configuración de la sesión de audio para reproducción en segundo plano
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error al configurar la sesión de audio: \(error.localizedDescription)")
            return
        }
        
        // Carga el archivo de audio ubicado en el bundle principal
        guard let url = Bundle.main.url(forResource: "DragonBall", withExtension: "mp3") else {
            print("No se encontró el archivo DragonBall.mp3")
            return
        }
        
        // Inicialización y configuración del reproductor
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.numberOfLoops = -1 // Repetición infinita
            audioPlayer?.play()
            print("Reproduciendo música...")
        } catch let error {
            print("Error al reproducir música: \(error.localizedDescription)")
        }
    }
    
    /// Detiene la reproducción de música y libera los recursos.
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        print("Música detenida.")
    }
}
