#include "TextUtils.h"

#define ASCII_MAX 255

// Zalgo chars thanks to https://stackoverflow.com/questions/26927419/zalgo-text-in-java by MihaiC
uint32_t zalgo_up[] =
{
    0x030d, /*     Ì?     */0x030e, /*     ÌŽ     */0x0304, /*     Ì„     */0x0305, /*     Ì…     */
    0x033f, /*     Ì¿     */0x0311, /*     Ì‘     */0x0306, /*     Ì†     */0x0310, /*     Ì?     */
    0x0352, /*     Í’     */0x0357, /*     Í—     */0x0351, /*     Í‘     */0x0307, /*     Ì‡     */
    0x0308, /*     Ìˆ     */0x030a, /*     ÌŠ     */0x0342, /*     Í‚     */0x0343, /*     Ì“     */
    0x0344, /*     ÌˆÌ?   */0x034a, /*     ÍŠ     */0x034b, /*     Í‹     */0x034c, /*     ÍŒ     */
    0x0303, /*     Ìƒ     */0x0302, /*     Ì‚     */0x030c, /*     ÌŒ     */0x0350, /*     Í?     */
    0x0300, /*     Ì€     */0x0301, /*     Ì?     */0x030b, /*     Ì‹     */0x030f, /*     Ì?     */
    0x0312, /*     Ì’     */0x0313, /*     Ì“     */0x0314, /*     Ì”     */0x033d, /*     Ì½     */
    0x0309, /*     Ì‰     */0x0363, /*     Í£     */0x0364, /*     Í¤     */0x0365, /*     Í¥     */
    0x0366, /*     Í¦     */0x0367, /*     Í§     */0x0368, /*     Í¨     */0x0369, /*     Í©     */
    0x036a, /*     Íª     */0x036b, /*     Í«     */0x036c, /*     Í¬     */0x036d, /*     Í­     */
    0x036e, /*     Í®     */0x036f, /*     Í¯     */0x033e, /*     Ì¾     */0x035b, /*     Í›     */
    0x0346, /*     Í†     */0x031a /*     Ìš     */
};

uint32_t zalgo_down[] =
{
    0x0316, /*     Ì–     */0x0317, /*     Ì—     */0x0318, /*     Ì˜     */0x0319, /*     Ì™     */
    0x031c, /*     Ìœ     */0x031d, /*     Ì?     */0x031e, /*     Ìž     */0x031f, /*     ÌŸ     */
    0x0320, /*     Ì      */0x0324, /*     Ì¤     */0x0325, /*     Ì¥     */0x0326, /*     Ì¦     */
    0x0329, /*     Ì©     */0x032a, /*     Ìª     */0x032b, /*     Ì«     */0x032c, /*     Ì¬     */
    0x032d, /*     Ì­      */0x032e, /*     Ì®     */0x032f, /*     Ì¯     */0x0330, /*     Ì°     */
    0x0331, /*     Ì±     */0x0332, /*     Ì²     */0x0333, /*     Ì³     */0x0339, /*     Ì¹     */
    0x033a, /*     Ìº     */0x033b, /*     Ì»     */0x033c, /*     Ì¼     */0x0345, /*     Í…     */
    0x0347, /*     Í‡     */0x0348, /*     Íˆ     */0x0349, /*     Í‰     */0x034d, /*     Í?     */
    0x034e, /*     ÍŽ     */0x0353, /*     Í“     */0x0354, /*     Í”     */0x0355, /*     Í•     */
    0x0356, /*     Í–     */0x0359, /*     Í™     */0x035a, /*     Íš     */0x0323 /*     Ì£     */
};

//those always stay in the middle
uint32_t zalgo_mid[] =
{
    0x0315, /*     Ì•     */0x031b, /*     Ì›     */0x0340, /*     Ì€     */0x0341, /*     Ì?     */
    0x0358, /*     Í˜     */0x0321, /*     Ì¡     */0x0322, /*     Ì¢     */0x0327, /*     Ì§     */
    0x0328, /*     Ì¨     */0x0334, /*     Ì´     */0x0335, /*     Ìµ     */0x0336, /*     Ì¶     */
    0x034f, /*     Í?     */0x035c, /*     Íœ     */0x035d, /*     Í?     */0x035e, /*     Íž     */
    0x035f, /*     ÍŸ     */0x0360, /*     Í      */0x0362, /*     Í¢     */0x0338, /*     Ì¸     */
    0x0337, /*     Ì·     */0x0361, /*     Í¡     */0x0489 /*     Ò‰_     */
};

