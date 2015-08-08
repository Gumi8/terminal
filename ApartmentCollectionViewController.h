//
//  ApartmentCollectionViewController.h
//  Terminal
//
//  Created by 123 on 17/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostcardViewController.h"
#import "Postcard.h"
#import "Apartment.h"

@interface ApartmentCollectionViewController : UICollectionViewController

@property (nonatomic) Postcard *postcard;

@end
