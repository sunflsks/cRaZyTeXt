#include "CRPRootListController.h"
#include <Preferences/PSSpecifier.h>

@implementation CRPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}


-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString* plist = [NSString
						stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist",
						specifier.properties[@"defaults"]
					];
	#ifdef DEBUG
	NSLog(@"crazytext readPreferenceValue path: %@", plist);
	#endif
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
	return dictionary[specifier.properties[@"key"]] ?: specifier.properties[@"default"];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString* plist = [NSString
						stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist",
						specifier.properties[@"defaults"]
					];

	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
	[plistDict setObject:value forKey:specifier.properties[@"key"]];
	[plistDict writeToFile:plist atomically:YES];

	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(
			CFNotificationCenterGetDarwinNotifyCenter(),
			notificationName,
			NULL,
			NULL,
			YES
		);
	}
}

@end
