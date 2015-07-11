//
//  ViewController.m
//  WideAngle
//
//  Created by Qing Wang on 5/31/15.
//  Copyright (c) 2015 Qing Wang. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (nonatomic, strong) CMMotionManager * motionManager;
@end

@implementation ViewController

// ************************* Initialization ********************************************
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setPosition];
    
    [self setBackground];
    
    [self drawGrid];
    
    [self displayAlert];
    
    [self liveCamera];
     //----- SHOW LIVE CAMERA PREVIEW -----
    
}

//**************************************** Init Helper ************************************************

- (void) setBackground{
    UIImage *image = [UIImage imageNamed: @"a.jpg"];
    self.Back.contentMode = UIViewContentModeScaleAspectFill;
    self.Back.clipsToBounds = YES;
    [self.Back setImage:image];
}

-(void) liveCamera{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.imageView.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    //captureVideoPreviewLayer.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.frame = self.imageView.bounds;
    
    
    [self.imageView.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    [session startRunning];
}

- (void) displayAlert{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
}

- (void) drawGrid{
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    CGFloat sw = CGRectGetWidth(screen);
    float xb = self.Back.frame.origin.x;
    float yb = self.Grid.frame.origin.y;
    float xc= self.imageView.frame.origin.x;
    float yc = self.imageView.frame.origin.y;
    
    self.takePhoto.center = CGPointMake(xc+self.imageView.frame.size.width/2, yc+self.imageView.frame.size.height+10);

    UIView * l1  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sw - xb*2, 1)];
    l1.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l1];
    
    UIView * l2  = [[UIView alloc] initWithFrame:CGRectMake(0, yc - yb, sw - 2*xb, 1)];
    l2.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l2];
    
    UIView * l3  = [[UIView alloc] initWithFrame:CGRectMake(0, 4*(sw - 2*xb)/3 - yc + yb, sw - 2*xb, 1)];
    l3.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l3];
    
    UIView * l4  = [[UIView alloc] initWithFrame:CGRectMake(0, 4*(sw - 2*xb)/3, sw - 2*xb, 1)];
    l4.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l4];
    
    UIView * l5  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 4*(sw - 2*xb)/3)];
    l5.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l5];
    
    UIView * l6  = [[UIView alloc] initWithFrame:CGRectMake(xc - xb, 0, 1, 4*(sw - 2*xb)/3)];
    l6.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l6];
    
    UIView * l7  = [[UIView alloc] initWithFrame:CGRectMake(sw - xc - xb, 0, 1, 4*(sw - 2*xb)/3)];
    l7.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l7];
    
    UIView * l8  = [[UIView alloc] initWithFrame:CGRectMake(sw - 2*xb, 0, 1, 4*(sw - 2*xb)/3)];
    l8.backgroundColor = [UIColor redColor];
    [self.Grid addSubview:l8];

}
// Set positions of Back, imageView and Grid
// imageView.width/Back.width = 2/3
// width/height = 3/4 for all
// origin of Back at (0, status bar height)

- (void) setPosition {
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    CGFloat sw = CGRectGetWidth(screen);
    CGFloat status_bar_height = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat x = 0;
    CGFloat y = status_bar_height;
    [self.Back setFrame:CGRectMake(x, y, sw, sw*4/3)];
    [self.Grid setFrame:CGRectMake(x, y, sw, sw*4/3)];
    [self.imageView setFrame:CGRectMake(sw/6, sw*4/3/6 + y, sw*2/3, sw*4/3*2/3)];
}

// ************************* Actions ******************************************************
- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

// ************************* Core Motion ******************************************************

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startCoreMotion];
    
}

-(void) startCoreMotion{
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1/6000;
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
}

- (void) updateCamera:(float)roll :(float)pitch :(float)yaw :(float)accX :(float)accY :(float)accZ{
    [self.imageView setFrame:CGRectMake(self.Back.frame.size.width/6 - 200*roll, self.Back.frame.size.height/6 - 200*pitch - 70, self.imageView.frame.size.width, self.imageView.frame.size.height)];
}

- (void) update{
    CMDeviceMotion *deviceMotion = self.motionManager.deviceMotion;
    if (deviceMotion == NULL){
        return;
    }
    CMAttitude *att = deviceMotion.attitude;
    float roll = att.roll;
    float pitch = att.pitch - 1.57;
    float yaw = att.yaw;
    
    CMAcceleration Acc = deviceMotion.userAcceleration;
    float accX = Acc.x;
    float accY = Acc.y;
    float accZ = Acc.z;
    
    [self updateCamera:roll :pitch :yaw :accX :accY :accZ];
}

// ************************* Image Picker Controller delegate **********************************

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
