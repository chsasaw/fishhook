/*
 *  Copyright (c) 2016-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import <XCTest/XCTest.h>

#include "fishhook.h"

static __typeof__(&atoi) orig_atoi;

static int fast_atoi(const char *str)
{
  return str[0] - '0';
}

static __typeof__(&atof) orig_atof;

static double fast_atof(const char *str)
{
  return (double)(str[0] - '0');
}

@interface FishhookTests : XCTestCase
@end

@implementation FishhookTests

- (void)testHookNamespacedAtoi
{
  rebind_symbols((struct rebinding[1]){{"atoi", "/usr/lib/libSystem.dylib", fast_atoi, (void *)&orig_atoi}}, 1);
  XCTAssertEqual(atoi("1"), 1);
  XCTAssertNotEqual(atoi("12"), 12);
}

- (void)testHookGlobalAtof
{
  rebind_symbols((struct rebinding[1]){{"atof", NULL, fast_atof, (void *)&orig_atof}}, 1);
  XCTAssertEqual(atof("1"), 1.0);
  XCTAssertNotEqual(atof("1.2"), 1.2);
}

@end
