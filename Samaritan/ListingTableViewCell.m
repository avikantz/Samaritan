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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.nameLabel.alpha = 0.f;
		self.metascoreLabel.alpha = 0.f;
		self.imdbRatingLabel.alpha = 0.f;
		self.genreLabel.alpha = 0.f;
		self.castLabel.alpha = 0.f;
		self.descriptionLabel.alpha = 0.f;
		self.runtimeAndRatingLabel.alpha = 0.f;
		self.directorLabel.alpha = 0.f;
		self.writersLabel.alpha = 0.f;
		self.yrOfReleaseLabel.alpha = 0.f;
		self.awardsListLabel.alpha = 0.f;
		self.listingImageBlurred.alpha = 0.f;
	} completion:nil];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.nameLabel.alpha = 1.f;
		self.metascoreLabel.alpha = 1.f;
		self.imdbRatingLabel.alpha = 1.f;
		self.genreLabel.alpha = 1.f;
		self.castLabel.alpha = 1.f;
		self.descriptionLabel.alpha = 1.f;
		self.runtimeAndRatingLabel.alpha = 1.f;
		self.directorLabel.alpha = 1.f;
		self.writersLabel.alpha = 1.f;
		self.yrOfReleaseLabel.alpha = 1.f;
		self.awardsListLabel.alpha = 1.f;
		self.listingImageBlurred.alpha = 1.f;
	} completion:nil];
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
	self.descriptionLabel.textColor = tintColor;
    self.runtimeAndRatingLabel.textColor = tintColor;
    self.directorLabel.textColor = tintColor;
    self.writersLabel.textColor = tintColor;
    self.yrOfReleaseLabel.textColor = tintColor;
    self.awardsListLabel.textColor = tintColor;
}

@end
