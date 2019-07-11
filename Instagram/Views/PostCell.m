//
//  PostCell.m
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "PostCell.h"
#import "NSDate+DateTools.h"

@interface PostCell()

- (IBAction)didTapLike:(id)sender;

@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPost:(Post *)post {
    _post = post;
    
    //NSLog(@"%@", self.postPFImageView.file);
    self.postPFImageView.file = post[@"image"];
    [self.postPFImageView loadInBackground];
    //NSLog(@"%@", post.author.username);
    
    self.nameLabel.text = post.author.username;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [post.datePosted shortTimeAgoSinceNow]];
    //NSLog(@"%@", self.nameLabel.text, post.author.username);
    if ([post.likeCount intValue] == 1) {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
    }
    else {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    }
    self.captionLabel.text = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
    if ([post.liked intValue] == 0) {
        [self.likeButton setSelected:NO];
    }
    else {
        [self.likeButton setSelected:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    //Update the local model (tweet) properties to reflect it’s been favorited by updating the favorited bool and incrementing the favoriteCount.
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSLog(@"Tapped like!");
    if ([self.post.liked intValue] == 0) {
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.post.objectId
                                     block:^(PFObject *Post, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                                         self.post[@"liked"] = @YES;
                                         int likeCountInt = [self.post.likeCount intValue];
                                         NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt + 1];
                                         [self.likeButton setSelected:YES];
                                         self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", likeCountNumber];
                                         self.post[@"likeCount"] = likeCountNumber;
                                         [self.post saveInBackground];
                                     }];
    }
    else {
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.post.objectId
                                     block:^(PFObject *Post, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                                         self.post[@"liked"] = @NO;
                                         int likeCountInt = [self.post.likeCount intValue];
                                         NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt - 1];
                                         [self.likeButton setSelected:NO];
                                         self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", likeCountNumber];
                                         self.post[@"likeCount"] = likeCountNumber;
                                         [self.post saveInBackground];
                                     }];
    }
}

@end
