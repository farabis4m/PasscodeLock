//
//  MHPasscodeView.swift
//  SimplePasscodeView
//
//  Copyright © 2018 Geeko Coco. All rights reserved.
//

import UIKit

@objc public protocol SimplePasscodeDelegate: class {
    func didFinishEntering(_ passcode: String)
    @objc optional func didDeleteBackward()
}

public class SimplePasscodeView: UIView {
    
    @IBOutlet private weak var passcodeStackView: UIStackView?
    
    private var contentView: UIView?
    private var passcodeText = String()
    
    public weak var delegate: SimplePasscodeDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        if (contentView == nil) {
            contentView = loadViewFromNib()
            contentView?.frame = bounds
            guard let view = contentView else {return}
            addSubview(view)
            setupPasscodeStackView()
        }
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}

extension SimplePasscodeView: PasscodeConfigurable {
    
    private func setupPasscodeStackView() {
        guard let passcodeStackView = passcodeStackView else { return }
        placeHolderViews.forEach { (view) in
            passcodeStackView.addArrangedSubview(view)
        }
        passcodeStackView.spacing = CGFloat(length)
        
        passcodeStackView.translatesAutoresizingMaskIntoConstraints = false
        passcodeStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        passcodeStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        guard 0..<length ~= customSpacingPosition else { return }
        passcodeStackView.distribution = .fill
        passcodeStackView.setCustomSpacing(CGFloat(customSpacing),
                                            after: passcodeStackView.arrangedSubviews[customSpacingPosition])
    }
    
    private var placeHolderViews: [PinView] {
        var views = [PinView]()
        for _ in 0..<length {
            let pinView: PinView = PinView()
            views.append(pinView)
        }
        return views
    }
    
    public func clear() {
        passcodeStackView?.arrangedSubviews.forEach { (view) in
            if let pinView = view as? PinView {
                pinView.update(with: false, andText: nil, isSecureEntry: isSecureEntry)
            }
        }
        passcodeText.removeAll()
    }
}

extension SimplePasscodeView {
    public var hasText: Bool {
        return !passcodeText.isEmpty
    }
    
    public func insertText(_ text: String) {
        guard canInsertCharacters() else { return }
        passcodeText.append(text)
        
        guard let view = passcodeStackView?.arrangedSubviews.filter({ (view) -> Bool in
            if let pinView = view as? PinView,
                pinView.isEmpty() {
                return true
            }
            return false
        }).first as? PinView else { return }
        
        view.update(with: true, andText: text, isSecureEntry: isSecureEntry)
        
        if passcodeText.count == length {
            delegate?.didFinishEntering(passcodeText)
        }
    }
    
    public func deleteBackward() {
        guard hasText else { return }
        
        passcodeText.removeLast()
        delegate?.didDeleteBackward?()
        
        guard let view = passcodeStackView?.arrangedSubviews.filter({ (view) -> Bool in
            if let pinView = view as? PinView,
                !pinView.isEmpty() {
                return true
            }
            return false
        }).last as? PinView else { return  }
        
        view.update(with: false, andText: nil, isSecureEntry: isSecureEntry)
    }
    
    private func canInsertCharacters() -> Bool {
        return passcodeText.count != length
    }
}
