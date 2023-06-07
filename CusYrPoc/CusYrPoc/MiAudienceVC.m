//
//  MiAudienceVC.m
//  CusYrPoc
//
//  Created by Qi on 2023/5/19.
//

#import "MiAudienceVC.h"
#import "MiKeyCentor.h"
#import <AgoraRtcKit/AgoraRtcKit.h>



@interface MiAudienceVC ()<AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (nonatomic,strong) AgoraRtcEngineKit *agoraKit;

@end

@implementation MiAudienceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initializeAgoraEngine];
    [self joinChannel];
}

- (UIModalPresentationStyle)modalPresentationStyle
{
    return UIModalPresentationFullScreen;
}

// Objective-C
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AppID delegate:self];
}

- (void)joinChannel{
    [self.agoraKit enableVideo];
    
    AgoraRtcChannelMediaOptions *opts = [AgoraRtcChannelMediaOptions new];
    opts.clientRoleType = AgoraClientRoleAudience;
    opts.autoSubscribeAudio = YES;
    opts.autoSubscribeVideo = YES;
    opts.audienceLatencyLevel = AgoraAudienceLatencyLevelLowLatency;
    opts.channelProfile = AgoraChannelProfileLiveBroadcasting;
    
    [self.agoraKit joinChannelByToken:@"" channelId:@"qitest" uid:0 mediaOptions:opts joinSuccess:nil];
}

- (void)setupRemoteVideo:(NSUInteger)uid{
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = self.liveView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
}

- (IBAction)onPressedBtnOpenGaoqing:(id)sender {
    [self.agoraKit leaveChannel:nil];
    
    // 观众端开启265
    [self.agoraKit setParameters:@"{\"che.video.h265dec_libhevc_enable\": false}"];
    [self.agoraKit setParameters:@"{\"che.video.h265_dec_enable\": true}"];
    
    
    // 开超超级画质
    [self.agoraKit setParameters:@"{\"rtc.video.enable_sr\":{\"enabled\":true, \"mode\":2},\"rtc.video.sr_max_wh\":921598,\"rtc.video.sr_type\":7}"];
    
    [self joinChannel];
}



- (IBAction)onPressedBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.agoraKit leaveChannel:nil];
}

#pragma mark --AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"QiDebug, join channel success, uid:%lu\n",uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"QiDebug, remote user joined channel, uid:%lu\n",uid);
    [self setupRemoteVideo:uid];
}

@end
