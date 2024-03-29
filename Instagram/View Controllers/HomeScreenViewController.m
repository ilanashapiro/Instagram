//
//  HomeScreenViewController.m
//  
//
//  Created by ilanashapiro on 7/8/19.
//

#import "HomeScreenViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"
#import "ProfilePageViewController.h"
@import Parse;

@interface HomeScreenViewController () <DetailsViewControllerDelegate, PostCellDelegate, ProfilePageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)didTapLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation HomeScreenViewController

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

- (void)receiveNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ChangedTabBarDataNotification"]) {
        NSLog (@"Successfully received the change tab bar data notification on home feed!");
        NSArray *newPostsArray = [[notification userInfo] objectForKey:@"postsArray"];

        if (newPostsArray) {
            self.postsArray = [[notification userInfo] objectForKey:@"postsArray"];
        }
        else {
        //means a post was changed in the profile feed, and since the posts are filtered there, we have to find the post in the home feed and change it rather than set the entire home feed posts array to the filtered version in profile feed, which would mean then the home feed would be indifferent from profile feed
            Post *newPostFromProfileFeed = [[notification userInfo] objectForKey:@"postLiked"];
            int index = 0;
            for (Post *post in self.postsArray) {
                if ([post.objectId isEqualToString:newPostFromProfileFeed.objectId]) {
                    NSMutableArray *postsArrayMutable = [self.postsArray mutableCopy];
                    [postsArrayMutable replaceObjectAtIndex:index withObject:newPostFromProfileFeed];
                    self.postsArray = postsArrayMutable;
                }
                
                index ++;
            }
        }
        [self.tableView reloadData];
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
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.postsArray = posts;
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
        NSString *currentUsername = [NSString stringWithFormat:@"%@", post.author.username];
        NSString *profileUsername = [NSString stringWithFormat:@"%@", profilePageViewController.post.author.username];
        
        if ([profilePageViewController.post.author objectForKey:@"profileImage"] && [currentUsername isEqual:profileUsername]) {
            post.author[@"profileImage"] = profilePageViewController.post.author[@"profileImage"];
        }
    }
    NSDictionary *postsInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.postsArray,@"postsArray", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedTabBarDataNotification" object:self userInfo:postsInfoDict];
}

- (void)notifyLikeUpdates:(Post *)post {
    NSDictionary *postsInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.postsArray,@"postsArray", nil];
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
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
        detailsViewController.postCellIndexPath = indexPath;
        detailsViewController.delegate = self;
        NSLog(@"Tapping on a post by: %@", post.author.username);
    }
    else if ([segue.identifier isEqualToString:@"profilePageSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        ProfilePageViewController *profilePageViewController = [segue destinationViewController];
        profilePageViewController.post = post;
        profilePageViewController.delegate = self;
        NSLog(@"Tapping on user profile by: %@", post.author.username);
    }
}

@end
