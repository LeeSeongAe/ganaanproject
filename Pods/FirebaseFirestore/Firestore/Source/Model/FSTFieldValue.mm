/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "Firestore/Source/Model/FSTFieldValue.h"

#include <functional>
#include <utility>

#import "FIRDocumentSnapshot.h"
#import "FIRTimestamp.h"

#import "Firestore/Source/API/FIRGeoPoint+Internal.h"
#import "Firestore/Source/API/FIRTimestamp+Internal.h"
#import "Firestore/Source/API/converters.h"
#import "Firestore/Source/Model/FSTDocumentKey.h"
#import "Firestore/Source/Util/FSTClasses.h"

#include "Firestore/core/include/firebase/firestore/timestamp.h"
#include "Firestore/core/src/firebase/firestore/model/database_id.h"
#include "Firestore/core/src/firebase/firestore/model/document_key.h"
#include "Firestore/core/src/firebase/firestore/model/field_path.h"
#include "Firestore/core/src/firebase/firestore/nanopb/nanopb_util.h"
#include "Firestore/core/src/firebase/firestore/timestamp_internal.h"
#include "Firestore/core/src/firebase/firestore/util/comparison.h"
#include "Firestore/core/src/firebase/firestore/util/hard_assert.h"
#include "Firestore/core/src/firebase/firestore/util/string_apple.h"

namespace util = firebase::firestore::util;
using firebase::Timestamp;
using firebase::TimestampInternal;
using firebase::firestore::api::MakeFIRGeoPoint;
using firebase::firestore::api::MakeFIRTimestamp;
using firebase::firestore::model::DatabaseId;
using firebase::firestore::model::FieldMask;
using firebase::firestore::model::FieldPath;
using firebase::firestore::model::FieldValue;
using firebase::firestore::model::FieldValueOptions;
using firebase::firestore::model::ServerTimestampBehavior;
using firebase::firestore::nanopb::MakeNSData;
using firebase::firestore::util::Comparator;
using firebase::firestore::util::CompareMixedNumber;
using firebase::firestore::util::DoubleBitwiseEquals;
using firebase::firestore::util::DoubleBitwiseHash;
using firebase::firestore::util::MakeStringView;
using firebase::firestore::util::ReverseOrder;
using firebase::firestore::util::WrapCompare;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FSTFieldValue

@interface FSTFieldValue ()
- (NSComparisonResult)defaultCompare:(FSTFieldValue *)other;
@end

@implementation FSTFieldValue

@dynamic type;
@dynamic typeOrder;

