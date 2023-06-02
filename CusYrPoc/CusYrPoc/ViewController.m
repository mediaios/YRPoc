//
//  ViewController.m
//  CusYrPoc
//
//  Created by Qi on 2023/5/19.
//

#import "ViewController.h"
#import "MiLiveViewController.h"
#import "MiAudienceVC.h"

@interface ViewController ()
@property (nonatomic,strong) MiLiveViewController *miLiveVC;
@property (nonatomic,strong) MiAudienceVC *miAudienceVC;
@end

@implementation ViewController

- (MiLiveViewController *)miLiveVC
{
    if(!_miLiveVC){
        _miLiveVC = [[MiLiveViewController alloc] initWithNibName:@"MiLiveViewController" bundle:nil];
    }
    return _miLiveVC;
}

- (MiAudienceVC *)miAudienceVC
{
    if(!_miAudienceVC){
        _miAudienceVC = [[MiAudienceVC alloc] initWithNibName:@"MiAudienceVC" bundle:nil];
    }
    return _miAudienceVC;
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
    [self presentViewController:self.miAudienceVC animated:YES completion:nil];
}

@end
