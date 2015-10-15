#import "KakaoTalk.h"
#import <Cordova/CDVPlugin.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@implementation KakaoTalk

- (void) login:(CDVInvokedUrlCommand*) command
{
    [[KOSession sharedSession] close];
	
	[[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
		
	    if ([[KOSession sharedSession] isOpen]) {
	        // login success
	        NSLog(@"login succeeded.");
	        [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
                CDVPluginResult* pluginResult = nil;
			    if (result) {
			        // success
			        NSLog(@"userId=%@", result.ID);
			        NSLog(@"nickName=%@", [result propertyForKey:@"nickname"]);
                    NSLog(@"profileImage=%@", [result propertyForKey:@"profile_image"]);
			        
			        NSDictionary *userSession = @{
										  @"id": result.ID,
										  @"nickname": [result propertyForKey:@"nickname"],
										  @"profile_image": [result propertyForKey:@"profile_image"]};
					pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userSession];
			    } else {
			        // failed
			        NSLog(@"login session failed.");
			        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
			    }
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
			}];
	    } else {
	        // failed
	        NSLog(@"login failed.");
	        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	    }
	    
	    
	}];
}

- (void)logout:(CDVInvokedUrlCommand*)command
{
	[[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
	    if (success) {
	        // logout success.
            NSLog(@"Successful logout.");
	    } else {
	        // failed
	        NSLog(@"failed to logout.");
	    }
	}];
	CDVPluginResult* pluginResult = pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
