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

@interface HomeScreenViewController () <DetailsViewControllerDelegate, PostCellDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    
    [self fetchPosts];
    [self createRefreshControl];
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
        NSLog(@"going to detail post by: %@", post.author.username);
        detailsViewController.postCellIndexPath = indexPath;
        detailsViewController.delegate = self;
        NSLog(@"Tapping on a post!");
    }
    else if ([segue.identifier isEqualToString:@"profilePageSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        NSLog(@"going to user profile: %@", post.author.username);
        ProfilePageViewController *profilePageViewController = [segue destinationViewController]; 
        profilePageViewController.post = post;
        profilePageViewController.delegate = self;
        NSLog(@"Tapping on a profile!");
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
    cell.post = post;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (void)updateDetailsData:(nonnull DetailsViewController *)detailsViewController {
    Post *post = self.postsArray[detailsViewController.postCellIndexPath.row];
    post.liked = detailsViewController.postDetailsView.post.liked;
    post.likeCount = detailsViewController.postDetailsView.post.likeCount;
    [self.tableView reloadData];
}

- (void)updateProfileData:(nonnull ProfilePageViewController *)profilePageViewController {
    for (Post *post in self.postsArray) {
        NSString *currentUsername = [NSString stringWithFormat:@"%@", post.author.username];
        NSString *profileUsername = [NSString stringWithFormat:@"%@", profilePageViewController.post.author.username];
        
        if ([profilePageViewController.post.author objectForKey:@"profileImage"] && [currentUsername isEqual:profileUsername]) {
            NSLog(@"-------------------- %@ %@", post.author[@"profileImage"], profilePageViewController.post.author[@"profileImage"]);
            post.author[@"profileImage"] = profilePageViewController.post.author[@"profileImage"];
        }
    }
    [self.tableView reloadData];
}

- (void)performSegueToProfile:(nonnull PostCell *)postCell {
    [self performSegueWithIdentifier:@"profilePageSegue" sender:postCell];
}

@end
