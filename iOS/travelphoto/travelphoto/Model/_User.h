// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *username;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *travels;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class Travel;





@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* identifier;



//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *travels;

- (NSMutableSet*)travelsSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addTravels:(NSSet*)value_;
- (void)removeTravels:(NSSet*)value_;
- (void)addTravelsObject:(Travel*)value_;
- (void)removeTravelsObject:(Travel*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;





- (NSMutableSet*)primitiveTravels;
- (void)setPrimitiveTravels:(NSMutableSet*)value;


@end
