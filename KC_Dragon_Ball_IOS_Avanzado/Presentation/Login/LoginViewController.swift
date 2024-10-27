//
//  LoginViewController.swift
//  KC_Dragon_Ball_IOS_Avanzado
//
//  Created by Juan Carlos Rubio Casas on 11/10/24.
//

import UIKit

/// `LoginViewController`: controlador de vista para la autenticación del usuario en la aplicación.
class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var apiProvider: ApiProviderProtocol    // Proveedor de API para manejo de autenticación
    @IBOutlet weak var positionYLogin: NSLayoutConstraint!  // Restricción de posición Y para la animación del teclado
    @IBOutlet weak var emailText: UITextField!      // Campo de entrada de email
    @IBOutlet weak var passwordTest: UITextField!    // Campo de entrada de contraseña
    private let defaultHeight: CGFloat = 60          // Altura predeterminada para animación de login
    
    // MARK: - Initializers
    
    /// Inicializador personalizado que permite inyectar un proveedor de API.
    init(apiProvider: ApiProviderProtocol = ApiProvider()) {
        self.apiProvider = apiProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Se agrega un observador de teclado al aparecer la vista.
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameDidChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    /// Se remueve el observador de teclado al desaparecer la vista.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
    
    // MARK: - Keyboard Handling
    
    /// Maneja el cambio de frame del teclado para ajustar la posición del botón de login.
    @objc func keyboardFrameDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            UIView.animate(withDuration: duration) {
                self.positionYLogin.constant = (self.defaultHeight + 300) - (UIScreen.main.bounds.height - frame.origin.y)
                self.positionYLogin.constant = 15
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Login Validation
    
    /// Valida que el email ingresado tenga un formato correcto.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /// Muestra una alerta con un título y mensaje dados.
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Login Action
    
    /// Acción que maneja el evento de inicio de sesión, realizando validaciones y autenticación.
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validación de email
        guard let email = emailText.text, isValidEmail(email) else {
            showAlert(title: "Error", message: "Por favor, ingrese un email válido.")
            return
        }

        // Validación de contraseña
        guard let password = passwordTest.text, password.count > 4 else {
            showAlert(title: "Error", message: "La contraseña debe tener más de 4 caracteres.")
            return
        }
        
        // Autenticación mediante la API
        apiProvider.loadToken(email: email, password: password) { result in
            switch result {
            case .success(let apiToken):
                // Verificación del token recibido
                guard !apiToken.isEmpty else {
                    self.showAlert(title: "Error", message: "El token recibido está vacío.")
                    return
                }
                if KeychainManager.shared.saveData(apiToken, for: "KeepCodingToken") {
                    // Presenta `HeroesViewController` si el token se guarda correctamente
                    DispatchQueue.main.async {
                        let heroesVC = HeroesViewController()
                        heroesVC.modalPresentationStyle = .fullScreen
                        heroesVC.modalTransitionStyle = .coverVertical
                        self.present(heroesVC, animated: true, completion: nil)
                    }
                } else {
                    debugPrint("Token no guardado en Keychain")
                }
            case .failure(let error):
                debugPrint("Error en inicio de sesión: \(error.description)")
            }
        }
    }
}
