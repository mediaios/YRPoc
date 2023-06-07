//
//  ViewController.m
//  CusYrPoc
//
//  Created by Qi on 2023/5/19.
//

#import "ViewController.h"
#import "MiLiveViewController.h"
#import "MiAudienceVC.h"
#import "MiCdnAudienceVC.h"

@interface ViewController ()
@property (nonatomic,strong) MiLiveViewController *miLiveVC;
@property (nonatomic,strong) MiAudienceVC *miAudienceVC;
@property (nonatomic,strong) MiCdnAudienceVC *miCdnAudienceVC;
@end

@implementation ViewController

- (MiCdnAudienceVC *)miCdnAudienceVC
{
    if(!_miCdnAudienceVC){
        _miCdnAudienceVC = [[MiCdnAudienceVC alloc] initWithNibName:@"MiCdnAudienceVC" bundle:nil];
    }
    return _miCdnAudienceVC;
}

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
    [self presentViewController:self.miCdnAudienceVC animated:YES completion:nil];
}
- (IBAction)onPressedBtnToRtc:(id)sender {
    [self presentViewController:self.miAudienceVC animated:YES completion:nil];
}

@end
