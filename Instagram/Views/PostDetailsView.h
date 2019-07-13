//
//  PostDetailsView.h
//  
//
//  Created by ilanashapiro on 7/9/19.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostDetailsViewDelegate <NSObject>

- (void)notifyLikeUpdates;

@end

@interface PostDetailsView : UIView

@property (weak, nonatomic) IBOutlet PFImageView *postPFImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLikesLabel;

@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) id<PostDetailsViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
