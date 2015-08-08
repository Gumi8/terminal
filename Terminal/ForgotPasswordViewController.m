//
//  ForgotPasswordViewController.m
//  Terminal
//
//  Created by 123 on 15/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <Parse/Parse.h>

@interface ForgotPasswordViewController ()


@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (IBAction)sendmeButtonPressed:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:self.emailAddress.text];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We sent you link to reset your password" message:@"Check your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
    [alertView show];

}


@end
