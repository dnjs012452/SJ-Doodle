// 로그인페이지
import Alamofire
import SnapKit
import Then
import UIKit

final class SigninViewController: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // Doodle 이미지뷰
    let doodleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let image = UIImage(named: "DoodleImage") {
            imageView.image = image
        }

        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    // 이메일 텍스트필드 뷰
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.clipsToBounds = false

        view.addSubview(idTextField)
        view.addSubview(emailInfoLabel)

        return view
    }()

    // 이메일 라벨
    private var emailInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "이메일 주소"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray

        return label
    }()

    // 아이디 텍스트필드
    private lazy var idTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.font = UIFont.systemFont(ofSize: 16)

        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2

        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.0
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .emailAddress

        return textField
    }()

    // 비밀번호 텍스트필드뷰
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.clipsToBounds = false

        view.addSubview(pwTextField)
        view.addSubview(passwordInfoLabel)
        view.addSubview(passwordSecureButton)

        return view
    }()

    // 비밀번호 라벨
    private var passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray

        return label
    }()

    // 비밀번호 텍스트필드
    private lazy var pwTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.font = UIFont.systemFont(ofSize: 16)

        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2

        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.0
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .default

        textField.isSecureTextEntry = true
        // textField.clearsOnBeginEditing = false

        return textField
    }()

    // eye.fill, eye.slash.fill 버튼
    private lazy var passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.tintColor = UIColor.black

        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)

        return button
    }()

    // 로그인 버튼
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("로그인", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
        button.setTitleColor(.black, for: .normal)

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 10

        // 버튼 활성화, 비활성화 - func 에 해당 기능 추가
        // button.isEnabled = false

        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        return button
    }()

    // 체크마크 버튼
    private lazy var checkedButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.setImage(UIImage(named: "checked"), for: .selected)

        button.addTarget(self, action: #selector(checkedButtonTapped), for: .touchUpInside)

        return button
    }()

    // 아이디저장 라벨
    private lazy var saveIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "아이디저장"
        label.textColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()

    // 회원가입 버튼
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1), for: .normal) // FFCB47
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        return button
    }()

    // 비밀번호 재설정 버튼
    private lazy var findPasswordButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1), for: .normal) // FFCB47
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)

        return button
    }()

    // MARK: - 1. 아이디, 비밀번호, 로그인 스택뷰

    private lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    // 카카오톡 로그인 버튼
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("카카오톡 로그인", for: .normal)
        button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 71/255, alpha: 1) // FFCB47
        button.setTitleColor(.black, for: .normal)

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.cornerRadius = 10

        return button
    }()

    // 구글 로그인 버튼
//    private lazy var googleLoginButton: GIDSignInButton = {
//        let button = GIDSignInButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
//
//        return button
//    }()

    // MARK: - 텍스트 필드 애니메이션 효과

    // 텍스트 필드의 레이아웃 변경을 위한 변수
    lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)

    lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // GIDSignInDelegate 설정
