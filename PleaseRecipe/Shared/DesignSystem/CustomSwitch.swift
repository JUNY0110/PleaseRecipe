//
//  CustomSwitch.swift
//  PleaseRecipe
//
//  Created by 지준용 on 6/24/24.
//

import UIKit

import SnapKit

protocol CustomSwitchDelegate: AnyObject {
    func sendStatus(_ isOn: Bool)
}

final class CustomSwitch: UIControl {
    
    // MARK: - Properties
    weak var delegate: CustomSwitchDelegate?
    private var isOn: Bool = true {
        didSet {
            changeStatus()
            delegate?.sendStatus(isOn)
        }
    }
    
    // MARK: - Views
    private let barView: CustomRoundView = {
        $0.backgroundColor = .secondaryLabel
        return $0
    }(CustomRoundView())
    
    private let circleView: CustomRoundView = {
        $0.backgroundColor = .white
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        return $0
    }(CustomRoundView())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func addSubviews() {
        addSubview(barView)
        addSubview(circleView)
    }
    
    private func layout() {
        barView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.centerY.equalTo(barView.snp.centerY)
            $0.right.equalTo(barView.snp.right)
            $0.size.equalTo(25)
        }
        
        self.barView.backgroundColor = .mainRed
    }
}


// MARK: - Toggle Action
extension CustomSwitch {
    private func changeStatus() {
        let circleCenter: CGFloat
        let barColor: UIColor
        
        if isOn {
            circleCenter = frame.width - (circleView.frame.width / 2)
            barColor = .mainRed
        } else {
            circleCenter = circleView.frame.width / 2
            barColor = .secondaryLabel
        }
        
        UIView.animate(withDuration: 0.2) {
            self.barView.backgroundColor = barColor
            self.circleView.center.x = circleCenter
        }
    }
}


// MARK: - Methods
extension CustomSwitch {
    @available(*, unavailable)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn.toggle()
    }
}
