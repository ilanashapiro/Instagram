//
//  HomeScreenViewController.m
//  Instagram
//
//  Created by ilanashapiro on 7/8/19.
//  Copyright © 2019 ilanashapiro. All rights reserved.
//

#import "HomeScreenViewController.h"

@interface HomeScreenViewController ()

- (IBAction)didTapLogin:(id)sender;
- (IBAction)didTapSignUp:(id)sender;


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

- (IBAction)didTapLogin:(id)sender {
   [self performSegueWithIdentifier:@"loginSegue" sender:nil];
}

- (IBAction)didTapSignUp:(id)sender {
   [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

@end