//        GIDSignIn.sharedInstance()?.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self

        view.backgroundColor = .systemBackground

        idTextField.text = UserDefaults.standard.string(forKey: "email")
        pwTextField.text = UserDefaults.standard.string(forKey: "password")
        setUpViews()
        setUpConstraints()

        // 키보드
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let checkBoxSelected = UserDefaults.standard.bool(forKey: "checkBoxSelected")

        if checkBoxSelected {
            idTextField.text = UserDefaults.standard.string(forKey: "savedID")
            pwTextField.text = ""
            checkedButton.isSelected = true
        } else {
            idTextField.text = ""
            pwTextField.text = ""

            checkedButton.isSelected = false
        }
        // 페이지 벗어났을때 텍스트필드 초기화
        if checkedButton.isSelected {
            idTextField.text = UserDefaults.standard.string(forKey: "savedID")
            pwTextField.text = ""

        } else {
            idTextField.text = ""
            pwTextField.text = ""
        }

        hideKeyboardTappedAround()
    }

    // 화면에 나타나는 곳
    private func setUpViews() {
        view.addSubview(doodleImageView)

        view.addSubview(loginStackView)
        view.addSubview(saveIDLabel)
        view.addSubview(checkedButton)
        view.addSubview(signUpButton)
        view.addSubview(findPasswordButton)
        view.addSubview(kakaoLoginButton)
//        view.addSubview(googleLoginButton)
    }

    // MARK: - 레이아웃

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // DooDle 이미지뷰
            doodleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doodleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            doodleImageView.widthAnchor.constraint(equalToConstant: 100),
            doodleImageView.heightAnchor.constraint(equalToConstant: 120),

            // 이메일 텍스트뷰
            emailTextFieldView.topAnchor.constraint(equalTo: doodleImageView.bottomAnchor, constant: 90),
            emailTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextFieldView.heightAnchor.constraint(equalToConstant: 45),

            // 이메일 텍스트 라벨
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8),
            // emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
            emailInfoLabelCenterYConstraint,

            // 아이디 텍스트필드
            idTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15),
            idTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2),
            idTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            idTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8),
            idTextField.heightAnchor.constraint(equalToConstant: 45.0),

            // 비밀번호 텍스트뷰
            passwordTextFieldView.topAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 10),
            passwordTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextFieldView.heightAnchor.constraint(equalToConstant: 45),

            // 비밀번호 텍스트 라벨
            passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            // passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor),
            passwordInfoLabelCenterYConstraint,

            // 비밀번호 텍스트필드
            pwTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            pwTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 2),
            pwTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            pwTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            pwTextField.heightAnchor.constraint(equalToConstant: 45.0),

            // 표시 버튼
            passwordSecureButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordSecureButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15),
            passwordSecureButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -15),
            passwordSecureButton.widthAnchor.constraint(equalToConstant: 20),
            passwordSecureButton.heightAnchor.constraint(equalToConstant: 20),

            // 로그인 버튼
            loginButton.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            loginButton.heightAnchor.constraint(equalToConstant: 35),

            // 1. 아이디,비밀번호,로그인버튼 스택뷰
            loginStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            loginStackView.topAnchor.constraint(equalTo: doodleImageView.bottomAnchor, constant: 100),

            // 체크마크 버튼
            checkedButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
            checkedButton.centerYAnchor.constraint(equalTo: saveIDLabel.centerYAnchor),
            checkedButton.rightAnchor.constraint(equalTo: saveIDLabel.leftAnchor, constant: -3),
            checkedButton.widthAnchor.constraint(equalToConstant: 17),
            checkedButton.heightAnchor.constraint(equalToConstant: 17),
            checkedButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),

            // 아이디 저장라벨
            saveIDLabel.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
            saveIDLabel.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
            // saveIDLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),

            // 회원가입 버튼
            signUpButton.centerYAnchor.constraint(equalTo: findPasswordButton.centerYAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 35),

            // 비밀번호 재설정 버튼
            findPasswordButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 10),
            findPasswordButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),

            // 카카오톡 로그인 버튼
            kakaoLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 35),
            kakaoLoginButton.topAnchor.constraint(equalTo: findPasswordButton.bottomAnchor, constant: 45),

        ])
    }

    // MARK: - 액션, 기능, 데이터 저장

    @objc func passwordSecureModeSetting() {
        pwTextField.isSecureTextEntry.toggle()
        passwordSecureButton.isSelected = !pwTextField.isSecureTextEntry
    }

    // 로그인 버튼 누를시
    @objc func loginButtonTapped() {
        guard let idText = idTextField.text,
              !idText.isEmpty,
              let pwText = pwTextField.text,
              !pwText.isEmpty
        else {
            print("아이디 또는 비밀번호가 없음.")
            return
        }

        // 입력된 아이디와 비밀번호가 저장된 사용자 정보와 일치하는지 확인
        if let usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
            var loginSuccess = false
            for userData in usersData {
                if let user = try? JSONDecoder().decode(User.self, from: userData),
                   user.email == idText && user.password == pwText
                {
                    // 체크박스 선택여부
                    if checkedButton.isSelected {
                        UserDefaults.standard.set(idText, forKey: "email")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "email")
                    }

                    // 다음 페이지 이동
                    let doneVC = MapViewController()
                    present(doneVC, animated: true)
                    loginSuccess = true
                    print("로그인 완료")
                    break
                }
            }
            if !loginSuccess {
                print("아이디 또는 비밀번호 틀림.")
            }
        }
    }

    // 체크마크 버튼 누를시
    @objc func checkedButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        UserDefaults.standard.set(sender.isSelected, forKey: "checkBoxSelected")

        // 체크박스가 선택된 상태라면 현재 아이디 텍스트필드의 값을 저장
        if sender.isSelected {
            if let idText = idTextField.text, !idText.isEmpty {
                UserDefaults.standard.set(idText, forKey: "savedID")
            }
        } else { // 체크박스가 해제된 상태라면 저장된 아이디 정보 삭제
            UserDefaults.standard.removeObject(forKey: "savedID")
        }
    }

    // 회원가입 버튼 누를시 화면이동
    @objc func signUpButtonTapped() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }

    // 비밀번호 재설정 버튼 누를시
    @objc func resetButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 재설정", message: "현재 \(idTextField.text ?? "") 이메일 주소의 비밀번호를 변경하시겠습니까?", preferredStyle: .alert)

        let success = UIAlertAction(title: "확인", style: .default) { _ in
            // 비밀번호 재설정 하는 알럿창
            let newPasswordAlert = UIAlertController(title: "새로운 비밀번호", message: "현재 이메일주소: \(self.idTextField.text ?? "")", preferredStyle: .alert)
            newPasswordAlert.addTextField { textfield in
                textfield.placeholder = "비밀번호"
                // textfield.isSecureTextEntry = true
            }

            newPasswordAlert.addTextField { textfield in
                textfield.placeholder = "비밀번호 확인"
                // textfield.isSecureTextEntry = true
            }

            let confirmAction = UIAlertAction(title: "완료", style: .default) { _ in
                guard let passwordField1 = newPasswordAlert.textFields?[0],
                      let passwordField2 = newPasswordAlert.textFields?[1]
                else {
                    return
                }
                if passwordField1.text == passwordField2.text {
                    self.passwordMatchAlert()
                    print("새로운 비밀번호 업데이트완료")

                    if var usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
                        for (index, userData) in usersData.enumerated() {
                            if var user = try? JSONDecoder().decode(User.self, from: userData),
                               user.email == self.idTextField.text
                            {
                                // 새롭게 입력된 비밀번호로 변경함
                                user.password = passwordField1.text ?? ""

                                do {
                                    // 변경된 유저 정보를 다시 인코딩.
                                    let updatedUserData = try JSONEncoder().encode(user)

                                    // 배열 내 해당 유저 정보를 갱신.
                                    usersData[index] = updatedUserData

                                    // 갱신된 유저 정보 배열을 UserDefaults에 다시 저장
                                    UserDefaults.standard.set(usersData, forKey: "users")

                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }

                } else {
                    print("새로운 비밀번호 일치하지않음.")
                    self.passwordMismatchAlert()
                    return
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            newPasswordAlert.addAction(confirmAction)
            newPasswordAlert.addAction(cancelAction)
            self.present(newPasswordAlert, animated: true)
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
        }

        alert.addAction(success)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    // 불투명 알럿창
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 120, y: 90, width: 240, height: 30))
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

    // 비밀번호가 일치하지 않을때 알럿창
    func passwordMismatchAlert() {
        let alert = UIAlertController(title: nil, message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // 비밀번호가 재설정됐을때 알럿창
    func passwordMatchAlert() {
        showToast(message: "비밀번호가 재설정 되었습니다.")
    }

    @objc func kakaoLoginButtonTapped() {
        let bottomViewController = bottomViewController()
        navigationController?.pushViewController(bottomViewController, animated: true)
    }

    // MARK: - 키보드 설정

    // 텍스트필드 이외부분 터치했을때 키보드내려감
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SigninViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // 키보드 올라올때(보여질때)
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomSpace = view.frame.size.height - loginStackView.frame.origin.y - loginStackView.frame.size.height
            let offset = keyboardSize.height - bottomSpace + 10 // 로그인 버튼과 키보드 사이 간격

            if offset > 0 {
                view.frame.origin.y = -offset
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

// MARK: class 끝

// MARK: - UITextFieldDelegate

extension SigninViewController: UITextFieldDelegate {
    // 텍스트 필드 시작시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == idTextField {
            emailTextFieldView.backgroundColor = .white
            emailInfoLabel.font = UIFont.systemFont(ofSize: 13)
            // 레이아웃 변화
            emailInfoLabelCenterYConstraint.constant = -13
        }
        if textField == pwTextField {
            passwordTextFieldView.backgroundColor = .white
            passwordInfoLabel.font = UIFont.systemFont(ofSize: 13)
            passwordInfoLabelCenterYConstraint.constant = -13
        }

        // 애니메이션 느낌 나게, 레이아웃 변화되는걸 부드럽게 해줌
        UIView.animate(withDuration: 0.2) {
            self.emailTextFieldView.layoutIfNeeded()
            self.passwordTextFieldView.layoutIfNeeded()
        }
    }

    // 텍스트 필드 끝났을시
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == idTextField {
            emailTextFieldView.backgroundColor = .white
            if idTextField.text == "" {
                emailInfoLabel.font = UIFont.systemFont(ofSize: 16)
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == pwTextField {
            passwordTextFieldView.backgroundColor = .white
            if pwTextField.text == "" {
                passwordInfoLabel.font = UIFont.systemFont(ofSize: 16)
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
    }

    // 키보드 엔터버튼 return으로 변경, return 버튼 누를시 키보드 내려감
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)

        return true
    }
}

struct User: Codable {
    var email: String
    var name: String
    var password: String
}
