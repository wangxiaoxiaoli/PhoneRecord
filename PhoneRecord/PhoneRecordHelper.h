//
//  PhoneRecordHelper.h
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


typedef void(^RefreshBlock)(void);

@interface PhoneRecordHelper : NSObject
{
    ABAddressBookRef _addressBook;
    NSArray *_myContacts;
}

@property (nonatomic,strong) RefreshBlock refreshBlock;

+ (PhoneRecordHelper *)defaultPhoneRecordHelper;

- (BOOL)checkAddressBookAuthorizationStatus:(void(^)(NSError *error))errorBlock;


- (NSArray *)getConstacts;

- (void)deletePerson:(ABRecordRef)person withBlock:(void(^)(BOOL isSuccess))block;

@end
