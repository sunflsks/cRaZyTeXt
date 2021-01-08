#include "TextUtils.h"

%hook UITextView

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.editable && (action == @selector(spongeText:) || action == @selector(zalgoText:))) {
        return YES;
    }

    return %orig(action, sender);
}

%new
-(void)spongeText:(id)arg1 {
    if (self.editable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* originalText = self.text;
            NSString* newString = spongeCase(originalText);
            [self insertText: newString];
        });
    }
}

%new
-(void)zalgoText:(id)arg1 {
    if (self.editable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* originalText = self.text;
            NSString* newString = zalgoText(originalText, HIGH);
            [self insertText: newString];
        });
    }
}

%end

%hook UIViewController

-(void)viewDidAppear:(BOOL)animated {
    %orig(animated);
    UIMenuItem* spongeCaseItem = [[UIMenuItem alloc] initWithTitle:@"sPoNgEcAsE" action:@selector(spongeText:)];
    UIMenuItem* zalgoTextItem = [[UIMenuItem alloc] initWithTitle:@"Zalgo" action:@selector(zalgoText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:spongeCaseItem, zalgoTextItem, nil]];
}

// This gets called in Spotlight Search and a few other apps. Doesn't work right now
%new
-(void)spongeText:(UIMenuController*)controller {
    return;
}

%new
-(void)zalgoText:(UIMenuController*)controller {
    return;
}

%end
