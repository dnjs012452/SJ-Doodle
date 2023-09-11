// 로그인 페이지

import SnapKit
import Then
import UIKit

struct User: Codable {
    var email: String
    
    var name: String
    
    var password: String
}

final class SigninViewController: UIViewController {
    private lazy var appLogoImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.image = UIImage(named: "DoodleImage")
        
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var emailContainerView = TextFieldContainerView().then {
        $0.addSubViews([emailTextField, emailPlaceholderLabel])
    }
    
    private lazy var emailTextField = BaseUITextField(frame: .zero, secure: false)
    
    private lazy var emailPlaceholderLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.text = "이메일"
        
        $0.font = UIFont.systemFont(ofSize: 16)
        
        $0.textColor = .lightGray
    }
    
    private lazy var passwordTextFieldView = TextFieldContainerView().then {
        $0.addSubViews([passwordTextField,
                        passwordPlaceholderLabel,
                        visibleButton])
    }
    
    private lazy var passwordPlaceholderLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.text = "비밀번호"
        
        $0.font = UIFont.systemFont(ofSize: 16)
        
        $0.textColor = .lightGray
    }
    
    private lazy var passwordTextField = BaseUITextField(frame: .zero, secure: true)
    
    private lazy var visibleButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setImage(.eyeSlashImage, for: .normal)
        
        $0.setImage(.eyeImage, for: .selected)
        
        $0.imageView?.contentMode = .scaleAspectFill
        
        $0.tintColor = .black
        
        $0.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
    }
    
    private lazy var loginButton = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setTitle("로그인", for: .normal)
        
        $0.backgroundColor = UIColor(hex: "FFCB47")
        
        $0.setTitleColor(.black, for: .normal)
        
        $0.layer.shadowColor = UIColor.black.cgColor
        
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        $0.layer.shadowOpacity = 0.2
        
        $0.layer.cornerRadius = CGFloat(8)
        
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var checkedButton = UIButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setImage(.uncheckedImage, for: .normal)
        
        $0.setImage(.checkedImage, for: .selected)
        
        $0.addTarget(self, action: #selector(checkedButtonTapped), for: .touchUpInside)
    }
    
    private lazy var emailSaveLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.text = "이메일저장"
        
        $0.textColor = UIColor(hex: "141617")
        
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    // MARK: - Deprecated

    private lazy var signupButton = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setTitle("회원가입", for: .normal)
        
        $0.setTitleColor(UIColor(hex: "FFFFFF"), for: .normal)
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    private lazy var passwordResetButton = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setTitle("비밀번호 재설정", for: .normal)
        
        $0.setTitleColor(UIColor(hex: "141617"), for: .normal)
        
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        $0.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 1. 아이디, 비밀번호, 로그인 스택뷰

    private lazy var containerStackView = UIStackView(arrangedSubviews: [emailContainerView,
                                                                         passwordTextFieldView,
                                                                         loginButton]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.axis = .vertical
        
        $0.spacing = 10
    }
    
    private lazy var createAccountButton = UIButton(type: .system).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.setTitle("계정 만들기", for: .normal)
        
        $0.backgroundColor = UIColor(hex: "FFCB47")
        
        $0.setTitleColor(.black, for: .normal)
        
        $0.layer.shadowColor = UIColor.black.cgColor
        
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        $0.layer.shadowOpacity = 0.2
        
        $0.layer.cornerRadius = CGFloat(8)
        
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 텍스트 필드 애니메이션 효과
    
    // 텍스트 필드의 레이아웃 변경을 위한 변수
    lazy var emailInfoLabelCenterYConstraint = emailPlaceholderLabel.centerYAnchor.constraint(equalTo: emailContainerView.centerYAnchor)
    
    lazy var passwordInfoLabelCenterYConstraint = passwordPlaceholderLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
    
    // MARK: - Construnctor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .systemBackground
        
        emailTextField.text = UserDefaults.standard.string(forKey: "email")
        passwordTextField.text = UserDefaults.standard.string(forKey: "password")
        setUI()
        setUpConstraints()
        createAccountButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let checkBoxSelected = UserDefaults.standard.bool(forKey: "checkBoxSelected")
        
        if checkBoxSelected {
            emailTextField.text = UserDefaults.standard.string(forKey: "savedID")
            passwordTextField.text = ""
            checkedButton.isSelected = true
        } else {
            emailTextField.text = ""
            passwordTextField.text = ""
            
            checkedButton.isSelected = false
        }
        
        // 페이지 벗어났을때 텍스트필드 초기화
        if checkedButton.isSelected {
            emailTextField.text = UserDefaults.standard.string(forKey: "savedID")
            
            passwordTextField.text = ""
            
        } else {
            emailTextField.text = ""
            
            passwordTextField.text = ""
        }
        
        hideKeyboardTappedAround()
    }
    
    // MARK: - Set UI

    private func setUI() {
        view.addSubViews([
            appLogoImageView,
            containerStackView,
            emailSaveLabel,
            checkedButton,
            signupButton,
            passwordResetButton,
            createAccountButton
        ])
    }
    
    // MARK: - Set Layout
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // DooDle 이미지뷰
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            appLogoImageView.widthAnchor.constraint(equalToConstant: 100),
            appLogoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // 이메일 텍스트뷰
            emailContainerView.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: 100),
            emailContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailContainerView.heightAnchor.constraint(equalToConstant: 45),
            
            // 이메일 텍스트 라벨
            emailPlaceholderLabel.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 8),
            emailPlaceholderLabel.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -8),
            // emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
            emailInfoLabelCenterYConstraint,
            
            // 아이디 텍스트필드
            emailTextField.topAnchor.constraint(equalTo: emailContainerView.topAnchor, constant: 15),
            emailTextField.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 2),
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -8),
            emailTextField.heightAnchor.constraint(equalToConstant: 45.0),
            
            // 비밀번호 텍스트뷰
            passwordTextFieldView.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 10),
            passwordTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextFieldView.heightAnchor.constraint(equalToConstant: 45),
            
            // 비밀번호 텍스트 라벨
            passwordPlaceholderLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordPlaceholderLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            // passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor),
            passwordInfoLabelCenterYConstraint,
            
            // 비밀번호 텍스트필드
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 2),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45.0),
            
            // 표시 버튼
            visibleButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            visibleButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15),
            visibleButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            visibleButton.widthAnchor.constraint(equalToConstant: 35),
            visibleButton.heightAnchor.constraint(equalToConstant: 35),
            
            // 로그인 버튼
            loginButton.topAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
            
            // 1. 아이디,비밀번호,로그인버튼 스택뷰
            containerStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            containerStackView.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: 100),
            
            // 체크마크 버튼
            checkedButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 10),
            checkedButton.centerYAnchor.constraint(equalTo: emailSaveLabel.centerYAnchor),
            checkedButton.rightAnchor.constraint(equalTo: emailSaveLabel.leftAnchor, constant: -3),
            checkedButton.widthAnchor.constraint(equalToConstant: 17),
            checkedButton.heightAnchor.constraint(equalToConstant: 17),
            checkedButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            
            // 아이디 저장라벨
            emailSaveLabel.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor),
            emailSaveLabel.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 10),
            // saveIDLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            
            // 회원가입 버튼
            signupButton.centerYAnchor.constraint(equalTo: passwordResetButton.centerYAnchor),
            signupButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 10),
            signupButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 35),
            
            // 비밀번호 재설정 버튼
            passwordResetButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 10),
            passwordResetButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            
            // 카카오톡 로그인 버튼
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
            createAccountButton.heightAnchor.constraint(equalToConstant: 35),
            createAccountButton.topAnchor.constraint(equalTo: passwordResetButton.bottomAnchor, constant: 45)
        ])
    }
}

