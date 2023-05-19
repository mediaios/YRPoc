//
//  ViewController.m
//  CusYrPoc
//
//  Created by Qi on 2023/5/19.
//

#import "ViewController.h"
#import "MiLiveViewController.h"

@interface ViewController ()
@property (nonatomic,strong) MiLiveViewController *miLiveVC;
@end

@implementation ViewController

- (MiLiveViewController *)miLiveVC
{
    if(!_miLiveVC){
        _miLiveVC = [[MiLiveViewController alloc] initWithNibName:@"MiLiveViewController" bundle:nil];
    }
    return _miLiveVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onPressedBtnToLivePage:(id)sender {
    [self presentViewController:self.miLiveVC animated:YES completion:nil];
    
}
- (IBAction)onPressedBtnToCdn:(id)sender {
}
- (IBAction)onPressedBtnToRtc:(id)sender {
}

@end
