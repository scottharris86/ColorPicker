//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by scott harris on 2/20/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPicker: UIControl {
    
    // MARK: - Properties
    
    var color: UIColor = .white
    
    var colorWheel = ColorWheel()
    var brightnessSlider = UISlider()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    // MARK: - View Lifecycle
    
    func setupSubviews() {
        backgroundColor = .clear
        
        // Color wheel
        colorWheel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorWheel)
        
        NSLayoutConstraint.activate([
            colorWheel.topAnchor.constraint(equalTo: topAnchor),
            colorWheel.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorWheel.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorWheel.heightAnchor.constraint(equalTo: colorWheel.widthAnchor)
        ])
        
        // Brightness slider
        brightnessSlider.minimumValue = 0
        brightnessSlider.maximumValue = 1
        brightnessSlider.value = 0.8
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        brightnessSlider.addTarget(self, action: #selector(changedBrightness), for: .valueChanged)
        addSubview(brightnessSlider)
        
        NSLayoutConstraint.activate([
            brightnessSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            brightnessSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            brightnessSlider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    // MARK: - Actions
    
    @objc func changedBrightness() {
        colorWheel.brightness = CGFloat(brightnessSlider.value)
    }
    
    // MARK: - Touch Tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        print("begin tracking")
        color = colorWheel.color(for: touchPoint)
        sendActions(for: [.touchDown, .valueChanged])
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            color = colorWheel.color(for: touchPoint)
            sendActions(for: [.touchDragInside, .valueChanged])
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        defer { super.endTracking(touch, with: event) }
        guard let touch = touch else { return }
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            color = colorWheel.color(for: touchPoint)
            sendActions(for: [.touchUpInside, .valueChanged])
        } else {
            sendActions(for: [.touchUpOutside])
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
    
}
