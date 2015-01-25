#import <Foundation/Foundation.h>

@interface QCCHex : NSObject

+ (NSString *)hexStringWithBytes:(const void *)bytes length:(NSUInteger)length;

+ (NSString *)hexStringWithData:(NSData *)data;

+ (NSData *)dataWithHexString:(NSString *)hexString;

@end
