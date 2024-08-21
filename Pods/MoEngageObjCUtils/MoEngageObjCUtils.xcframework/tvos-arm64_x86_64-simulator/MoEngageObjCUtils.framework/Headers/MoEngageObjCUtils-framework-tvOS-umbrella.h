#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MoEngageAppDelegateProxy.h"
#import "MoEngageAppDelegateSwizzler.h"
#import "MoEngageMutableDictionary.h"
#import "MoEngageObjCUtils.h"
#import "MoEngageProxyUtils.h"

FOUNDATION_EXPORT double MoEngageObjCUtilsVersionNumber;
FOUNDATION_EXPORT const unsigned char MoEngageObjCUtilsVersionString[];

