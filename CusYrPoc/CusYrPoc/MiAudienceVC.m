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
    
    [self initializeAgoraEngine];
    [self joinChannel];
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
