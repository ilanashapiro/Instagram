//
//  User.m
//  
//
//  Created by ilanashapiro on 7/11/19.
//

/*#import "User.h"

@implementation User

@dynamic userID;
@dynamic user;
@dynamic biography;
@dynamic profileImage;

+ (nonnull NSString *)parseClassName {
    return @"User";
}

+ (void) changeProfileImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    User *newPost = [User new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.liked = @NO;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.datePosted = [NSDate date];
    
    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
*/