// MARK: - Custom Method

extension SigninViewController {
    @objc func passwordSecureModeSetting() {
        passwordTextField.isSecureTextEntry.toggle()
        
        visibleButton.isSelected = !passwordTextField.isSecureTextEntry
    }
    
    // 로그인 버튼 누를시
    @objc func loginButtonTapped() {
        guard let idText = emailTextField.text,
              !idText.isEmpty,
              let pwText = passwordTextField.text,
              !pwText.isEmpty
        
        else {
            print("아이디 또는 비밀번호가 없음.")
            
            return
        }
        
        // 입력된 아이디와 비밀번호가 저장된 사용자 정보와 일치하는지 확인
        if let usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
            for userData in usersData {
                if let user = try? JSONDecoder().decode(User.self, from: userData),
                   user.email == idText, user.password == pwText
                {
                    // 체크박스 선택여부
                    if checkedButton.isSelected {
                        UserDefaults.standard.set(idText, forKey: "email")
                        
                    } else {
                        UserDefaults.standard.removeObject(forKey: "email")
                    }
                    
                    // 다음 페이지 이동
                    let doneVC = MapViewController()
                    
                    doneVC.modalPresentationStyle = .fullScreen
                    
                    present(doneVC, animated: true)
                    
                } else {
                    print("아이디 또는 비밀번호 틀림.")
                }
            }
        }
    }
    
    @objc func kakaoLoginButtonTapped() {
        let bottomViewController = BottomViewController()
        
        navigationController?.pushViewController(bottomViewController, animated: true)
    }

    // 체크마크 버튼 누를시
    @objc func checkedButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        UserDefaults.standard.set(sender.isSelected, forKey: "checkBoxSelected")
        
        // 체크박스가 선택된 상태라면 현재 아이디 텍스트필드의 값을 저장
        if sender.isSelected {
            if let idText = emailTextField.text, !idText.isEmpty {
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
        let alert = UIAlertController(title: "비밀번호 재설정", message: "비밀번호를 변경하시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { _ in
            // 비밀번호 재설정 하는 알럿창
            let newPasswordAlert = UIAlertController(title: "새로운 비밀번호", message: nil, preferredStyle: .alert)
            
            newPasswordAlert.addTextField { textfield in
                textfield.placeholder = "비밀번호"
            }
            
            newPasswordAlert.addTextField { textfield in
                textfield.placeholder = "비밀번호 확인"
            }
            
            let confirmAction = UIAlertAction(title: "완료", style: .default) { _ in
                guard let passwordField1 = newPasswordAlert.textFields?[0],
                      let passwordField2 = newPasswordAlert.textFields?[1]
                else {
                    return
                }
                
                if passwordField1.text == passwordField2.text {
                    print("새로운 비밀번호 업데이트완료")
                    
                    if var usersData = UserDefaults.standard.array(forKey: "users") as? [Data] {
                        for (index, userData) in usersData.enumerated() {
                            if var user = try? JSONDecoder().decode(User.self, from: userData),
                               user.email == self.emailTextField.text
                            {
                                // 새롭게 입력된 비밀번호로 변경합니다.
                                user.password = passwordField1.text ?? ""
                                
                                do {
                                    // 변경된 유저 정보를 다시 인코딩합니다.
                                    
                                    let updatedUserData = try JSONEncoder().encode(user)
                                    
                                    // 배열 내 해당 유저 정보를 갱신합니다.
                                    
                                    usersData[index] = updatedUserData
                                    
                                    // 갱신된 유저 정보 배열을 UserDefaults에 다시 저장합니다.
                                    
                                    UserDefaults.standard.set(usersData, forKey: "users")
                                    
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                    
                } else {
                    print("새로운 비밀번호 일치하지않음.")
                    
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
    
    // MARK: - 키보드 설정
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 텍스트필드 이외부분 터치했을때 키보드내려감
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SigninViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
}

// MARK: - UITextFieldDelegate

extension SigninViewController: UITextFieldDelegate {
    // 텍스트 필드 시작시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailContainerView.backgroundColor = .white
            
            emailPlaceholderLabel.font = UIFont.systemFont(ofSize: 12)
            
            // 레이아웃 변화
            emailInfoLabelCenterYConstraint.constant = -13
        }
        
        if textField == passwordTextField {
            passwordTextFieldView.backgroundColor = .white
            
            passwordPlaceholderLabel.font = UIFont.systemFont(ofSize: 12)
            
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        // 애니메이션 느낌 나게, 레이아웃 변화되는걸 부드럽게 해줌
        UIView.animate(withDuration: 0.2) {
            self.emailContainerView.layoutIfNeeded()
            
            self.passwordTextFieldView.layoutIfNeeded()
        }
    }
    
    // 텍스트 필드 끝났을시
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailContainerView.backgroundColor = .white
            
            if emailTextField.text == "" {
                emailPlaceholderLabel.font = UIFont.systemFont(ofSize: 16)
                
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == passwordTextField {
            passwordTextFieldView.backgroundColor = .white
            
            if passwordTextField.text == "" {
                passwordPlaceholderLabel.font = UIFont.systemFont(ofSize: 16)
                
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
