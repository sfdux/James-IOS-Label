//
//  ViewController.m
//  JamesLabel
//
//  Created by sfdux on 10/19/15.
//  Copyright © 2015 james. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    UIView *backgroundView;
    CGStretchView *stretchImageView;
    CGStretchView *stretchImageViewDeal;
    CGStretchView *stretchImageViewOperation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    date = [formatter stringFromDate:[NSDate date]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, 320, 320)];
    imageView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:imageView];
    
    //There are a bunch of different properties that can be set on this.
    stretchImageView = [[CGStretchView alloc] initWithFrame:CGRectMake(30, 120, self.view.frame.size.width/4, self.view.frame.size.height/15)];
    stretchImageView.labelText = [NSString stringWithFormat:@"交易完成 %@",date];
    stretchImageView.borderColor = [UIColor blackColor];
    //    stretchImageView.transform = CGAffineTransformRotate(stretchImageView.transform, M_SQRT1_2);
    stretchImageView.transform = CGAffineTransformMakeRotation(M_PI* -0.2);
    stretchImageView.borderThickness = 0.5f;
    stretchImageView.cornerButtonRadius = 30.0f;
    stretchImageView.alpha = 0.5f;
    stretchImageView.delegate = self;
    stretchImageView.cornerButtonOriginallyHidden = YES;
    [stretchImageView setPanningEnabled:NO];
    [stretchImageView setRotationEnabled:NO];
    [stretchImageView setPinchToZoomEnabled:NO];
    [stretchImageView setTappingEnabled:NO];
    
    [imageView addSubview:stretchImageView];
    
    stretchImageViewDeal = [[CGStretchView alloc] initWithFrame:CGRectMake(30, 180, self.view.frame.size.width/4, self.view.frame.size.height/15)];
    stretchImageViewDeal.labelText = @"已抢";
    stretchImageViewDeal.labelTextColor = [UIColor blueColor];
    stretchImageViewDeal.borderColor = [UIColor blueColor];
    stretchImageViewDeal.transform = CGAffineTransformMakeRotation(M_PI* -0.2);
    stretchImageViewDeal.borderThickness = 0.5f;
    stretchImageViewDeal.cornerButtonRadius = 30.0f;
    stretchImageViewDeal.delegate = self;
    stretchImageViewDeal.cornerButtonOriginallyHidden = YES;
    [stretchImageViewDeal setPanningEnabled:NO];
    [stretchImageViewDeal setRotationEnabled:NO];
    [stretchImageViewDeal setPinchToZoomEnabled:NO];
    [stretchImageViewDeal setTappingEnabled:NO];
    
    [imageView addSubview:stretchImageViewDeal];
    
    stretchImageViewOperation = [[CGStretchView alloc] initWithFrame:CGRectMake(150, 200, self.view.frame.size.width/4, self.view.frame.size.height/15)];
    
    stretchImageViewOperation.labelText = @"等待交易";
    stretchImageViewOperation.transform = CGAffineTransformMakeRotation(M_PI* 0.2);
    stretchImageViewOperation.borderColor = [UIColor redColor];
    stretchImageViewOperation.labelTextColor = [UIColor redColor];
    stretchImageViewOperation.borderThickness = 0.5f;
    stretchImageViewOperation.cornerButtonRadius = 30.0f;
    stretchImageViewOperation.alpha = 0.5f;
    stretchImageViewOperation.delegate = self;
    stretchImageViewOperation.cornerButtonOriginallyHidden = YES;
    [stretchImageViewOperation setPanningEnabled:NO];
    [stretchImageViewOperation setRotationEnabled:NO];
    [stretchImageViewOperation setPinchToZoomEnabled:NO];
    [stretchImageViewOperation setTappingEnabled:NO];
    
    [imageView addSubview:stretchImageViewOperation];
    
    
    //    UITapGestureRecognizer *fullViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideButton)];
    //    fullViewTap.delegate = self;
    //    [backgroundView addGestureRecognizer:fullViewTap];
    stretchImageView.cornerButtonHidden = YES;
    stretchImageViewDeal.cornerButtonHidden = YES;
}

- (void)hideButton {
    stretchImageView.cornerButtonHidden = YES;
}

- (void)stretchViewTapped:(CGStretchView *)stretchView {
    stretchImageView.cornerButtonHidden = NO;
}

- (void)cornerButtonPressed:(UIButton *)cornerButton withStretchView:(CGStretchView *)stretchView {
    CGPoint location = CGPointMake(arc4random()%(int)self.view.frame.size.width, arc4random()%(int)self.view.frame.size.height);
    UILabel *wow = [[UILabel alloc] initWithFrame:CGRectMake(location.x, location.y, 100, 20)];
    wow.font = [UIFont systemFontOfSize:18];
    wow.text = @"wow";
    [backgroundView addSubview:wow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
