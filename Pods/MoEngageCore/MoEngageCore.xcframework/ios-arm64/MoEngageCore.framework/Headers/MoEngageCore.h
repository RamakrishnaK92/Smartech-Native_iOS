//
//  MoEngageCore.h
//  MoEngageCore
//
//  Created by Chengappa C D on 10/03/21.
//  Copyright © 2021 MoEngage. All rights reserved.
//

#if !defined(__has_include)
#error Umbrella header not found use "@import" to import module
#else

#if __has_include(<MoEngageCore/MoEngageCore-umbrella.h>)
#import <MoEngageCore/MoEngageCore-umbrella.h>
#elif TARGET_OS_IOS && __has_include(<MoEngageCore/MoEngageCore-framework-iOS-umbrella.h>)
#import <MoEngageCore/MoEngageCore-framework-iOS-umbrella.h>
#elif TARGET_OS_TV && __has_include(<MoEngageCore/MoEngageCore-framework-tvOS-umbrella.h>)
#import <MoEngageCore/MoEngageCore-framework-tvOS-umbrella.h>
#elif TARGET_OS_IOS && __has_include(<MoEngageCore/MoEngageCore-library-iOS-umbrella>)
#import <MoEngageCore/MoEngageCore-library-iOS-umbrella>
#elif TARGET_OS_TV && __has_include(<MoEngageCore/MoEngageCore-framework-tvOS-umbrella.h>)
#import <MoEngageCore/MoEngageCore-library-tvOS-umbrella.h>
#else
#error Umbrella header not found use "@import" to import module
#endif
#endif
