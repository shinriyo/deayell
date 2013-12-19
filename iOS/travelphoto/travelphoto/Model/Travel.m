#import "Travel.h"


@interface Travel ()

// Private interface goes here.

@end


@implementation Travel

// Custom logic goes here.
- (void)awakeFromInsert {
    [super awakeFromInsert];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    self.identifier = uuidStr;
}

@end
