//
//  CEVItemCell.h
//  HomeOwner
//
//  Created by Vikram Aggarwal on 8/4/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CEVItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
