//
//  RCTVolumeControl.m
//  RNVolumeControl
//
//  Created by linsht on 2017/7/10.
//  Copyright © 2017年 Ilja Satchok. All rights reserved.
//

#import "RCTVolumeControl.h"
@import MediaPlayer;

@interface RCTVolumeControl()
@property (nonatomic, strong) UISlider *slider;
@end

@implementation RCTVolumeControl

RCT_EXPORT_MODULE()
@synthesize bridge = _bridge;

- (instancetype)init {
    self = [super init];
    if (self) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        UISlider* volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        volumeView.showsVolumeSlider = NO;
        _slider = volumeViewSlider;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}

- (void)volumeChanged:(NSNotification *)notification
{
    // service logic here.
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self sendEventWithName:@"IOSSystemVolumeChanged" body:@{@"value":@(volume)}];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"IOSSystemVolumeChanged"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

RCT_EXPORT_METHOD(getVolumeValue:(RCTResponseSenderBlock)callback) {
    NSLog(@"-----%f",_slider.value);
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setObject:@(val) forKey:@"value"];
    callback(@[@(_slider.value)]);
}

RCT_EXPORT_METHOD(setVolumeValue:(float)value) {
    _slider.value = value;
}

@end
