//
//  HomeScreenViewController.m
//  
//
//  Created by ilanashapiro on 7/8/19.
//

#import "HomeScreenViewController.h"
#import "Parse/Parse.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StartScreenViewController.h"
#import "Post.h"
#import "PostCell.h"
@import Parse;

@interface HomeScreenViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)didTapLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StartScreenViewController *startScreeenViewController = [storyboard instantiateViewControllerWithIdentifier:@"StartScreenViewController"];
        appDelegate.window.rootViewController = startScreeenViewController;
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
    }];
}

/*- (void)displayCaptionAlertBox {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Caption for Image"
                                                                   message:@"Network connection failed."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *submitTextAction = [UIAlertAction actionWithTitle:@"Submit"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (alert.textFields.count > 0) {
                                                                     UITextField *textField = [alert.textFields firstObject];
                                                                     NSLog(@"Caption is: %@", textField.text); // your text
                                                                     
                                                                 }
                                                             }];
    // add the OK action to the alert controller
    [alert addAction:submitTextAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     NSLog(@"cell for row");
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
   
    Post *post = self.postsArray[indexPath.row];
    cell.post = post;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

@end