NSString* spongeCase(NSString* string) {
    unichar charOfString;
    NSMutableString* newString =  [NSMutableString stringWithCapacity:string.length + 2];

    for (int i = 0; i < string.length; i++) {
        charOfString = [string characterAtIndex:i];

        if (isalpha(charOfString)) {
            charOfString = spongeChar(charOfString);
        }

        [newString appendFormat:@"%C", charOfString];
    }

    return newString;
}

NSString* randomLetters(NSUInteger size) {
    NSMutableString* string = [NSMutableString stringWithCapacity:size];

    for (NSUInteger i = 0; i < size; i++) {
        unichar random = arc4random_uniform(ASCII_MAX);
        [string appendFormat:@"%C", random];
    }

    return string;
}

NSString* zalgoText(NSString* input, NSUInteger craziness) {
    NSMutableString* ret = [NSMutableString stringWithCapacity:[input length] * craziness * 2];

    for (NSUInteger i = 0; i < [input length]; i++) {
        NSString* zalgoCharacter = zalgoChar(
            [input substringWithRange:NSMakeRange(i, 1)], craziness
        );
        [ret appendString:zalgoCharacter];
    }

    return ret;
}

unichar spongeChar(unichar character) {
    int rand = arc4random_uniform(11);

    if (rand > 5) {
        if (isupper(character)) {
            character = tolower(character);
        }

        else if (islower(character)) {
            character = toupper(character);
        }
    }

    return character;
}

// Algorithm thanks to https://textozor.com/zalgo-text/scriptz.js
NSString* zalgoChar(NSString* character, NSUInteger craziness) {
    NSMutableString* ret = [NSMutableString stringWithCapacity:craziness];
    [ret appendString: character];

    int up_count;
    int mid_count;
    int down_count;

    switch (craziness) {
        default:
        case LOW:
            NSLog(@"zalgo low");
            up_count = arc4random_uniform(8);
            mid_count = arc4random_uniform(2);
            down_count = arc4random_uniform(8);
            break;

        case LOW_MED:
                    NSLog(@"zalgo lowmed");
            up_count = arc4random_uniform(12) / 2 + 2;
            mid_count = arc4random_uniform(4);
            down_count = arc4random_uniform(12) / 2 + 2;
            break;

        case MED:
                    NSLog(@"zalgo med");
            up_count = arc4random_uniform(16) / 2 + 1;
            mid_count = arc4random_uniform(6) / 2;
            down_count = arc4random_uniform(16) / 2 + 1;
            break;

        case MED_HIGH:
                    NSLog(@"zalgo medhigh");
            up_count = arc4random_uniform(32) / 3 + 4;
            mid_count = arc4random_uniform(8) / 3 + 1;
            down_count = arc4random_uniform(32) / 3 + 4;
            break;

        case HIGH:
            NSLog(@"zalgo high");
            up_count = arc4random_uniform(64) / 4 + 3;
            mid_count = arc4random_uniform(16) / 4 + 1;
            down_count = arc4random_uniform(64) / 4 + 3;
    }

    for (int i = 0; i < up_count; i++) {
        uint32_t rand_zalgo = zalgo_up[arc4random_uniform(sizeof(zalgo_up) / 4)];
        NSString* unicodeZalgo = [[NSString alloc]
                                    initWithBytes:&rand_zalgo
                                    length:sizeof(rand_zalgo)
                                    encoding:NSUTF32LittleEndianStringEncoding
                                ];
        [ret appendString:unicodeZalgo];
    }

    for (int i = 0; i < mid_count; i++) {
        uint32_t rand_zalgo = zalgo_mid[arc4random_uniform(sizeof(zalgo_mid) / 4)];
        NSString* unicodeZalgo = [[NSString alloc]
                                    initWithBytes:&rand_zalgo
                                    length:sizeof(rand_zalgo)
                                    encoding:NSUTF32LittleEndianStringEncoding
                                ];
        [ret appendString:unicodeZalgo];
    }

    for (int i = 0; i < up_count; i++) {
        uint32_t rand_zalgo = zalgo_down[arc4random_uniform(sizeof(zalgo_down) / 4)];
        NSString* unicodeZalgo = [[NSString alloc]
                                    initWithBytes:&rand_zalgo
                                    length:sizeof(rand_zalgo)
                                    encoding:NSUTF32LittleEndianStringEncoding
                                ];
        [ret appendString:unicodeZalgo];
    }

    return ret;
}