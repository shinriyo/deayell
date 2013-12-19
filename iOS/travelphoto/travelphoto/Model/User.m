#import "User.h"


@interface User ()

// Private interface goes here.

@end


@implementation User

// Custom logic goes here.
- (void)awakeFromInsert {
    [super awakeFromInsert];
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    self.identifier = uuidStr;
}

@end
