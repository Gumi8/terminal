//
//  SignupViewController.m
//  Terminal
//
//  Created by 123 on 15/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)signupButtonPressed:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        [self enterDescriptionPage];
            NSLog(@"Registered");
        } else {
            NSLog(@"Some error in sign up");
        }
    }];
    
}

/*- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
        [self enterDescriptionPage];
        self.navigationController.navigationBar.backItem.title = @"Back";
    }
}  */

-(void) enterDescriptionPage {
    [self performSegueWithIdentifier:@"goToDescription" sender:nil];
}






@end
