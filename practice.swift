//// 로그인페이지
// import Alamofire
// import SnapKit
// import Then
// import UIKit
//
// class SigninViewController: UIViewController {
//    private let idPlaceholder = "이메일 주소"
//    private let pwPlaceholder = "비밀번호"
//
//    // Doodle 이미지뷰
//    let doodleImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        if let image = UIImage(named: "DoodleImage") {
//            imageView.image = image
//        }
//
//        imageView.contentMode = .scaleAspectFill
//
//        return imageView
//    }()
//
//    // 아이디 텍스트필드
//    private lazy var idTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        let placeholderText = "이메일 주소"
//        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        textField.placeholder = self.idPlaceholder
//        textField.textAlignment = .center
//        textField.font = UIFont.systemFont(ofSize: 16)
//
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
//        textField.layer.shadowOpacity = 0.2
//
//        textField.layer.cornerRadius = 10.0
//        textField.layer.borderWidth = 0.0
//        textField.backgroundColor = .white
// textField.autocapitalizationType = .none
// textField.autocorrectionType = .no
// textField.spellCheckingType = .no
// textField.keyboardType = .emailAddress
//
//        return textField
//    }()
//
//    // 비밀번호 텍스트필드
//    private lazy var pwTextField: UITextField = {
//        let textField = UITextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        let placeholderText = "비밀번호"
//        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        textField.placeholder = self.pwPlaceholder
//        textField.textAlignment = .center
//        textField.font = UIFont.systemFont(ofSize: 16)
//
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
//        textField.layer.shadowOpacity = 0.2
//
//        textField.layer.cornerRadius = 10.0
//        textField.layer.borderWidth = 0.0
//        textField.backgroundColor = .white
// textField.autocapitalizationType = .none
// textField.autocorrectionType = .no
// textField.spellCheckingType = .no
//        textField.isSecureTextEntry = true
//
//        return textField
//    }()
//
//    // 로그인 버튼
//    private lazy var loginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.setTitle("로그인", for: .normal)
//        button.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
//        button.setTitleColor(.black, for: .normal)
//
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.shadowOpacity = 0.2
//        button.layer.cornerRadius = 10
//        button.isEnabled = false
//
//        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
//
//        return button
//    }()
//
//    // 체크마크 버튼
//    private lazy var checkedButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.setImage(UIImage(named: "unchecked"), for: .normal)
//        button.setImage(UIImage(named: "checked"), for: .selected)
//
//        button.addTarget(self, action: #selector(checkedButtonTapped), for: .touchUpInside)
//
//        return button
//    }()
//
//    // 아이디저장 라벨
//    private lazy var saveIDLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        label.text = "아이디저장"
//        label.textColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
//        label.font = UIFont.systemFont(ofSize: 13)
//
//        return label
//    }()
//
//    // 회원가입 버튼
//    private lazy var signUpButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
//
//        button.setTitle("회원가입", for: .normal)
//        button.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1), for: .normal) // FFCB47
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//
//        return button
//    }()
//
//    // 비밀번호찾기 버튼
//    private lazy var findPasswordButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("비밀번호찾기", for: .normal)
//        button.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1), for: .normal) // FFCB47
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//
//        return button
//    }()
//
//    // 1. 아이디, 비밀번호, 로그인 스택뷰
//    private lazy var loginStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [idTextField, pwTextField, loginButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        stackView.axis = .vertical
//        stackView.spacing = 10
//
//        return stackView
//    }()
//
//    // 카카오톡 로그인 버튼
//    private lazy var kakaoLoginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.setTitle("카카오톡 로그인", for: .normal)
//        // button.addTarget(self, action: #selector(), for: .touchUpInside)
//        button.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
//        button.setTitleColor(.black, for: .normal)
//
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 1)
//        button.layer.shadowOpacity = 0.2
//        button.layer.cornerRadius = 10
//
//        return button
//    }()
//
//    // MARK: - viewDidLoad
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        idTextField.delegate = self
//        pwTextField.delegate = self
//
//        view.backgroundColor = .systemBackground
//
//        idTextField.text = UserDefaults.standard.string(forKey: "email")
//        pwTextField.text = UserDefaults.standard.string(forKey: "password")
//        setUpViews()
//        setUpConstraints()
//    }
//
//    // MARK: - viewWillAppear
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let checkBoxSelected = UserDefaults.standard.bool(forKey: "checkBoxSelected")
//
//        if checkBoxSelected {
//            idTextField.text = UserDefaults.standard.string(forKey: "savedID")
//            pwTextField.text = ""
//            checkedButton.isSelected = true
//        } else {
//            idTextField.text = ""
//            pwTextField.text = ""
//
//            checkedButton.isSelected = false
//        }
//        // 페이지 벗어났을때 텍스트필드 초기화
//        if checkedButton.isSelected {
//            idTextField.text = UserDefaults.standard.string(forKey: "savedID")
//            pwTextField.text = ""
//
//        } else {
//            idTextField.text = ""
//            pwTextField.text = ""
//        }
//
//        hideKeyboardTappedAround()
//    }
//
//    // 화면에 나타나는 곳
//    private func setUpViews() {
//        view.addSubview(doodleImageView)
//        view.addSubview(loginStackView)
//        view.addSubview(saveIDLabel)
//        view.addSubview(checkedButton)
//        view.addSubview(signUpButton)
//        view.addSubview(findPasswordButton)
//        view.addSubview(kakaoLoginButton)
//    }
//
//    // 레이아웃
//    private func setUpConstraints() {
//        let safeArea = view.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([
//            // DooDle 이미지뷰
//            doodleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            doodleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
//            doodleImageView.widthAnchor.constraint(equalToConstant: 100),
//            doodleImageView.heightAnchor.constraint(equalToConstant: 100),
//
//            // 아이디 텍스트필드
//            idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
//            idTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
//            idTextField.heightAnchor.constraint(equalToConstant: 45.0),
//
//            // 비밀번호 텍스트필드
//            pwTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
//            pwTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
//            pwTextField.heightAnchor.constraint(equalToConstant: 45.0),
//
//            // 로그인 버튼
//            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
//            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
//            loginButton.heightAnchor.constraint(equalToConstant: 35),
//
//            // 1. 아이디,비밀번호,로그인버튼 스택뷰
//            loginStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            loginStackView.topAnchor.constraint(equalTo: doodleImageView.bottomAnchor, constant: 100),
//
//            // 체크마크 버튼
//            checkedButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
//            checkedButton.centerYAnchor.constraint(equalTo: saveIDLabel.centerYAnchor),
//            checkedButton.rightAnchor.constraint(equalTo: saveIDLabel.leftAnchor, constant: -3),
//            checkedButton.widthAnchor.constraint(equalToConstant: 17),
//            checkedButton.heightAnchor.constraint(equalToConstant: 17),
//            checkedButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
//
//            // 아이디 저장라벨
//            saveIDLabel.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
//            saveIDLabel.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
//            // saveIDLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
//
//            // 회원가입 버튼
//            signUpButton.centerYAnchor.constraint(equalTo: findPasswordButton.centerYAnchor),
//            signUpButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
//            signUpButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40),
//
//            // 비밀번호찾기 버튼
//            findPasswordButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
//            findPasswordButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
//
//            // 카카오톡 로그인 버튼
//            kakaoLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
//            kakaoLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
//            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 35),
//            kakaoLoginButton.topAnchor.constraint(equalTo: findPasswordButton.bottomAnchor, constant: 45)
//        ])
//    }
//
//    // MARK: - 액션, 기능, 데이터 저장
//
//    // 로그인 버튼 누를시
//    @objc func loginButtonTapped() {
//        guard let idText = idTextField.text,
//              !idText.isEmpty,
//              let pwText = pwTextField.text,
//              !pwText.isEmpty
//        else {
//            print("아이디 또는 비밀번호가 없음.")
//            return
//        }
//
//        // 입력된 아이디와 비밀번호가 저장된 사용자 정보와 일치하는지 확인
//        if let userData = UserDefaults.standard.data(forKey: "user"),
//           let user = try? JSONDecoder().decode(User.self, from: userData),
//           user.email == idText && user.password == pwText
//        {
//            // 체크박스 선택여부
//            if checkedButton.isSelected {
//                UserDefaults.standard.set(idText, forKey: "savedID")
//            } else {
//                UserDefaults.standard.removeObject(forKey: "savedID")
//            }
//
//            // 다음 페이지 이동
//            let doneVC = LoginDoneViewController()
//            present(doneVC, animated: true)
//
//        } else {
//            print("아이디 또는 비밀번호 틀림.")
//        }
//    }
//
//    // 체크마크 버튼 누를시
//    @objc func checkedButtonTapped(_ sender: UIButton) {
//        sender.isSelected.toggle()
//        UserDefaults.standard.set(sender.isSelected, forKey: "checkBoxSelected")
//
//        // 체크박스가 선택된 상태라면 현재 아이디 텍스트필드의 값을 저장
//        if sender.isSelected {
//            if let idText = idTextField.text, !idText.isEmpty {
//                UserDefaults.standard.set(idText, forKey: "savedID")
//            }
//        } else { // 체크박스가 해제된 상태라면 저장된 아이디 정보 삭제
//            UserDefaults.standard.removeObject(forKey: "savedID")
//        }
//    }
//
//    // 회원가입 버튼 누를시 화면이동
//    @objc func signUpButtonTapped() {
//        let signupVC = SignupViewController()
//        navigationController?.pushViewController(signupVC, animated: true)
//    }
//
//    // 텍스트필드 이외부분 터치했을때 키보드내려감
//    func hideKeyboardTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(SigninViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
// }
//
//// MARK: - UITextFieldDelegate
//
// extension SigninViewController: UITextFieldDelegate {
//    // 텍스트필드 터치시 플레이스홀더 텍스트 사라짐
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == idTextField && textField.placeholder == idPlaceholder {
//            textField.placeholder = ""
//
//        } else if textField == pwTextField && textField.placeholder == pwPlaceholder {
//            textField.placeholder = ""
//        }
//    }
//
//    func textFieldDidEndEditing(_ textfield: UITextField) {
//        if textfield == idTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = idPlaceholder
//
//        } else if textfield == pwTextField && (textfield.text?.isEmpty ?? true) {
//            textfield.placeholder = pwPlaceholder
//        }
//    }
//
//    // 키보드 엔터버튼 return으로 변경, return 버튼 누를시 키보드 내려감
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        dismiss(animated: true, completion: nil)
//
//        return true
//    }
// }
//
// struct User: Codable {
//    var email: String
//    var name: String
//    var password: String
// }
