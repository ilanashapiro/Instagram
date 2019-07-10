//
//  PostDetailsView.m
//  
//
//  Created by ilanashapiro on 7/9/19.
//

#import "PostDetailsView.h"
#import "Post.h"

@interface PostDetailsView ()

@end

@implementation PostDetailsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setPost:(Post *)post {
    _post = post;
    NSLog(@"Post posted!!!!");
    self.postPFImageView.file = post[@"image"];
    NSLog(@"%@", post[@"image"]);
    [self.postPFImageView loadInBackground];
    //NSLog(@"%@", self.postPFImageView.file);
    self.nameLabel.text = post.author.username;
    //NSLog(@"%@ %@", post.author.username, self.nameLabel);
    self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    self.captionLabel.text = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
}

@end
