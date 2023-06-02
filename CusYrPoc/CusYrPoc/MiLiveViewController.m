//
//  MiLiveViewController.m
//  CusYrPoc
//
//  Created by Qi on 2023/5/19.
//

#import "MiLiveViewController.h"
#import "MiKeyCentor.h"
#import <AgoraRtcKit/AgoraRtcKit.h>
#import <AgoraSenseTimeExtension/st_mobile_human_action.h>
#import <AgoraSenseTimeExtension/st_mobile_effect.h>


NSString *const license_name = @"SenseME.lic";


@interface MiLiveViewController ()<AgoraRtcEngineDelegate,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (nonatomic,strong) AgoraRtcEngineKit *agoraKit;

@property(assign, nonatomic) BOOL enable;

@end

@implementation MiLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"QiDebug, appid: %@",AppID);
    self.enable = NO;
    
    [self initializeAgoraEngine];
    [self setupLocalVideo];
    [self joinChannel];
}


// Objective-C
- (void)initializeAgoraEngine {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AppID delegate:self];
}

- (void)joinChannel{
    [self enableExtension:nil];
    [self.agoraKit enableVideo];
    
    
    AgoraCameraCapturerConfiguration *cfg = [[AgoraCameraCapturerConfiguration alloc] init];
    cfg.dimensions = CGSizeMake(720, 1280);
    cfg.frameRate = 24;
    cfg.cameraDirection = AgoraCameraDirectionFront;
    [self.agoraKit setCameraCapturerConfiguration:cfg];
    
    AgoraRtcChannelMediaOptions *opts = [AgoraRtcChannelMediaOptions new];
    opts.clientRoleType = AgoraClientRoleBroadcaster;
    opts.publishCameraTrack = YES;
    opts.publishMicrophoneTrack = YES;
    opts.channelProfile = AgoraChannelProfileLiveBroadcasting;
    
    AgoraVideoEncoderConfiguration *encoderCfg = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(720, 1280)
                                                                                            frameRate:15
                                                                                              bitrate:AgoraVideoBitrateStandard
                                                                                      orientationMode:AgoraVideoOutputOrientationModeAdaptative
                                                                                           mirrorMode:AgoraVideoMirrorModeAuto];
    [self.agoraKit setVideoEncoderConfiguration:encoderCfg];
    
    [self.agoraKit joinChannelByToken:@"" channelId:@"qitest" uid:111 mediaOptions:opts joinSuccess:nil];
    
    [self initExtension:nil];
    [self setComposer:nil];
    [self setSticker:nil];
}

- (void)setupLocalVideo{
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.liveView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
}


- (IBAction)enableExtension:(id)sender {
  self.enable = !self.enable;
  [self.agoraKit enableExtensionWithVendor:@"SenseTime"
                                 extension:@"Effect"
                                   enabled:YES];
//  if (self.enable) {
//    [self.enableExtensionBtn setTitle:@"disableExtension"
//                             forState:UIControlStateNormal];
//  } else {
//    [self.enableExtensionBtn setTitle:@"enableExtension"
//                             forState:UIControlStateNormal];
//  }
}

- (IBAction)initExtension:(id)sender {
    {
        NSString* fileName = [[license_name lastPathComponent] stringByDeletingPathExtension];
        NSString* extension = [license_name pathExtension];
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                            @"license_path": [[NSBundle mainBundle]
                                                                pathForResource:fileName
                                                                         ofType:extension]
                                                        }
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        // 检查激活码
        [self.agoraKit
            setExtensionPropertyWithVendor:@"SenseTime"
                                 extension:@"Effect"
                                       key:@"st_mobile_check_activecode"
                                     value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }

    {
        NSString *model_path = [[[NSBundle mainBundle]
                                 pathForResource:@"model"
                                 ofType:@"bundle"] stringByAppendingFormat:@"/%@", @"M_SenseME_Face_Extra_Advanced_6.0.13.model"];
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                            @"model_path": model_path,
                                                            @"config": @(ST_MOBILE_HUMAN_ACTION_DEFAULT_CONFIG_IMAGE)
                                                        }
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
        // 创建人体行为检测句柄
        [self.agoraKit
            setExtensionPropertyWithVendor:@"SenseTime"
                                 extension:@"Effect"
                                       key:@"st_mobile_human_action_create"
                                     value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    }

    {
        // 创建特效句柄
        [self.agoraKit
            setExtensionPropertyWithVendor:@"SenseTime"
                                 extension:@"Effect"
                                       key:@"st_mobile_effect_create_handle"
                                     value:@"{}"];
    }
}


- (IBAction)setSticker:(id)sender {
    NSString *path = [[[NSBundle mainBundle]
                       pathForResource:@"lips"
                       ofType:@"bundle"] stringByAppendingFormat:@"/%@", @"12自然.zip"];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                        @"param": @(EFFECT_BEAUTY_MAKEUP_LIP),
                                                        @"path": path
                                                    }
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    [self.agoraKit
        setExtensionPropertyWithVendor:@"SenseTime"
                             extension:@"Effect"
                                   key:@"st_mobile_effect_set_beauty"
                                 value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (IBAction)setComposer:(id)sender {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                        @"param": @(EFFECT_BEAUTY_PLASTIC_SHRINK_GODDESS_FACE),
                                                        @"val": @0.8f
                                                    }
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    [self.agoraKit
        setExtensionPropertyWithVendor:@"SenseTime"
                             extension:@"Effect"
                                   key:@"st_mobile_effect_set_beauty_strength"
                                 value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (NSString *)toJson:(NSDictionary *)dic {
  NSError *error;
  NSData *data =
      [NSJSONSerialization dataWithJSONObject:dic
                                      options:NSJSONWritingPrettyPrinted
                                        error:&error];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark --AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"QiDebug, join channel success, uid:%lu\n",uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"QiDebug, remote user joined channel, uid:%lu\n",uid);
//    [self setupRemoteVideo:uid];
}

@end
