//
//  ProfilePageView.h
//  Instagram
//
//  Created by ilanashapiro on 7/11/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePageView : UIView

@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
