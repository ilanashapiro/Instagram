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
    if ([post.author objectForKey:@"profileImage"]) {
        [post.author[@"profileImage"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                image = [self resizeImage:image withSize:CGSizeMake(20, 20)];
                [self.nameButton setImage:image forState:UIControlStateNormal];
                self.nameButton.imageView.layer.cornerRadius = self.nameButton.imageView.frame.size.width / 2;
                self.nameButton.imageView.clipsToBounds = YES;
            }
            else {
                NSLog(@"error");
            }
        }];
    }
    else {
        UIImage *defaultImage = [self resizeImage:[UIImage imageNamed:@"emptyprofile"] withSize:CGSizeMake(20, 20)];
        [self.nameButton setImage:defaultImage forState:UIControlStateNormal];
    }
    
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
        [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *Post, NSError *error) {
            if (!error) {
                 self.post[@"liked"] = @YES;
                 int likeCountInt = [self.post.likeCount intValue];
                 NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt + 1];
                 [self.likeButton setSelected:YES];
                 self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", likeCountNumber];
                 self.post[@"likeCount"] = likeCountNumber;
                 [self.post saveInBackground];
            }
            else {
                NSLog(@"error");
            }
         }];
    }
    else {
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *Post, NSError *error) {
            if (!error) {
                 self.post[@"liked"] = @NO;
                 int likeCountInt = [self.post.likeCount intValue];
                 NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt - 1];
                 [self.likeButton setSelected:NO];
                 self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", likeCountNumber];
                 self.post[@"likeCount"] = likeCountNumber;
                 [self.post saveInBackground];
            }
            else {
                NSLog(@"error");
            }
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
