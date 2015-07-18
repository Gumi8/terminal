//
//  Postcard.h
//  Terminal
//
//  Created by 123 on 06/07/15.
//  Copyright (c) 2015 Terminal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Postcard : PFObject<PFSubclassing>

@property (nonatomic) NSString *placename;
@property (nonatomic) PFFile *image;
@property (nonatomic) NSString *text;

- (instancetype)initWithPlacename:(NSString *)placename
                            image:(PFFile *)image
                             text:(NSString *)text;

@end
