//
//  HomeScreenViewController.m
//  
//
//  Created by ilanashapiro on 7/8/19.
//

#import "HomeScreenViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "StartScreenViewController.h"

@interface HomeScreenViewController ()

- (IBAction)didTapLogout:(id)sender;


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
@end
