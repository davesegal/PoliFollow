PoliFollow
==========

App to find representatives to the US government by location and zip code. To compile you will need to create a class named PLFAPIKeys like the example below.  'PLFAPIKeysSunlightKey' should be a valid API key from the Sunlight Foundation.

Here is an example PLFAPIKeys header file.

\#import \<Foundation/Foundation.h\>

@interface PLFAPIKeys : NSObject

// Sunlight Foundation key

FOUNDATION_EXTERN NSString *const PLFAPIKeysSunlightKey;

@end
