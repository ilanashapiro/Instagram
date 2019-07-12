//
//  ProfilePageViewController.h
//  Instagram
//
//  Created by ilanashapiro on 7/11/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfilePageViewControllerDelegate <NSObject>

- (void)updateData:(UIViewController *)viewController;

@end

@interface ProfilePageViewController : UIViewController

@property (nonatomic, strong) Post *post;
@property (nonatomic, weak) id<ProfilePageViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
