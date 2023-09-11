//회원가입 페이지

import UIKit

class SignupViewController: UIViewController {
    private let emailPlaceholder = "이메일 주소"
    
    private let namePlaceholder = "이름"
    
    private let passwordPlaceholder = "비밀번호"
    
    private let passwordCheckPlaceholder = "비밀번호 확인"
    
    private var loadingView: UIView?
    
    // 회원가입 라벨
    let signupLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회원 가입"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .black
        
        return label
    }()
    
    // 이메일 주소
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderText = "아이디 "
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.placeholder = self.emailPlaceholder
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    // 이름 텍스트필드
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderText = "이름"
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.placeholder = self.namePlaceholder
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        
        textField.layer.cornerRadius = 10.0
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    // 비밀번호 텍스트필드
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderText = "비밀번호"
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.placeholder = self.passwordPlaceholder
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.0
        textField.backgroundColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    // 비밀번호 확인 텍스트필드
    private lazy var passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderText = "비밀번호 확인"
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.placeholder = self.passwordCheckPlaceholder
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.0
        textField.backgroundColor = .white
        textField.backgroundColor = UIColor.systemGray4
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    // 1. 이메일 주소, 이름, 비밀번호, 비밀번호 확인 스택뷰
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, nameTextField, passwordTextField, passwordCheckTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    // 등록하기 버튼
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("등록하기", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
        button.setTitleColor(.black, for: .normal)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    // 로딩화면
    func showLoadingScreen() {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.5
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        // 뷰에 추가
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        self.loadingView = loadingView
    }
    
    func dismissLoadingScreen() {
        guard let loadingView = loadingView else {
            return
        }
        
        loadingView.removeFromSuperview()
        
        self.loadingView = nil
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        
        view.backgroundColor = .white
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardTappedAround()
    }
    
    // 화면에 보여짐
    private func setUpViews() {
        view.addSubview(signupLabel)
        view.addSubview(infoStackView)
        view.addSubview(doneButton)
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        // 레이아웃
        NSLayoutConstraint.activate([
            // 회원가입 라벨
            signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            
            // 이메일 주소 텍스트필드
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            emailTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            // 이름 텍스트필드
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            nameTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            // 비밀번호 텍스트필드
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            // 비밀번호 확인 텍스트필드
            passwordCheckTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            passwordCheckTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            passwordCheckTextField.heightAnchor.constraint(equalToConstant: 40.0),
            
            // 1. 이메일 주소, 이름, 비밀번호, 비밀번호 확인 스택뷰
            infoStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            infoStackView.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 35),
            
            // 등록하기 버튼
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            doneButton.heightAnchor.constraint(equalToConstant: 45),
            doneButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 200)
        ])
    }
    
    // MARK: - 기능, 액션, 데이터 저장
    
    // 등록하기 버튼 눌렀을때
    @objc func doneButtonTapped() {
        // 빈칸이 있을때는 안넘어감
        guard let email = emailTextField.text,
              !email.isEmpty,
              let name = nameTextField.text,
              !name.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty,
              let passwordCheck = passwordCheckTextField.text,
              !passwordCheck.isEmpty
        else {
            print("빈칸을 채워주세요.")
            return
        }

        // 비밀번호와 비밀번호확인이 일치할때만
        guard password == passwordCheck else {
            print("비밀번호 일치하지않음.")
            return
        }

        // 로딩화면
        showLoadingScreen()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            if let usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
                for userData in usersData {
                    if let user = try? JSONDecoder().decode(User.self, from: userData),
                       user.email == email
                    {
                        print("이미 사용자 있음.")

                        DispatchQueue.main.async {
                            self.dismissLoadingScreen()
                            self.registeredAlert()
                        }
                        return
                    }
                }
            }
            // user
            let user = User(email: email, name: name, password: password)

            if var usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
                let userData = try! JSONEncoder().encode(user)
                usersData.append(userData)
                UserDefaults.standard.set(usersData, forKey: "users")

                //
                self.emailTextField.text = ""
                self.nameTextField.text = ""
                self.passwordTextField.text = ""
                self.passwordCheckTextField.text = ""

                // 이전화면으로 이동(pop)
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }

                    strongSelf.dismissLoadingScreen()
                    strongSelf.navigationController?.popViewController(animated: true)
                }

            } else {
                let userData = try! JSONEncoder().encode(user)
                UserDefaults.standard.set([userData], forKey: "users")
            }
        }
    }
    
    // 불투명 알럿창
    func registeredShowToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 120, y: 100, width: 240, height: 30))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 0.8
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { isCompleted in
            if isCompleted {
                toastLabel.removeFromSuperview()
            }
        })
    }

    // 사용자 이미 등록되어있을때 나타나는 알럿창
    func registeredAlert() {
        registeredShowToast(message: "사용자가 이미 등록되어있습니다.")
    }
    
    // 텍스트필드 이외부분 터치했을때 키보드내려감
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SigninViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
    // 텍스트필드 터치시 플레이스홀더 텍스트 사라짐
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField && textField.placeholder == emailPlaceholder {
            textField.placeholder = ""
            
        } else if textField == nameTextField && textField.placeholder == namePlaceholder {
            textField.placeholder = ""
            
        } else if textField == passwordTextField && textField.placeholder == passwordPlaceholder {
            textField.placeholder = ""
            
        } else if textField == passwordCheckTextField && textField.placeholder == passwordCheckPlaceholder {
            textField.placeholder = ""
        }
    }
    
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield == emailTextField && (textfield.text?.isEmpty ?? true) {
            textfield.placeholder = emailPlaceholder
            
        } else if textfield == nameTextField && (textfield.text?.isEmpty ?? true) {
            textfield.placeholder = namePlaceholder
            
        } else if textfield == passwordTextField && (textfield.text?.isEmpty ?? true) {
            textfield.placeholder = passwordPlaceholder
            
        } else if textfield == passwordCheckTextField && (textfield.text?.isEmpty ?? true) {
            textfield.placeholder = passwordCheckPlaceholder
        }
    }
    
    // 키보드 엔터버튼 return으로 변경, return 버튼 누를시 키보드 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField || textField == passwordCheckTextField, !string.isEmpty {
            let allowedCharacters = CharacterSet.alphanumerics
            
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
    
    // 비밀번호와 비밀번호 확인 일치할때 텍스트 색변화
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == passwordCheckTextField {
            if passwordTextField.text == passwordCheckTextField.text {
                passwordCheckTextField.backgroundColor = .white
            } else {
                passwordCheckTextField.backgroundColor = UIColor.systemGray4
            }
        }
    }
}
