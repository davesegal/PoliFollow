//
//  Representative+PLFDataHelper.m
//  PoliFollow
//
//  Created by David Segal on 10/28/13.
//  Copyright (c) 2013 David Segal. All rights reserved.
//

#import "Representative+PLFDataHelper.h"

static NSString *const OPEN_GOV_URL = @"https://www.govtrack.us";
static NSString *const OPEN_GOV_PHOTOS = @"/data/photos/";

@implementation Representative (PLFDataHelper)


- (void)deserializeData:(NSDictionary *)repData ofRepType:(NSInteger)repType
{
    [self deserializeCommonData:repData];
    switch (repType) {
        case PLFRepresentativeTypeFederalRep:
        case PLFRepresentativeTypeFederalHouse:
        case PLFRepresentativeTypeFederalSenate:
            [self deserializeFedData:repData];
            break;
            
        case PLFRepresentativeTypeStateRep:
            [self deserializeStateData:repData];
            break;
            
        default:
            break;
    }
    
}

- (void)deserializeCommonData:(NSDictionary *)repData
{
    self.district = ( repData[@"district"] == [NSNull null] ) ? @"" : [NSString stringWithFormat:@"%@", repData[@"district"]];
    self.email = @"";
    self.firstName = ( repData[@"first_name"] == [NSNull null] ) ? @"" : repData[@"first_name"];
    self.lastName = ( repData[@"last_name"] == [NSNull null] ) ? @"" : repData[@"last_name"];
    self.name = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    self.party = ( repData[@"party"] == [NSNull null] ) ? @"" : repData[@"party"];
    self.phone = ( repData[@"phone"] == [NSNull null] ) ? @"" : repData[@"phone"];
    self.urlLink = @"";
    self.chamber = ( repData[@"chamber"] == [NSNull null] ) ? @"" : repData[@"chamber"];
    self.website = ( repData[@"website"] == [NSNull null] ) ? @"" : repData[@"website"];
    self.address = ( repData[@"office"] == [NSNull null] ) ? @"" : repData[@"office"];
    self.state = ( repData[@"state"] == [NSNull null] ) ? @"" : repData[@"state"];
    self.facebookId = ( repData[@"facebook_id"] == [NSNull null] ) ? @"" : repData[@"facebook_id"];
    self.twitterId = ( repData[@"twitter_id"] == [NSNull null] ) ? @"" : repData[@"twitter_id"];
    
    self.govTrackId = (repData[@"govtrack_id"] == [NSNull null] ) ? @"" : repData[@"govtrack_id"];
}

- (void)deserializeStateData:(NSDictionary *)repData
{
    self.category = PLFRepresentativeTypeStateRep;
}

- (void)deserializeFedData:(NSDictionary *)repData
{
    self.voteSmartId = (repData[@"votesmart_id"] == [NSNull null] ) ? @"" : [NSString stringWithFormat:@"%@", repData[@"votesmart_id"]];
    if ([self.chamber isEqualToString:@"senate"])
    {
        self.category = PLFRepresentativeTypeFederalSenate;
    }
    else if ([self.chamber isEqualToString:@"house"])
    {
        self.category = PLFRepresentativeTypeFederalHouse;
    }
}

- (NSString *)getPhotoUrl:(NSInteger)size
{
    https://www.govtrack.us/data/photos/300002-100px.jpeg
    if (![self.govTrackId isEqualToString:@""])
    {
        return [NSString stringWithFormat:@"%@%@%@-%dpx.jpeg", OPEN_GOV_URL, OPEN_GOV_PHOTOS, self.govTrackId, size];
    }
    else
    {
        return nil;
    }
}

@end