- (FieldValue::Type)type {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (FSTTypeOrder)typeOrder {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (id)value {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (id)valueWithOptions:(const FieldValueOptions &)options {
  return [self value];
}

- (BOOL)isEqual:(id)other {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (NSUInteger)hash {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  @throw FSTAbstractMethodException();  // NOLINT
}

- (NSString *)description {
  return [[self value] description];
}

- (NSComparisonResult)defaultCompare:(FSTFieldValue *)other {
  if (self.typeOrder > other.typeOrder) {
    return NSOrderedDescending;
  } else {
    HARD_ASSERT(self.typeOrder < other.typeOrder,
                "defaultCompare should not be used for values of same type.");
    return NSOrderedAscending;
  }
}

- (int64_t)integerValue {
  return static_cast<FSTDelegateValue *>(self).internalValue.integer_value();
}

- (bool)isNAN {
  if (self.type != FieldValue::Type::Double) return false;
  return static_cast<FSTDelegateValue *>(self).internalValue.is_nan();
}

- (double)doubleValue {
  return static_cast<FSTDelegateValue *>(self).internalValue.double_value();
}

@end

#pragma mark - FSTServerTimestampValue

@implementation FSTServerTimestampValue {
  Timestamp _localWriteTime;
}

+ (instancetype)serverTimestampValueWithLocalWriteTime:(const Timestamp &)localWriteTime
                                         previousValue:(nullable FSTFieldValue *)previousValue {
  return [[FSTServerTimestampValue alloc] initWithLocalWriteTime:localWriteTime
                                                   previousValue:previousValue];
}

- (id)initWithLocalWriteTime:(const Timestamp &)localWriteTime
               previousValue:(nullable FSTFieldValue *)previousValue {
  self = [super init];
  if (self) {
    _localWriteTime = localWriteTime;
    _previousValue = previousValue;
  }
  return self;
}

- (FieldValue::Type)type {
  return FieldValue::Type::ServerTimestamp;
}

- (FSTTypeOrder)typeOrder {
  return FSTTypeOrderTimestamp;
}

- (id)value {
  return [NSNull null];
}

- (id)valueWithOptions:(const FieldValueOptions &)options {
  switch (options.server_timestamp_behavior()) {
    case ServerTimestampBehavior::kNone:
      return [NSNull null];
    case ServerTimestampBehavior::kEstimate:
      return [FieldValue::FromTimestamp(self.localWriteTime).Wrap() valueWithOptions:options];
    case ServerTimestampBehavior::kPrevious:
      return self.previousValue ? [self.previousValue valueWithOptions:options] : [NSNull null];
    default:
      HARD_FAIL("Unexpected server timestamp option: %s", options.server_timestamp_behavior());
  }
}

- (BOOL)isEqual:(id)other {
  return [other isKindOfClass:[FSTFieldValue class]] &&
         ((FSTFieldValue *)other).type == FieldValue::Type::ServerTimestamp &&
         self.localWriteTime == ((FSTServerTimestampValue *)other).localWriteTime;
}

- (NSUInteger)hash {
  return TimestampInternal::Hash(self.localWriteTime);
}

- (NSString *)description {
  return [NSString
      stringWithFormat:@"<ServerTimestamp localTime=%s>", self.localWriteTime.ToString().c_str()];
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  if (other.type == FieldValue::Type::ServerTimestamp) {
    return WrapCompare(self.localWriteTime, ((FSTServerTimestampValue *)other).localWriteTime);
  } else if (other.type == FieldValue::Type::Timestamp) {
    // Server timestamps come after all concrete timestamps.
    return NSOrderedDescending;
  } else {
    return [self defaultCompare:other];
  }
}

@end

#pragma mark - FSTReferenceValue

@interface FSTReferenceValue ()
@property(nonatomic, strong, readonly) FSTDocumentKey *key;
@end

@implementation FSTReferenceValue {
  DatabaseId _databaseID;
}

+ (instancetype)referenceValue:(FSTDocumentKey *)value databaseID:(DatabaseId)databaseID {
  return [[FSTReferenceValue alloc] initWithValue:value databaseID:std::move(databaseID)];
}

- (id)initWithValue:(FSTDocumentKey *)value databaseID:(DatabaseId)databaseID {
  self = [super init];
  if (self) {
    _key = value;
    _databaseID = std::move(databaseID);
  }
  return self;
}

- (id)value {
  return self.key;
}

- (FieldValue::Type)type {
  return FieldValue::Type::Reference;
}

- (FSTTypeOrder)typeOrder {
  return FSTTypeOrderReference;
}

- (BOOL)isEqual:(id)other {
  if (other == self) {
    return YES;
  }
  if (!([other isKindOfClass:[FSTFieldValue class]] &&
        ((FSTFieldValue *)other).type == FieldValue::Type::Reference)) {
    return NO;
  }

  FSTReferenceValue *otherRef = (FSTReferenceValue *)other;
  return self.key.key == otherRef.key.key && self.databaseID == otherRef.databaseID;
}

- (NSUInteger)hash {
  NSUInteger result = self.databaseID.Hash();
  result = 31 * result + [self.key hash];
  return result;
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  if (other.type == FieldValue::Type::Reference) {
    FSTReferenceValue *ref = (FSTReferenceValue *)other;
    NSComparisonResult cmp = WrapCompare(self.databaseID.project_id(), ref.databaseID.project_id());
    if (cmp != NSOrderedSame) {
      return cmp;
    }
    cmp = WrapCompare(self.databaseID.database_id(), ref.databaseID.database_id());
    return cmp != NSOrderedSame ? cmp : WrapCompare(self.key.key, ref.key.key);
  } else {
    return [self defaultCompare:other];
  }
}

@end

#pragma mark - FSTObjectValue

/**
 * Specialization of Comparator for NSStrings.
 */
static const NSComparator StringComparator = ^NSComparisonResult(NSString *left, NSString *right) {
  return WrapCompare(left, right);
};

@interface FSTObjectValue ()
@property(nonatomic, strong, readonly)
    FSTImmutableSortedDictionary<NSString *, FSTFieldValue *> *internalValue;
@end

@implementation FSTObjectValue

+ (instancetype)objectValue {
  static FSTObjectValue *sharedEmptyInstance = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    FSTImmutableSortedDictionary<NSString *, FSTFieldValue *> *empty =
        [FSTImmutableSortedDictionary dictionaryWithComparator:StringComparator];
    sharedEmptyInstance = [[FSTObjectValue alloc] initWithImmutableDictionary:empty];
  });
  return sharedEmptyInstance;
}

- (instancetype)initWithImmutableDictionary:
    (FSTImmutableSortedDictionary<NSString *, FSTFieldValue *> *)value {
  self = [super init];
  if (self) {
    _internalValue = value;  // FSTImmutableSortedDictionary is immutable.
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary<NSString *, FSTFieldValue *> *)value {
  FSTImmutableSortedDictionary<NSString *, FSTFieldValue *> *dictionary =
      [FSTImmutableSortedDictionary dictionaryWithDictionary:value comparator:StringComparator];
  return [self initWithImmutableDictionary:dictionary];
}

- (id)value {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self.internalValue
      enumerateKeysAndObjectsUsingBlock:^(NSString *key, FSTFieldValue *obj, BOOL *stop) {
        result[key] = [obj value];
      }];
  return result;
}

- (id)valueWithOptions:(const FieldValueOptions &)options {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self.internalValue
      enumerateKeysAndObjectsUsingBlock:^(NSString *key, FSTFieldValue *obj, BOOL *stop) {
        result[key] = [obj valueWithOptions:options];
      }];
  return result;
}

- (FieldValue::Type)type {
  return FieldValue::Type::Object;
}

- (FSTTypeOrder)typeOrder {
  return FSTTypeOrderObject;
}

- (BOOL)isEqual:(id)other {
  if (other == self) {
    return YES;
  }
  if (!([other isKindOfClass:[FSTFieldValue class]] &&
        ((FSTFieldValue *)other).type == FieldValue::Type::Object)) {
    return NO;
  }

  FSTObjectValue *otherObj = other;
  return [self.internalValue isEqual:otherObj.internalValue];
}

- (NSUInteger)hash {
  return [self.internalValue hash];
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  if (other.type == FieldValue::Type::Object) {
    FSTImmutableSortedDictionary *selfDict = self.internalValue;
    FSTImmutableSortedDictionary *otherDict = ((FSTObjectValue *)other).internalValue;
    NSEnumerator *enumerator1 = [selfDict keyEnumerator];
    NSEnumerator *enumerator2 = [otherDict keyEnumerator];
    NSString *key1 = [enumerator1 nextObject];
    NSString *key2 = [enumerator2 nextObject];
    while (key1 && key2) {
      NSComparisonResult keyCompare = [key1 compare:key2];
      if (keyCompare != NSOrderedSame) {
        return keyCompare;
      }
      NSComparisonResult valueCompare = [selfDict[key1] compare:otherDict[key2]];
      if (valueCompare != NSOrderedSame) {
        return valueCompare;
      }
      key1 = [enumerator1 nextObject];
      key2 = [enumerator2 nextObject];
    }
    // Only equal if both enumerators are exhausted.
    return WrapCompare(key1 != nil, key2 != nil);
  } else {
    return [self defaultCompare:other];
  }
}

- (nullable FSTFieldValue *)valueForPath:(const FieldPath &)fieldPath {
  FSTFieldValue *value = self;
  for (size_t i = 0, max = fieldPath.size(); value && i < max; i++) {
    if (![value isMemberOfClass:[FSTObjectValue class]]) {
      return nil;
    }

    NSString *fieldName = util::WrapNSStringNoCopy(fieldPath[i]);
    value = ((FSTObjectValue *)value).internalValue[fieldName];
  }

  return value;
}

- (FSTObjectValue *)objectBySettingValue:(FSTFieldValue *)value
                                 forPath:(const FieldPath &)fieldPath {
  HARD_ASSERT(fieldPath.size() > 0, "Cannot set value with an empty path");

  NSString *childName = util::WrapNSString(fieldPath.first_segment());
  if (fieldPath.size() == 1) {
    // Recursive base case:
    return [self objectBySettingValue:value forField:childName];
  } else {
    // Nested path. Recursively generate a new sub-object and then wrap a new FSTObjectValue
    // around the result.
    FSTFieldValue *child = [_internalValue objectForKey:childName];
    FSTObjectValue *childObject;
    if (child.type == FieldValue::Type::Object) {
      childObject = (FSTObjectValue *)child;
    } else {
      // If the child is not found or is a primitive type, pretend as if an empty object lived
      // there.
      childObject = [FSTObjectValue objectValue];
    }
    FSTFieldValue *newChild = [childObject objectBySettingValue:value forPath:fieldPath.PopFirst()];
    return [self objectBySettingValue:newChild forField:childName];
  }
}

- (FSTObjectValue *)objectByDeletingPath:(const FieldPath &)fieldPath {
  HARD_ASSERT(fieldPath.size() > 0, "Cannot delete an empty path");
  NSString *childName = util::WrapNSString(fieldPath.first_segment());
  if (fieldPath.size() == 1) {
    return [[FSTObjectValue alloc]
        initWithImmutableDictionary:[_internalValue dictionaryByRemovingObjectForKey:childName]];
  } else {
    FSTFieldValue *child = _internalValue[childName];
    if (child.type == FieldValue::Type::Object) {
      FSTObjectValue *newChild =
          [((FSTObjectValue *)child) objectByDeletingPath:fieldPath.PopFirst()];
      return [self objectBySettingValue:newChild forField:childName];
    } else {
      // If the child is not found or is a primitive type, make no modifications
      return self;
    }
  }
}

- (FSTObjectValue *)objectBySettingValue:(FSTFieldValue *)value forField:(NSString *)field {
  return [[FSTObjectValue alloc]
      initWithImmutableDictionary:[_internalValue dictionaryBySettingObject:value forKey:field]];
}

- (FSTObjectValue *)objectByApplyingFieldMask:(const FieldMask &)fieldMask {
  FSTObjectValue *filteredObject = self;
  for (const FieldPath &path : fieldMask) {
    if (path.empty()) {
      return self;
    } else {
      FSTFieldValue *newValue = [self valueForPath:path];
      if (newValue) {
        filteredObject = [filteredObject objectBySettingValue:newValue forPath:path];
      }
    }
  }
  return filteredObject;
}

@end

@interface FSTArrayValue ()
@property(nonatomic, strong, readonly) NSArray<FSTFieldValue *> *internalValue;
@end

#pragma mark - FSTArrayValue

@implementation FSTArrayValue

- (id)initWithValueNoCopy:(NSArray<FSTFieldValue *> *)value {
  self = [super init];
  if (self) {
    // Does not copy, assumes the caller has already copied.
    _internalValue = value;
  }
  return self;
}

- (BOOL)isEqual:(id)other {
  if (other == self) {
    return YES;
  }
  if (![other isKindOfClass:[self class]]) {
    return NO;
  }

  // NSArray's isEqual does the right thing for our purposes.
  FSTArrayValue *otherArray = other;
  return [self.internalValue isEqual:otherArray.internalValue];
}

- (NSUInteger)hash {
  return [self.internalValue hash];
}

- (id)value {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:_internalValue.count];
  [self.internalValue enumerateObjectsUsingBlock:^(FSTFieldValue *obj, NSUInteger idx, BOOL *stop) {
    [result addObject:[obj value]];
  }];
  return result;
}

