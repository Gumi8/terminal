//
//  LoginEmailViewController.m
//  Terminal
//
//  Created by 123 on 15/07/13.
//  Copyright (c) 2013 Terminal. All rights reserved.
//

#import "LoginEmailViewController.h"

@interface LoginEmailViewController ()

@end

@implementation LoginEmailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)loginButtonPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"goToDescription" sender:nil];    // Do stuff after successful login.
        } else {
            NSLog(@"Failed to login");  // The login failed. Check error to see why.
        }
    }];
    
}

@end
