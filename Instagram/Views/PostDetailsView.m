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
    
    if ([post.arrayOfUsersWhoLiked containsObject:post.author.objectId]) {
        [self.likeButton setSelected:YES];
    }
    else {
        [self.likeButton setSelected:NO];
    }
}

- (IBAction)didTapLike:(id)sender {
    NSLog(@"Tapped like!");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *postPFObject, NSError *error) {
        Post *post = (Post *)postPFObject;
        PFUser *user = post.author;
        
        NSLog(@"%@ %@ %d", post.arrayOfUsersWhoLiked, user.objectId, [post.arrayOfUsersWhoLiked containsObject:user.objectId]);
        if (![post.arrayOfUsersWhoLiked containsObject:user.objectId]) {
            [self setLiked:YES forPost:post user:user];
        }
        else {
            [self setLiked:NO forPost:post user:user];
        }
        [self.delegate notifyLikeUpdates];
        
    }];
}

- (void)setLiked:(BOOL)liked forPost:(Post *)post user:(PFUser *)user {
    int likeCountInt = [post.likeCount intValue];
    NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt];
    
    if (liked) {
        [post.arrayOfUsersWhoLiked addObject:user.objectId];
        likeCountNumber = [NSNumber numberWithInt:likeCountInt + 1];
    }
    else {
        [post.arrayOfUsersWhoLiked removeObject:user.objectId];
        likeCountNumber = [NSNumber numberWithInt:likeCountInt - 1];
    }
    
    [post setObject:post.arrayOfUsersWhoLiked forKey:@"arrayOfUsersWhoLiked"];
    [post setObject:likeCountNumber forKey:@"likeCount"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"Post add to list of users who liked update failed: %@", error.localizedDescription);
        }
        else {
            NSLog(@"like count %d", [post.likeCount intValue]);
            if ([post.likeCount intValue] == 1) {
                self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
            }
            else {
                self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
            }
            [self.likeButton setSelected:liked];
            NSLog(@"Post successfully updated!");
        }
    }];
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
