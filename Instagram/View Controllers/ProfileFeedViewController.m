//
//  ProfileFeedViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/10/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "ProfileFeedViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"
#import "ProfilePageViewController.h"
@import Parse;

@interface ProfileFeedViewController () <DetailsViewControllerDelegate, ProfilePageViewControllerDelegate, PostCellDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)didTapLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *postsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(receiveNotification:)
                                          name:@"ChangedTabBarDataNotification"
                                          object:nil];
    
    [self fetchPosts];
    [self createRefreshControl];
}

/*- (void)viewWillAppear:(BOOL)animated {
    [self fetchPosts];
}*/

- (void)receiveNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ChangedTabBarDataNotification"]) {
        NSLog (@"Successfully received the change tab bar data notification on home feed!");
        NSArray *newPostsArrayFromHomeFeed = [[notification userInfo] objectForKey:@"postsArray"];
        //Post *newPostFromProfileFeed = [[notification userInfo] objectForKey:@"postLikedID"];
        NSLog(@"posts array: %@", self.postsArray);
        if (newPostsArrayFromHomeFeed) {
            self.postsArray = [[notification userInfo] objectForKey:@"postsArray"];
            NSPredicate *postsBySelf = [NSPredicate predicateWithFormat:
                                     @"SELF.%K IN %@", @"author.objectId", [PFUser currentUser].objectId];
            self.postsArray = [self.postsArray filteredArrayUsingPredicate:postsBySelf];
            //NSLog(@"POSTS BY SELF: %@", self.postsArray);
            
        }
//        else if (newPostFromProfileFeed) {
//
//        }
        [self.tableView reloadData];
        
        
        
        /*if ([[notification userInfo] objectForKey:@"postsArray"] == nil) {
            //means like occurred in details view
            [self fetchPosts];
        }
        else {
            self.postsArray = [[notification userInfo] objectForKey:@"postsArray"];
            [self.tableView reloadData];
        }*/
    }
}

- (void)createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginScreeenViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginScreeenViewController;
        NSLog(@"Logged out!");
    }];
}

- (void)fetchPosts {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.postsArray = posts;
            //NSLog(@"self.posts array profile: %@", self.postsArray);
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.postsArray[indexPath.row];
    cell.delegate = self;
    cell.post = post;
    cell.indexPath = indexPath;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (void)updateDetailsData:(nonnull DetailsViewController *)detailsViewController {
    /*Post *post = self.postsArray[detailsViewController.postCellIndexPath.row];
    post.liked = detailsViewController.postDetailsView.post.liked;
    post.likeCount = detailsViewController.postDetailsView.post.likeCount;
    [self.tableView reloadData];*/
    Post *post = self.postsArray[detailsViewController.postCellIndexPath.row];
    BOOL detailsPostLiked = [detailsViewController.post.arrayOfUsersWhoLiked containsObject:detailsViewController.post.author.objectId];
    BOOL feedPostLikedBeforeDetails = [post.arrayOfUsersWhoLiked containsObject:post.author.objectId];
    if (!detailsPostLiked && feedPostLikedBeforeDetails) {
        [post.arrayOfUsersWhoLiked removeObject:post.author.objectId];
    }
    else if (detailsPostLiked && !feedPostLikedBeforeDetails)
    {
        [post.arrayOfUsersWhoLiked addObject:post.author.objectId];
    }
    
    post.likeCount = detailsViewController.post.likeCount;
    
    if (detailsViewController.detailsPostLiked) {
        [self notifyLikeUpdates:post];
    }
    else {
        [self.tableView reloadData];
    }
    
}

- (void)updateProfileData:(nonnull ProfilePageViewController *)profilePageViewController {
    for (Post *post in self.postsArray) {
        //since all posts are by current user in this tab, all profile pics will be updated
        post.author[@"profileImage"] = profilePageViewController.post.author[@"profileImage"];
    }
    
    NSDictionary *postsInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.postsArray,@"postsArray", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedTabBarDataNotification" object:self userInfo:postsInfoDict];
}

- (void)notifyLikeUpdates:(Post *)postLiked {
    NSDictionary *postsInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:postLiked,@"postLiked", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedTabBarDataNotification" object:self userInfo:postsInfoDict];
}

- (void)performSegueToProfile:(nonnull PostCell *)postCell {
    [self performSegueWithIdentifier:@"profilePageSegue" sender:postCell];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController]; //returns a UIViewController, which DetailsViewController is a subclass of
        detailsViewController.post = post;
        detailsViewController.delegate = self;
        NSLog(@"Tapping on a post by: %@", post.author.username);
    }
    else if ([segue.identifier isEqualToString:@"profilePageSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        ProfilePageViewController *profilePageViewController = [segue destinationViewController]; //returns a UIViewController, which DetailsViewController is a subclass of
        profilePageViewController.post = post;
        profilePageViewController.delegate = self;
        NSLog(@"Tapping on user profile by: %@", post.author.username);
    }
}

@end
