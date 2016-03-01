//
//  PhoneRecordHelper.m
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import "PhoneRecordHelper.h"
#import "PhoneModel.h"

@implementation PhoneRecordHelper

+ (PhoneRecordHelper *)defaultPhoneRecordHelper
{
    static PhoneRecordHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[PhoneRecordHelper alloc] init];
    });
    return helper;
}

//1.先授权，如果没有授权提示到设置里打开授权，如果已成功，读取通讯录数据到数组里
- (instancetype)init
{
    self = [super init];
    if (self) {
        _addressBook = ABAddressBookCreate();
        //注册通讯录更新回调
        ABAddressBookRegisterExternalChangeCallback(_addressBook, addressBookChanged, (__bridge void*)(self));
    }
    return self;
}

- (BOOL)checkAddressBookAuthorizationStatus:(void(^)(NSError *error))errorBlock
{
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (errorBlock) {
                        errorBlock((__bridge NSError*)error);
                    }
                }
                else if (!granted) {
                    //未认证
                    NSDictionary *userInfo = @{@"ABAuthorizedError":@"ABAuthorizedError"};
                    NSError *error = [NSError errorWithDomain:@"test" code:kABAuthorizationStatusNotDetermined userInfo:userInfo];
                    errorBlock(error);
                }
                else {
                    errorBlock(nil);
                }
            });
        });
    } else {
        errorBlock(nil);
    }
    
    return authStatus == kABAuthorizationStatusAuthorized;
}
void addressBookChanged(ABAddressBookRef addressBook,CFDictionaryRef info,void* context)
{
    PhoneRecordHelper *helper = objc_unretainedObject(context);
    [helper refreshAddressBook];
}

- (void)refreshAddressBook
{
    if (_refreshBlock) {
        _refreshBlock();
    }
}

- (void)doGetConstacts {
    //还原 ABAddressBookRef
    ABAddressBookRevert(_addressBook);
    _myContacts = [NSArray arrayWithArray:(__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(_addressBook)];
}

- (NSArray *)getConstacts
{
    [self doGetConstacts];
    if (_myContacts) {
        NSMutableArray *constactsArr = [NSMutableArray array];
        
        //获取所有联系人数组
        CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        //获取联系人总数
        CFIndex number = ABAddressBookGetPersonCount(_addressBook);
        //进行遍历
        for (NSInteger i = 0; i < number; i++) {
            //获取联系人对象的引用
            ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            //获取当前联系人姓氏
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            //获取当前联系人的电话 数组
            NSMutableArray *phoneArr = [[NSMutableArray alloc] init];
            ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
                [phoneArr addObject:(__bridge NSString*)(ABMultiValueCopyValueAtIndex(phones, j))];
            }
            
            //获取当前联系人头像图片
            NSData *userImage = (__bridge NSData*)(ABPersonCopyImageData(people));
            
            PhoneModel *model = [[PhoneModel alloc] initWithImage:userImage firstName:firstName lastName:lastName phones:phoneArr person:(__bridge ABRecordRef)(_myContacts[i])];
            [constactsArr addObject:model];
        }
        return constactsArr;
    }
    return nil;
}

- (void)deletePerson:(ABRecordRef)person withBlock:(void (^)(BOOL))block
{
    CFErrorRef *error;
    ABAddressBookRemoveRecord(_addressBook, person, error);
    ABAddressBookSave(_addressBook, error);
    if (!error) {
        block(YES);
    } else {
        block(NO);
    }
}






















@end
