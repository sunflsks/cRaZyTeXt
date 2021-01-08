NSString* zalgoChar(NSString* character, NSUInteger craziness);
unichar spongeChar(unichar character);
NSString* zalgoText(NSString* input, NSUInteger craziness);
NSString* randomLetters(NSUInteger size);
NSString* spongeCase(NSString* string);

// For where to insert zalgo
#define LOW 1
#define LOW_MED 2
#define MED 3
#define MED_HIGH 4
#define HIGH 5