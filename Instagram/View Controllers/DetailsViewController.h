//
//  DetailsViewController.h
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostDetailsView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate <NSObject>

- (void)updateDetailsData:(UIViewController *)viewController;

@end

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet PostDetailsView *postDetailsView;
@property (nonatomic) NSIndexPath *postCellIndexPath;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;
@property (nonatomic) BOOL detailsPostLiked;

@end

NS_ASSUME_NONNULL_END
