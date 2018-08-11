//
//  MHPasscodeView.swift
//  MHPasscodeView
//
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

public protocol Passcodable: class {
    func didEnter(_ passcode: String)
}

final class MHPasscodeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var passcodeStackView: UIStackView!
    
    internal weak var delegate: Passcodable?
    internal var passscode = String()
    internal var keyboardType: UIKeyboardType = .numberPad
    internal var passcodeConfiguration: PasscodeConfiguration = PasscodeConfiguration() {
        didSet {
            setupPasscodeStackView()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let view = loadViewFromNib()
        view.frame = bounds
        addSubview(view)
        
        let _ = becomeFirstResponder()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    internal func set(_ passcodeConfiguration: PasscodeConfiguration) {
        self.passcodeConfiguration = passcodeConfiguration
    }
}

extension MHPasscodeView {
    
    private func setupPasscodeStackView() {
        placeHolderViews.forEach { (view) in
            passcodeStackView.addArrangedSubview(view)
        }
        passcodeStackView.spacing = CGFloat(passcodeConfiguration.defaultSpacing)
        
        guard 0..<passcodeConfiguration.length ~= passcodeConfiguration.paddingPosition else { return }
        passcodeStackView.distribution = .fill
        passcodeStackView.setCustomSpacing(CGFloat(passcodeConfiguration.customSpacing),
                                           after: passcodeStackView.arrangedSubviews[passcodeConfiguration.paddingPosition])
    }
    
    private var placeHolderViews: [PinView] {
        var views = [PinView]()
        for _ in 0..<passcodeConfiguration.length {
            let pinView: PinView = PinView()
            pinView.translatesAutoresizingMaskIntoConstraints = false
            pinView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            pinView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            pinView.indicator = Indicator()
            pinView.indicator?.translatesAutoresizingMaskIntoConstraints = false
            pinView.indicator?.widthAnchor.constraint(equalToConstant: 10).isActive = true
            pinView.indicator?.heightAnchor.constraint(equalToConstant: 10).isActive = true
            pinView.indicator?.centerXAnchor.constraint(equalTo: pinView.centerXAnchor).isActive = true
            pinView.indicator?.centerYAnchor.constraint(equalTo: pinView.centerYAnchor).isActive = true
            
            views.append(pinView)
        }
        return views
    }
}