- (id)valueWithOptions:(const FieldValueOptions &)options {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:_internalValue.count];
  [self.internalValue enumerateObjectsUsingBlock:^(FSTFieldValue *obj, NSUInteger idx, BOOL *stop) {
    [result addObject:[obj valueWithOptions:options]];
  }];
  return result;
}

- (FieldValue::Type)type {
  return FieldValue::Type::Array;
}

- (FSTTypeOrder)typeOrder {
  return FSTTypeOrderArray;
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  if (other.type == FieldValue::Type::Array) {
    NSArray<FSTFieldValue *> *selfArray = self.internalValue;
    NSArray<FSTFieldValue *> *otherArray = ((FSTArrayValue *)other).internalValue;
    NSUInteger minLength = MIN(selfArray.count, otherArray.count);
    for (NSUInteger i = 0; i < minLength; i++) {
      NSComparisonResult cmp = [selfArray[i] compare:otherArray[i]];
      if (cmp != NSOrderedSame) {
        return cmp;
      }
    }
    return WrapCompare<int64_t>(selfArray.count, otherArray.count);
  } else {
    return [self defaultCompare:other];
  }
}

@end

@implementation FSTDelegateValue {
  FieldValue _internalValue;
}

+ (instancetype)delegateWithValue:(FieldValue &&)value {
  return [[FSTDelegateValue alloc] initWithValue:std::move(value)];
}

