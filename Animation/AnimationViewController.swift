//
//  AnimationViewController.swift
//  Animation
//
//  Created by Лаванда on 08.05.2023.
//

import UIKit

class AnimationViewController: UIViewController {
    
    let layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var animationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 90
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderValueDidChanged(_:)), for: .touchUpInside)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutMargins = layoutMargins
        view.backgroundColor = .white
        view.addSubview(animationView)
        view.addSubview(slider)
        setConstraints()
    }

    private func setConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200),

            animationView.heightAnchor.constraint(equalToConstant: 100),
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        resizeView(view: animationView, parameter: value)
        rotateView(view: animationView, degrees: value)
        moveView(animationView, parameter: value)
        
    }
    
    @objc private func sliderValueDidChanged(_ sender: UISlider) {
        
            var value: Float = sender.value
            resizeView(view: animationView, parameter: value)
            rotateView(view: animationView, degrees: value)
            moveView(animationView, parameter: value)
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.0005, repeats: true) { timer in
                value += 0.1
                if value <= 90 {
                    self.resizeView(view: self.animationView, parameter: value)
                    self.rotateView(view: self.animationView, degrees: value)
                    self.moveView(self.animationView, parameter: value)
                } else {
                    timer.invalidate()
                }
            }
            sender.setValue(90, animated: true)
            self.resizeView(view: self.animationView, parameter: 90)
            self.rotateView(view: self.animationView, degrees: 90)
            self.moveView(self.animationView, parameter: 90)
    }
    
    func resizeView(view: UIView, parameter: Float) {
        // Ensure the parameter is in the range of 0-90
        let validParameter = max(0, min(90, parameter))
        
        // Calculate the scale factor based on the parameter's value
        let scaleFactor = CGFloat(validParameter/90) * 0.5 + 1
        
        // Apply the scaling transform to the view
        view.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }
    
    func rotateView(view: UIView, degrees: Float) {
        let radians = CGFloat(degrees * Float.pi / 180)
        let rotation = view.transform.rotated(by: radians)
        view.transform = rotation
    }
    
    func moveView(_ view: UIView, parameter: Float) {
        
        let width = view.superview?.bounds.width ?? 0
        let padding: CGFloat = 20
        let minX = padding + view.bounds.width / 2
        let maxX = width - (view.bounds.width / 2) * 1.5 - padding
        let centerX = minX + (maxX - minX) * CGFloat(parameter/90)
        print(animationView.frame.width)
        view.center.x = centerX
    }
}

