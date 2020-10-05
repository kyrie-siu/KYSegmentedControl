//
//  KYSegmentedControl.swift
//  KYSegmentedControl
//
//  Created by SIU Suet Long on 1/10/2020.
//

import UIKit

public protocol KYSegmentedControlDelegate: class {
    func didSegmentSelected(index: Int)
}

open class KYSegmentedControl: UIControl {
    private struct Constants {
        static let height: CGFloat = 36
        static let defaultTextColor: UIColor = .darkText
        static let highlightTextColor: UIColor = .white
        static let backgroundColor: UIColor = .systemGroupedBackground
        static let sliderColor: UIColor = .red
        static let sliderMargin: CGFloat = 3
        static let font: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let highlightFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let isSliderShadowHidden: Bool = true
    }
    
    class SegmentLabel: UILabel {
        var topInset: CGFloat = 0.0
        var bottomInset: CGFloat = 0.0
        var leftInset: CGFloat = 8.0
        var rightInset: CGFloat = 8.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets(top: self.topInset,
                                      left: self.leftInset,
                                      bottom: self.bottomInset,
                                      right: self.rightInset)
            super.drawText(in: rect.inset(by: insets))
           }

           override var intrinsicContentSize: CGSize {
              get {
                 var contentSize = super.intrinsicContentSize
                 contentSize.height += topInset + bottomInset
                 contentSize.width += leftInset + rightInset
                 return contentSize
              }
           }
    }
    
    class SliderView: UIView {
        fileprivate let sliderMaskView = UIView()

        var cornerRadius: CGFloat! {
            didSet {
                layer.cornerRadius = self.cornerRadius
                self.sliderMaskView.layer.cornerRadius = self.cornerRadius
            }
        }

        override var frame: CGRect {
            didSet {
                self.sliderMaskView.frame = self.frame
            }
        }

        override var center: CGPoint {
            didSet {
                self.sliderMaskView.center = self.center
            }
        }

        init() {
            super.init(frame: .zero)
            self.setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setup()
        }

        private func setup() {
            layer.masksToBounds = true
            self.sliderMaskView.backgroundColor = .black
        }
        
        open func addShadow() {
            self.sliderMaskView.layer.shadowColor = UIColor.black.cgColor
            self.sliderMaskView.layer.shadowRadius = 8
            self.sliderMaskView.layer.shadowOpacity = 0.4
            self.sliderMaskView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        open func removeShadow() {
            self.sliderMaskView.layer.shadowOpacity = 0
        }
    }
    
    // MARK: - Appearance
    open var defaultTextColor: UIColor = Constants.defaultTextColor {
        didSet {
            self.updateLabelsColor(with: self.defaultTextColor, selected: false)
        }
    }
    
    open var highlightTextColor: UIColor = Constants.highlightTextColor {
        didSet {
            self.updateLabelsColor(with: self.defaultTextColor, selected: true)
        }
    }
    
    open var containerBackgroundColor: UIColor = Constants.backgroundColor {
        didSet {
            self.containerView.backgroundColor = self.containerBackgroundColor
        }
    }
    
    open var sliderColor: UIColor = Constants.sliderColor {
        didSet {
            self.selectedContainerView.backgroundColor = self.sliderColor
        }
    }
    
    open var font: UIFont = Constants.font {
        didSet {
            self.updateLabelsFont(with: font, selected: false)
        }
    }
    
    open var highlightFont: UIFont = Constants.highlightFont {
        didSet {
            self.updateLabelsFont(with: font, selected: true)
        }
    }
    
    open var isSliderShadowHidden: Bool = Constants.isSliderShadowHidden {
        didSet {
            if self.isSliderShadowHidden {
                self.sliderView.removeShadow()
            } else {
                self.sliderView.addShadow()
            }
        }
    }
    
    // MARK: - Properties
    open weak var delegate: KYSegmentedControlDelegate?

    private(set) open var selectedSegmentIndex: Int = 0
    
    private var segments: [SegmentLabel] = []
    private var selectedSegments: [SegmentLabel] = []
    
    private var numberOfSegments: Int {
        return self.segments.count
    }
    
    private var correction: CGFloat = 0
    
    private lazy var containerView: UIView = UIView()
    private lazy var segmentStackView: UIStackView = UIStackView()
    private lazy var selectedContainerView: UIView = UIView()
    private lazy var selectedSegmentStackView: UIStackView = UIStackView()
    private lazy var sliderView: SliderView = SliderView()
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    // MARK: - Setup
    private func setup() {
        self.segmentStackView.axis = .horizontal
        self.segmentStackView.alignment = .center
        self.segmentStackView.distribution = .fillEqually
        
        self.selectedSegmentStackView.axis = .horizontal
        self.selectedSegmentStackView.alignment = .center
        self.selectedSegmentStackView.distribution = .fillEqually
        
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.segmentStackView)
        self.containerView.addSubview(self.selectedContainerView)
        self.selectedContainerView.addSubview(self.selectedSegmentStackView)
        self.selectedContainerView.addSubview(self.sliderView)
        
        self.setupConstraints()
        self.addTapGesture()
        self.addDragGesture()
    }
    
    private func setupConstraints() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.selectedContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.selectedSegmentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalToConstant: Constants.height),
            self.containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.segmentStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.segmentStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.segmentStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.segmentStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.selectedContainerView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.selectedContainerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.selectedContainerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.selectedContainerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.selectedSegmentStackView.topAnchor.constraint(equalTo: self.selectedContainerView.topAnchor),
            self.selectedSegmentStackView.bottomAnchor.constraint(equalTo: self.selectedContainerView.bottomAnchor),
            self.selectedSegmentStackView.leadingAnchor.constraint(equalTo: self.selectedContainerView.leadingAnchor),
            self.selectedSegmentStackView.trailingAnchor.constraint(equalTo: self.selectedContainerView.trailingAnchor)
        ])
    }
    
    // MARK: - Public functions
    open func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }
        
        for label in self.segments {
            label.removeFromSuperview()
        }
        
        for label in self.selectedSegments {
            label.removeFromSuperview()
        }
        
        for title in segments {
            let label = self.createLabel(title: title, selected: false)
            let highlightLabel = self.createLabel(title: title, selected: true)
            
            self.segments.append(label)
            self.selectedSegments.append(highlightLabel)
            
            self.segmentStackView.addArrangedSubview(label)
            self.selectedSegmentStackView.addArrangedSubview(highlightLabel)
        }
        
        self.configureViews()
    }
    
    open func selectSegment(index: Int, animated: Bool) {
        self.moveTo(index: index, animated: animated)
    }
    
    // MARK: - Private functions
    // MARK: View Configuration
    private func configureViews() {
        self.containerView.backgroundColor = self.containerBackgroundColor
        self.selectedContainerView.backgroundColor = self.sliderColor
        
        let sliderWidth = self.frame.width/CGFloat(self.numberOfSegments)
        sliderView.frame = CGRect(x: Constants.sliderMargin,
                                  y: Constants.sliderMargin,
                                  width: sliderWidth - Constants.sliderMargin*2,
                                  height: Constants.height - Constants.sliderMargin*2)

        let cornerRadius = Constants.height/2
        self.containerView.layer.cornerRadius = cornerRadius
        self.selectedContainerView.layer.cornerRadius = cornerRadius
        [self.segmentStackView, self.selectedSegmentStackView].forEach { $0.layer.cornerRadius = cornerRadius }
        self.sliderView.cornerRadius = sliderView.bounds.height/2
        
        self.selectedContainerView.layer.mask = sliderView.sliderMaskView.layer
        self.layoutIfNeeded()
    }
    
    // MARK: Gesture
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tap)
    }

    private func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        self.sliderView.addGestureRecognizer(drag)
    }

    @objc private func didTap(tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: self.containerView)
        self.moveToNearestSegment(location: location)
    }

    @objc private func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            self.moveToNearestSegment(location: self.sliderView.center, velocity: panGesture.velocity(in: sliderView))
        case .began:
            self.correction = panGesture.location(in: self.sliderView).x - self.sliderView.frame.width/2
        case .changed:
            let location = panGesture.location(in: self)
            self.sliderView.center.x = location.x - self.correction
        default:
            break
        }
    }
    
    // MARK: Label
    private func createLabel(title: String, selected: Bool) -> SegmentLabel {
        let label = SegmentLabel()
        label.text = title
        label.textAlignment = .center
        label.textColor = selected ? self.highlightTextColor : self.defaultTextColor
        label.font = selected ? self.highlightFont : self.font
        
        return label
    }
    
    private func updateLabelsColor(with color: UIColor, selected: Bool) {
        let segments = selected ? self.selectedSegments : self.segments
        for label in segments {
            label.textColor = color
        }
    }

    private func updateLabelsFont(with font: UIFont, selected: Bool) {
        let segments = selected ? self.selectedSegments : self.segments
        for label in segments {
            label.font = font
        }
    }
        
    // MARK: Slider
    private func moveToNearestSegment(location: CGPoint, velocity: CGPoint? = nil) {
        var index = self.segmentIndex(for: location)
        
        if let v = velocity {
            if v.x > 500 {
                index = self.selectedSegmentIndex + 1
            } else if v.x < -500 {
                index = self.selectedSegmentIndex - 1
            }
        }
        
        self.moveTo(index: index, animated: true)
    }
    
    private func segmentIndex(for point: CGPoint) -> Int {
        for (index, label) in self.segments.enumerated() {
            guard let frame = self.convertSegmentFrame(segment: label) else {
                fatalError("Segment frame not found")
            }
            
            if frame.contains(point) {
                return index
            }
        }
        
        return 0
    }
    
    private func convertSegmentFrame(segment: SegmentLabel) -> CGRect? {
        return segment.superview?.convert(segment.frame, to: segment.superview)
    }
    
    open func moveTo(index: Int, animated: Bool) {
        let segment = self.segments[index]
        
        guard let frame = self.convertSegmentFrame(segment: segment) else {
            fatalError("Segment frame not found")
        }
        
        let sliderWidth = self.frame.width/CGFloat(self.numberOfSegments)
        let centerPoint = CGPoint(x: frame.origin.x + (frame.size.width / 2),
                                  y: frame.origin.y + (frame.size.height / 2))
        self.sliderView.frame.size = CGSize(width: sliderWidth - Constants.sliderMargin*2, height: Constants.height - Constants.sliderMargin*2)
        
        let duration = animated ? 0.2 : 0.0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear) {
            self.sliderView.center = centerPoint
        }
        
        self.selectedSegmentIndex = index
        self.delegate?.didSegmentSelected(index: index)
        
        
    }
}
