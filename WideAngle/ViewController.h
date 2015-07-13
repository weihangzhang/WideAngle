//
//  ViewController.h
//  WideAngle
//
//  Created by Qing Wang on 5/31/15.
//  Copyright (c) 2015 Qing Wang. All rights reserved.
//  Xixixixixi

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
@import CoreGraphics;
@import AVFoundation;


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *Back;
@property (weak, nonatomic) IBOutlet UIImageView *Grid;
@property(nonatomic, retain) AVCaptureStillImageOutput * stillImageOutput;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *selectPhoto;

- (IBAction)takePhoto:(UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end

