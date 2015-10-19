//
//  CGStretchImageView.m
//  CGStretch
//
//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import "CGStretchView.h"

@implementation CGStretchView {
    UIPanGestureRecognizer *mainPan;
    UIRotationGestureRecognizer *mainRotation;
    UIPinchGestureRecognizer *mainPinch;
    UITapGestureRecognizer *mainTap;
    CGFloat prevRotation;
    CGFloat prevPinchScale;
    UIView *borderView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Set default property values
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.backgroundColor = [UIColor clearColor];
        [self addSubview:borderView];
        
        _cornerButtonRadius = 15.0f;
        _borderThickness = 1.0f;
        _borderColor = [UIColor blackColor];
        _cornerButtonBackgroundColor = [UIColor whiteColor];
        _cornerButtonBorderEqualsBorder = YES;
        _cornerButtonOriginallyHidden = NO;
        
        _labelFont = [UIFont systemFontOfSize:12];
        _labelTextColor = [UIColor blackColor];
        
        _panningEnabled = YES;
        _rotationEnabled = YES;
        _pinchToZoomEnabled = YES;
        _tappingEnabled = YES;
        
        //Setup all the gesture recognizers
        [self setupGestureRecognizers];
        
        _cornerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cornerButton.layer.cornerRadius = _cornerButtonRadius;
        [self setBorders];
        _cornerButton.layer.masksToBounds = YES;
        _cornerButton.backgroundColor = _cornerButtonBackgroundColor;
        _cornerButton.frame = CGRectMake(0, 0, _cornerButtonRadius*2, _cornerButtonRadius*2);
        _cornerButton.center = CGPointZero;
        _cornerButton.hidden = _cornerButtonOriginallyHidden;
        [_cornerButton addTarget:self action:@selector(cornerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cornerButton];
        
        //finish up the view
        [self setNeedsDisplay];
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //allow the gestures to go outside the bounds of the view
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)setupGestureRecognizers {
    //setup the main recognizers that change the CGStretchView's location, scale, and rotation
    mainPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMainView:)];
    [self setDefaultGestureProperties:mainPan];
    mainPan.enabled = _panningEnabled;
    [self addGestureRecognizer:mainPan];
    
    mainRotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateMainView:)];
    mainRotation.delegate = self;
    mainRotation.enabled = _rotationEnabled;
    [self addGestureRecognizer:mainRotation];
    
    mainPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMainView:)];
    mainPinch.delegate = self;
    mainPinch.enabled = _pinchToZoomEnabled;
    [self addGestureRecognizer:mainPinch];
    
    mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTapped:)];
    mainTap.numberOfTapsRequired = 1;
    mainTap.delegate = self;
    mainTap.enabled = _tappingEnabled;
    [self addGestureRecognizer:mainTap];
    
}

- (void)setDefaultGestureProperties:(UIPanGestureRecognizer*)recognizer {
    recognizer.minimumNumberOfTouches = 1;
    recognizer.delaysTouchesBegan = NO;
    recognizer.delegate = self;
}

- (void)panMainView:(UIPanGestureRecognizer*)panGesture {
    CGPoint panLocation = [panGesture locationInView:self.superview];
    self.center = panLocation;
}

- (void)rotateMainView:(UIRotationGestureRecognizer*)rotationGesture {
    CGFloat rotation = [rotationGesture rotation];
    [rotationGesture.view setTransform:CGAffineTransformRotate(self.transform, rotation)];
    [rotationGesture setRotation:0];
}

- (void)zoomMainView:(UIPinchGestureRecognizer*)pinchGesture {
    CGFloat scale = [pinchGesture scale];
    [pinchGesture.view setTransform:CGAffineTransformScale(self.transform, scale, scale)];
    [pinchGesture setScale:1.0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)mainViewTapped:(UITapGestureRecognizer*)tap {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(stretchViewTapped:)])
            [_delegate stretchViewTapped:self];
    }
}

