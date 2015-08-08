//
//  LoginEmailViewController.m
//  Terminal
//
//  Created by 123 on 15/07/13.
//  Copyright (c) 2013 Terminal. All rights reserved.
//

#import "LoginEmailViewController.h"
#import <Analytics.h>

@interface LoginEmailViewController ()

@end

@implementation LoginEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:21 ] };
}

- (IBAction)loginButtonPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user && !error) {
            [[SEGAnalytics sharedAnalytics] identify:user.objectId traits:@{ @"email": user.email }];
            [self performSegueWithIdentifier:@"goToDescription" sender:nil];
        } else {
            NSLog(@"Failed to login");  // The login failed. Check error to see why.
        }
    }];
    
}

@end