- (const FieldValue &)internalValue {
  return _internalValue;
}

- (id)initWithValue:(FieldValue &&)value {
  self = [super init];
  if (self) {
    _internalValue = std::move(value);
  }
  return self;
}

- (FieldValue::Type)type {
  return self.internalValue.type();
}

- (FSTTypeOrder)typeOrder {
  switch (self.internalValue.type()) {
    case FieldValue::Type::Null:
      return FSTTypeOrderNull;
    case FieldValue::Type::Boolean:
      return FSTTypeOrderBoolean;
    case FieldValue::Type::Integer:
    case FieldValue::Type::Double:
      return FSTTypeOrderNumber;
    case FieldValue::Type::Timestamp:
    case FieldValue::Type::ServerTimestamp:
      return FSTTypeOrderTimestamp;
    case FieldValue::Type::String:
      return FSTTypeOrderString;
    case FieldValue::Type::Blob:
      return FSTTypeOrderBlob;
    case FieldValue::Type::Reference:
      return FSTTypeOrderReference;
    case FieldValue::Type::GeoPoint:
      return FSTTypeOrderGeoPoint;
    case FieldValue::Type::Array:
      return FSTTypeOrderArray;
    case FieldValue::Type::Object:
      return FSTTypeOrderObject;
  }
  UNREACHABLE();
}

