//
//  DescriptionViewController.m
//  Terminal
//
//  Created by 123 on 10/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)bookmarkPressed:(id)sender {
    [self performSegueWithIdentifier:@"goToSavedCards" sender:nil];

}

@end