- (void)setPanningEnabled:(BOOL)panningEnabled {
    _panningEnabled = panningEnabled;
    mainPan.enabled = panningEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled {
    _rotationEnabled = rotationEnabled;
    mainRotation.enabled = rotationEnabled;
}

- (void)setPinchToZoomEnabled:(BOOL)pinchToZoomEnabled {
    _pinchToZoomEnabled = pinchToZoomEnabled;
    mainPinch.enabled = pinchToZoomEnabled;
}

- (void)setTappingEnabled:(BOOL)tappingEnabled {
    _tappingEnabled = tappingEnabled;
    mainTap.enabled = _tappingEnabled;
}

- (void)setCornerButtonHidden:(BOOL)cornerButtonHidden {
    _cornerButtonHidden = cornerButtonHidden;
    if (cornerButtonHidden == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            self.cornerButton.alpha = 0;
        } completion:^(BOOL finished) {
            self.cornerButton.hidden = YES;
        }];
    }
    else {
        self.cornerButton.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.cornerButton.alpha = 1;
        }];
    }
}

- (void)setCornerButtonImage:(UIImage *)cornerButtonImage {
    _cornerButtonImage = cornerButtonImage;
    [_cornerButton setBackgroundImage:cornerButtonImage forState:UIControlStateNormal];
    [self setNeedsDisplay];
}

- (void)setCornerButtonRadius:(CGFloat)cornerButtonRadius {
    _cornerButtonRadius = cornerButtonRadius;
    CGPoint cornerButtonCenter = _cornerButton.center;
    _cornerButton.frame = CGRectMake(0, 0, cornerButtonRadius*2, cornerButtonRadius*2);
    _cornerButton.center = cornerButtonCenter;
    _cornerButton.layer.cornerRadius = cornerButtonRadius;
    [self setNeedsDisplay];
}

- (void)setCornerButtonBackgroundColor:(UIColor *)cornerButtonBackgroundColor {
    _cornerButtonBackgroundColor = cornerButtonBackgroundColor;
    _cornerButton.backgroundColor = cornerButtonBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setCornerButtonBorderThickness:(CGFloat)cornerButtonBorderThickness {
    _cornerButtonBorderThickness = cornerButtonBorderThickness;
    [self setBorders];
}

- (void)setCornerButtonBorderColor:(UIColor *)cornerButtonBorderColor {
    _cornerButtonBorderColor = cornerButtonBorderColor;
    [self setBorders];
}

- (void)setCornerButtonBorderEqualsBorder:(BOOL)cornerButtonBorderEqualsBorder {
    _cornerButtonBorderEqualsBorder = cornerButtonBorderEqualsBorder;
    [self setBorders];
}

- (void)setCornerButtonOriginallyHidden:(BOOL)cornerButtonOriginallyHidden {
    _cornerButtonOriginallyHidden = cornerButtonOriginallyHidden;
    _cornerButton.hidden = _cornerButtonOriginallyHidden;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setBorders];
}

- (void)setBorderThickness:(CGFloat)borderThickness {
    _borderThickness = borderThickness;
    [self setBorders];
}

- (void)setBorders {
    borderView.layer.borderWidth = _borderThickness;
    borderView.layer.borderColor = _borderColor.CGColor;
    if (_cornerButtonBorderEqualsBorder) {
        _cornerButton.layer.borderWidth = _borderThickness;
        _cornerButton.layer.borderColor = _borderColor.CGColor;
    }
    else {
        _cornerButton.layer.borderWidth = _cornerButtonBorderThickness;
        _cornerButton.layer.borderColor = _cornerButtonBorderColor.CGColor;
    }
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    [self setNeedsDisplay];
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    [self setNeedsDisplay];
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    _labelTextColor = labelTextColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_image) {
        [_image drawInRect:rect];
    }
    if (_labelText) {
        NSDictionary *textAttributes = @{NSFontAttributeName: _labelFont,
                                         NSForegroundColorAttributeName: _labelTextColor
                                         };
        NSDictionary *sizeAttributes = @{NSFontAttributeName: _labelFont};
        CGRect textRect = [_labelText boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:sizeAttributes
                                                   context:nil];
        [_labelText drawInRect:CGRectMake((rect.size.width-textRect.size.width)/2, (rect.size.height-textRect.size.height)/2, textRect.size.width, textRect.size.height) withAttributes:textAttributes];
    }
}

- (void)cornerButtonPressed:(UIButton*)cornerButton {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(cornerButtonPressed:withStretchView:)])
            [_delegate cornerButtonPressed:cornerButton withStretchView:self];
    }
}

@end
