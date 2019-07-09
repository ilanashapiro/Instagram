//
//  StartScreenViewController.m
//  
//
//  Created by ilanashapiro on 7/8/19.
//

#import "StartScreenViewController.h"

@interface StartScreenViewController ()

- (IBAction)didTapLogin:(id)sender;
- (IBAction)didTapRegister:(id)sender;


@end

@implementation StartScreenViewController

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

- (IBAction)didTapRegister:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
}
@end
