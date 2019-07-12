//
//  DetailsViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/9/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "DetailsViewController.h"
#import "PostDetailsView.h"
#import "ProfilePageViewController.h"

@interface DetailsViewController () <ProfilePageViewControllerDelegate>

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.postDetailsView.post = self.post;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        [self.delegate updateDetailsData:self];
    }
}

- (void)updateProfileData:(nonnull ProfilePageViewController *)profilePageViewController {
    self.post.author[@"profileImage"] = profilePageViewController.post.author[@"profileImage"];
    self.postDetailsView.post = self.post;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"profilePageSegue"]) {
        ProfilePageViewController *profilePageViewController = [segue destinationViewController];
        profilePageViewController.post = self.post;
        profilePageViewController.delegate = self;
        NSLog(@"Tapping on a details post!");
    }
}

@end
