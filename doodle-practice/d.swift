// BaseUITextField

import UIKit

class BaseUITextField: UITextField {
    
    let isVisible: Bool
    
    init(frame: CGRect, secure: Bool) {
        
        self.isVisible = secure
        
        super.init(frame: frame)
        
        configure(secure)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func configure(_ isVisible: Bool) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        font = UIFont.systemFont(ofSize: 16)
        
        keyboardType = .default
        
        spellCheckingType = .no
        
        autocorrectionType = .no
        
        autocapitalizationType = .none
        
        layer.cornerRadius = CGFloat(8)
        
        layer.borderWidth = CGFloat(0)
        
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOpacity = 0.2
        
        isSecureTextEntry = isVisible
    }
}
