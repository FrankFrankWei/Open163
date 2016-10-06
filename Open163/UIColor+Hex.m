//
//  UIColor+Hex.m
//  Open163
//
//  Created by Frank on 9/22/16.
//  Copyright © 2016 Frank. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexString:(NSString*)hexColor
{
    if (7 == hexColor.length && [hexColor hasPrefix:@"#"]) {
        unsigned int red, green, blue;
        NSRange range;
        range.length = 2;

        range.location = 1;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
            scanHexInt:&red];

        range.location = 3;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
            scanHexInt:&green];

        range.location = 5;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]
            scanHexInt:&blue];

        return [UIColor colorWithRed:red / 255.0
                               green:green / 255.0
                                blue:blue / 255.0
                               alpha:1.0];
    }

    return [UIColor clearColor];
}
@end
