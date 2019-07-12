//
//  PostCell.m
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "PostCell.h"
#import "NSDate+DateTools.h"
@import Parse;

@interface PostCell()

- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapProfile:(id)sender;



@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.postPFImageView.file = post[@"image"];
    [self.postPFImageView loadInBackground];
    
    [self.nameButton setTitle:post.author.username  forState:UIControlStateNormal];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [post.datePosted shortTimeAgoSinceNow]];

    if ([post.likeCount intValue] == 1) {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
    }
    else {
        self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", post.likeCount];
    }
    
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
    self.captionLabel.text = [NSString stringWithFormat:@"@%@ %@", post.author.username, post.caption];
    if ([post.liked intValue] == 0) {
        [self.likeButton setSelected:NO];
    }
    else {
        [self.likeButton setSelected:YES];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSLog(@"Tapped like!");
    if ([self.post.liked intValue] == 0) {
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:self.post.objectId block:^(PFObject *Post, NSError *error) {
            if (!error) {
                 self.post[@"liked"] = @YES;
                 int likeCountInt = [self.post.likeCount intValue];
                 NSNumber *likeCountNumber = [NSNumber numberWithInt:likeCountInt + 1];
                 self.post[@"likeCount"] = likeCountNumber;
                
                 [self.likeButton setSelected:YES];
                 if ([self.post.likeCount intValue] == 1) {
                     self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
                 }
                 else {
                     self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", self.post.likeCount];
                 }
                
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
                 self.post[@"likeCount"] = likeCountNumber;
                
                 if ([self.post.likeCount intValue] == 1) {
                     self.numberLikesLabel.text = [NSString stringWithFormat:@"1 like"];
                 }
                 else {
                     self.numberLikesLabel.text = [NSString stringWithFormat:@"%@ likes", self.post.likeCount];
                 }
                
                 [self.post saveInBackground];
            }
            else {
                NSLog(@"Error");
            }
         }];
    }
}

- (IBAction)didTapProfile:(id)sender {
    [self.delegate performSegueToProfile:self];
}

@end
