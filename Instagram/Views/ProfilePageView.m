//
//  ProfilePageView.m
//  Instagram
//
//  Created by ilanashapiro on 7/11/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "ProfilePageView.h"
@import Parse;

@implementation ProfilePageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPost:(Post *)post {
    _post = post;
    
    self.profilePFImageView.file = post[@"image"];
    [self.profilePFImageView loadInBackground];
    
    //[self.nameButton setTitle:post.author.username forState:UIControlStateNormal];
}

@end
