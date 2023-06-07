//
//  MiCdnAudienceVC.m
//  CusYrPoc
//
//  Created by Qi on 2023/6/5.
//

#import "MiCdnAudienceVC.h"
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "MiKeyCentor.h"

@interface MiMediaPlayer : NSObject<AgoraRtcMediaPlayerProtocol>

@end

@interface MiCdnAudienceVC ()<AgoraRtcEngineDelegate,AgoraRtcMediaPlayerDelegate>
@property (nonatomic,strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic,strong) MiMediaPlayer *miPlayer;
@property (weak, nonatomic) IBOutlet UIView *mPlayerView;

@end

@implementation MiCdnAudienceVC

- (void)initAgoraEngine
{
    AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
    // 传入 App ID。
    config.appId = AppID;
    // 设置频道场景为直播。
    config.channelProfile = AgoraChannelProfileLiveBroadcasting;
    // 创建并初始化 AgoraRtcEngineKit 实例。
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
    NSLog(@"sdk version: %@", [AgoraRtcEngineKit getSdkVersion]);
    
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initAgoraEngine];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.miPlayer = [self.agoraKit createMediaPlayerWithDelegate:self];
    [self.miPlayer setPlayerOption:@"is_live_source" value:1];
    [self.miPlayer setView:self.mPlayerView];
    [self.miPlayer open:@"https://examplepull.agoramdn.com/live/qitest.flv" startPos:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (IBAction)onPressedBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self stopPlay];
}

- (void)stopPlay
{
    // 关闭播放
    [self.miPlayer stop];
    [self.agoraKit destroyMediaPlayer:_miPlayer];
}


#pragma mark -AgoraRtcMediaPlayerDelegate
- (void)AgoraRtcMediaPlayer:(id<AgoraRtcMediaPlayerProtocol>)playerKit didChangedToState:(AgoraMediaPlayerState)state error:(AgoraMediaPlayerError)error
{
    switch (state) {
        case AgoraMediaPlayerStateOpenCompleted:
        {
            [self.miPlayer play];
        }
            break;
            
        default:
            break;
    }
}


@end
