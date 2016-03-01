//
//  PhoneModel.m
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import "PhoneModel.h"

@implementation PhoneModel

- (id)initWithImage:(NSData *)image firstName:(NSString *)firstName lastName:(NSString *)lastName phones:(NSArray *)phones person:(ABRecordRef)person
{
    self = [super init];
    if (self) {
        self.image = image;
        self.firstName = firstName;
        self.lastName = lastName;
        self.phones = phones;
        self.person = person;
    }
    return self;
}

@end
