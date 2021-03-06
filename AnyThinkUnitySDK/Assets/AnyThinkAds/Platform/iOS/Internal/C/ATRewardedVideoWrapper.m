//
//  ATRewardedVideoWrapper.m
//  UnityContainer
//
//  Created by Martin Lau on 08/08/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATRewardedVideoWrapper.h"
#import "ATUnityUtilities.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
@interface ATRewardedVideoWrapper()<ATRewardedVideoDelegate>
@end
@implementation ATRewardedVideoWrapper
+(instancetype)sharedInstance {
    static ATRewardedVideoWrapper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ATRewardedVideoWrapper alloc] init];
    });
    return sharedInstance;
}

-(void) loadRewardedVideoWithPlacementID:(NSString*)placementID customDataJSONString:(NSString*)customDataJSONString callback:(void(*)(const char*, const char*))callback {
    [self setCallBack:callback forKey:placementID];
    [[ATAdManager sharedManager] loadADWithPlacementID:placementID extra:nil customData:([customDataJSONString isKindOfClass:[NSString class]] && [customDataJSONString dataUsingEncoding:NSUTF8StringEncoding] != nil) ? [NSJSONSerialization JSONObjectWithData:[customDataJSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil] : nil delegate:self];
}

-(BOOL) rewardedVideoReadyForPlacementID:(NSString*)placementID {
    return [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:placementID];
}

-(void) showRewardedVideoWithPlacementID:(NSString*)placementID extraJsonString:(NSString*)extraJsonString {
    NSDictionary *extraDict = ([extraJsonString isKindOfClass:[NSString class]] && [extraJsonString dataUsingEncoding:NSUTF8StringEncoding] != nil) ? [NSJSONSerialization JSONObjectWithData:[extraJsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil] : nil;
    [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:placementID scene:extraDict[kATUnityUtilitiesAdShowingExtraScenarioKey] inViewController:[UIApplication sharedApplication].delegate.window.rootViewController delegate:self];
}

-(void) clearCache {
    [[ATAdManager sharedManager] clearCache];
}

-(void) setExtra:(NSString*)extra {
    if ([extra isKindOfClass:[NSString class]]) {
        NSDictionary *extraDict = [NSJSONSerialization JSONObjectWithData:[extra dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if ([extraDict isKindOfClass:[NSDictionary class]]) [[ATAdManager sharedManager] setExtra:extraDict];
    }
}

-(NSString*) scriptWrapperClass {
    return @"ATRewardedVideoWrapper";
}

#pragma mark - delegate
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self invokeCallback:@"OnRewardedVideoLoaded" placementID:placementID error:nil extra:nil];
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    error = error != nil ? error : [NSError errorWithDomain:@"com.anythink.Unity3DPackage" code:100001 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load ad", NSLocalizedFailureReasonErrorKey:@"AT has failed to load ad"}];
    [self invokeCallback:@"OnRewardedVideoLoadFailure" placementID:placementID error:error extra:nil];
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    [self invokeCallback:@"OnRewardedVideoPlayStart" placementID:placementID error:nil extra:extra];
    [[NSNotificationCenter defaultCenter] postNotificationName:kATUnityUtilitiesRewardedVideoImpressionNotification object:nil];
}

-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    [self invokeCallback:@"OnRewardedVideoPlayEnd" placementID:placementID error:nil extra:extra];
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    error = error != nil ? error : [NSError errorWithDomain:@"com.anythink.Unity3DPackage" code:100001 userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to play video", NSLocalizedFailureReasonErrorKey:@"AT has failed to play video"}];
    [self invokeCallback:@"OnRewardedVideoPlayFailure" placementID:placementID error:error extra:extra];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    [self invokeCallback:@"OnRewardedVideoClose" placementID:placementID error:nil extra:@{@"rewarded":@(rewarded), @"extra":extra != nil ? extra : @{}}];
    [[NSNotificationCenter defaultCenter] postNotificationName:kATUnityUtilitiesRewardedVideoCloseNotification object:nil];
}

-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    [self invokeCallback:@"OnRewardedVideoClick" placementID:placementID error:nil extra:extra];
}

-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString*)placementID extra:(NSDictionary*)extra {
    [self invokeCallback:@"OnRewardedVideoReward" placementID:placementID error:nil extra:extra];
}
@end
