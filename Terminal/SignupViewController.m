//
//  SignupViewController.m
//  Terminal
//
//  Created by 123 on 15/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import <Analytics.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:21] };
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)signupButtonPressed:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        [self enterDescriptionPage];
            NSLog(@"Registered");
            PFUser *user = [PFUser currentUser];
            [[SEGAnalytics sharedAnalytics] identify:user.objectId traits:@{ @"firstName": user[@"firstName"], @"lastName": user[@"lastName"], @"email": user.email }];
        } else {
            NSLog(@"Some error in sign up");
        }
    }];
    
}



-(void) enterDescriptionPage {
    [self performSegueWithIdentifier:@"goToDescription" sender:nil];
}






@end
