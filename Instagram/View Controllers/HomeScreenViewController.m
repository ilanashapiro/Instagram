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
@import ParseUI;

@interface HomeScreenViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)didTapLogout:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
        }
        else {
            // handle error
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


@end
