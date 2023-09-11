// TextFieldContainerView

import UIKit

class TextFieldContainerView: UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func configure() {
        
        backgroundColor = .white
        
        layer.cornerRadius = CGFloat(8)
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOffset = CGSize(width: 0, height: 1)
        
        layer.shadowOpacity = 0.2
        
        layer.shadowRadius = CGFloat(2)
        
        clipsToBounds = false
        
    }
    
}
