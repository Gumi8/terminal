//
//  ViewController.m
//  Terminal
//
//  Created by 123 on 06/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>



@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.signUpButton.layer.borderWidth = 1;
    self.signUpButton.clipsToBounds = YES;
    self.signUpButton.layer.cornerRadius = 5;
    [self.navigationController setNavigationBarHidden:YES];
    NSLog(@"%@", [PFUser currentUser]);
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"enterApp" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginFBButtonPressed:(id)sender {
   [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self enterApp];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self enterApp];
        }
   }];
}


-(void) enterApp {
    [self performSegueWithIdentifier:@"enterApp" sender:self];
}

- (void)logOut  {
    [PFUser logOut]; // Log out
}



@end
