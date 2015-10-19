//
//  CGStretchImageView.h
//  CGStretch
//
//  Created by Chris Galzerano on 6/25/14.
//  Copyright (c) 2014 chrisgalz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGStretchView;

@protocol CGStretchViewDelegate <NSObject>
- (void)cornerButtonPressed:(UIButton*)cornerButton withStretchView:(CGStretchView*)stretchView;
- (void)stretchViewTapped:(CGStretchView*)stretchView;
@end

@interface CGStretchView : UIView <UIGestureRecognizerDelegate>

//Settings for the stretch view
@property (nonatomic) BOOL panningEnabled;
@property (nonatomic) BOOL rotationEnabled;
@property (nonatomic) BOOL pinchToZoomEnabled;
@property (nonatomic) BOOL tappingEnabled;
@property (nonatomic) BOOL cornerButtonHidden;
@property (nonatomic) BOOL cornerButtonOriginallyHidden;

//This is enabled by default. Disable it to manually set the borders of the corner button
@property (nonatomic) BOOL cornerButtonBorderEqualsBorder;

//Border settings
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderThickness;

//The corner button (e.g. delete, close, or something)
@property (nonatomic, strong) UIButton *cornerButton;

//Style properties for the corner button
@property (nonatomic, strong) UIImage *cornerButtonImage;
@property (nonatomic) CGFloat cornerButtonRadius;
@property (nonatomic, strong) UIColor *cornerButtonBackgroundColor;
@property (nonatomic, strong) UIColor *cornerButtonBorderColor;
@property (nonatomic) CGFloat cornerButtonBorderThickness;

//Be a replacement for UIImageViews
@property (nonatomic, strong) UIImage *image;

//Be a replacement for UILabel
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *labelTextColor;

//delegate for button presses
@property (nonatomic, assign) id<CGStretchViewDelegate> delegate;


@end
