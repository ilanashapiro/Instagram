//
//  PostDetailsView.m
//  
//
//  Created by ilanashapiro on 7/9/19.
//

#import "PostDetailsView.h"
#import "Post.h"
#import "NSDate+DateTools.h"

@interface PostDetailsView ()

- (IBAction)didTapLike:(id)sender;

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
    
    self.postPFImageView.file = post[@"image"];
    [self.postPFImageView loadInBackground];
    
    [self.nameButton setTitle:post.author.username forState:UIControlStateNormal];
    [[PFUser currentUser][@"profileImage"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            image = [self resizeImage:image withSize:CGSizeMake(20, 20)];
            [self.nameButton setImage:image forState:UIControlStateNormal];
            self.nameButton.imageView.layer.cornerRadius = self.nameButton.imageView.frame.size.width / 2;
            self.nameButton.imageView.clipsToBounds = YES;
            [self.nameButton setTitle:post.author.username forState:UIControlStateNormal];
        }
        else {
            NSLog(@"error");
        }
    }];
    
    if ([post.likeCount intValue] == 1) {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
    }
    else {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    }
    self.captionLabel.text = [NSString stringWithFormat:@"%@ %@", post.author.username, post.caption];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [post.datePosted shortTimeAgoSinceNow]];
    
    if ([post.liked intValue] == 0) {
        [self.likeButton setSelected:NO];
    }
    else {
        [self.likeButton setSelected:YES];
    }
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

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
