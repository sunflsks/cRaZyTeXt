#include "PrefsUtils.h"

int crazyLevel(void) {
    NSString* defaultId = @"us.sudhip.crazyprefs";
    NSString* path = [NSString
                        stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist",
                        defaultId
                    ];

    NSDictionary* dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    int value = [[dictionary valueForKey:@"crazyLevel"] integerValue];
    #ifdef DEBUG
    NSLog(@"crazytext prefs: %d", value);
    #endif
    return value;
}