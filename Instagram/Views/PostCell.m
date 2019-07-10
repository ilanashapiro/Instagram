//
//  PostCell.m
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "PostCell.h"

@interface PostCell()

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
    //NSLog(@"%@", self.nameLabel.text, post.author.username);
    self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    self.captionLabel.text = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
