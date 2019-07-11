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

- (void)updateData:(UIViewController *)viewController;

@end

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet PostDetailsView *postDetailsView;
@property (nonatomic, strong) Post *post;
@property (nonatomic) NSIndexPath *postCellIndexPath;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