- (BOOL)isEqual:(id)other {
  // TODO(rsgowman): Port the other FST*Value's, and then remove this comment:
  //
  // Simplification: We'll assume that (eg) FSTBooleanValue(true) !=
  // FSTDelegateValue(FieldValue::FromBoolean(true)). That's not great. We'll
  // handle this by ensuring that we remove (eg) FSTBooleanValue at the same
  // time that FSTDelegateValue handles (eg) booleans to ensure this case never
  // occurs.

  if (other == self) {
    return YES;
  }
  if (![other isKindOfClass:[self class]]) {
    return NO;
  }

  return self.internalValue == ((FSTDelegateValue *)other).internalValue;
}

- (id)value {
  switch (self.internalValue.type()) {
    case FieldValue::Type::Null:
      return [NSNull null];
    case FieldValue::Type::Boolean:
      return self.internalValue.boolean_value() ? @YES : @NO;
    case FieldValue::Type::Integer:
      return @(self.internalValue.integer_value());
    case FieldValue::Type::Double:
      return @(self.internalValue.double_value());
    case FieldValue::Type::Timestamp: {
      auto timestamp = self.internalValue.timestamp_value();
      return [[FIRTimestamp alloc] initWithSeconds:timestamp.seconds()
                                       nanoseconds:timestamp.nanoseconds()];
    }
    case FieldValue::Type::ServerTimestamp:
      HARD_FAIL("TODO(rsgowman): implement");
    case FieldValue::Type::String:
      return util::WrapNSString(self.internalValue.string_value());
    case FieldValue::Type::Blob:
      return MakeNSData(self.internalValue.blob_value());
    case FieldValue::Type::Reference:
      HARD_FAIL("TODO(rsgowman): implement");
    case FieldValue::Type::GeoPoint:
      return MakeFIRGeoPoint(self.internalValue.geo_point_value());
    case FieldValue::Type::Array:
    case FieldValue::Type::Object:
      HARD_FAIL("TODO(rsgowman): implement");
  }
  UNREACHABLE();
}

- (id)valueWithOptions:(const model::FieldValueOptions &)options {
  switch (self.internalValue.type()) {
    case FieldValue::Type::Timestamp:
      if (options.timestamps_in_snapshots_enabled()) {
        return [self value];
      } else {
        return [[self value] dateValue];
      }

    default:
      return [self value];
  }
}

- (NSComparisonResult)compare:(FSTFieldValue *)other {
  // TODO(rsgowman): Port the other FST*Value's, and then remove this comment:
  //
  // Simplification: We'll assume that if Comparable(self.type, other.type),
  // then other must be a FSTDelegateValue. That's not great. We'll handle this
  // by ensuring that we remove (eg) FSTBooleanValue at the same time that
  // FSTDelegateValue handles (eg) booleans to ensure this case never occurs.

  if (FieldValue::Comparable(self.type, other.type)) {
    if ([other isKindOfClass:[FSTServerTimestampValue class]]) {
      HARD_ASSERT(self.type == FieldValue::Type::Timestamp);
      // Server timestamps come after all concrete timestamps.
      return NSOrderedAscending;
    } else {
      HARD_ASSERT([other isKindOfClass:[FSTDelegateValue class]]);
      return WrapCompare<FieldValue>(self.internalValue, ((FSTDelegateValue *)other).internalValue);
    }
  } else {
    return [self defaultCompare:other];
  }
}

- (NSUInteger)hash {
  return self.internalValue.Hash();
}

@end

NS_ASSUME_NONNULL_END
