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

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendmeButtonPressed:(id)sender {
    [PFUser requestPasswordResetForEmailInBackground:@"email@example.com"];
    
}


@end
