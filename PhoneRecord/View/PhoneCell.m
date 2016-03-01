//
//  PhoneCell.m
//  PhoneRecord
//
//  Created by qk365 on 16/2/29.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import "PhoneCell.h"
#import "PhoneModel.h"

@implementation PhoneCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillData:(id)item
{
    PhoneModel *model = (PhoneModel *)item;
    
    if (model.image) {
        _iconImageView.image = [UIImage imageWithData:model.image];
    } else {
        _iconImageView.image = [UIImage imageNamed:@"portrait_image"];
    }
    
    _name.text = model.lastName;
    _phone.text = [model.phones firstObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
