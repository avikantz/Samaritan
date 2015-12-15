//
//  ListingTableViewCell.m
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ListingTableViewCell.h"

@implementation ListingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTintColor:(UIColor *)tintColor {
	self.nameLabel.textColor = tintColor;
	self.metascoreLabel.textColor = tintColor;
	self.imdbRatingLabel.textColor = tintColor;
	self.genreLabel.textColor = tintColor;
	self.castLabel.textColor = tintColor;
	self.descriptionTextView.textColor = tintColor;
}

@end
