//
//  Postcard.m
//  Terminal
//
//  Created by 123 on 06/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import "Postcard.h"
#import <Parse/Parse.h>

@implementation Postcard

@dynamic placename;
@dynamic image;
@dynamic text;

- (instancetype)initWithPlacename:(NSString *)placename
                            image:(PFFile *)image
                             text:(NSString *)text {
    self = [super init];
    if (!self) return nil;
    
    self.placename = placename;
    self.image = image;
    self.text = text;
    return self;
}

#pragma mark PFSubclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Postcard";
}

@end
