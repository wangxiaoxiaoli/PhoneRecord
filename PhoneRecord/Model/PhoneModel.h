//
//  PhoneModel.h
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface PhoneModel : NSObject

@property (nonatomic,strong) NSData *image;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSArray *phones;
@property (nonatomic,assign) ABRecordRef person;

- (id)initWithImage:(NSData *)image firstName:(NSString *)firstName lastName:(NSString *)lastName phones:(NSArray *)phones person:(ABRecordRef)person;

@end
