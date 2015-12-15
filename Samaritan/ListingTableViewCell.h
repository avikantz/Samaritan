//
//  ListingTableViewCell.h
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *listingImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *metascoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *imdbRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) IBOutlet UILabel *castLabel;
@property (strong, nonatomic) IBOutlet UILabel *directorLabel;
@property (strong, nonatomic) IBOutlet UILabel *runtimeAndRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *writersLabel;
@property (strong, nonatomic) IBOutlet UILabel *yrOfReleaseLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *awardsListTextView;

@end