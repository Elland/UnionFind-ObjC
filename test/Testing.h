#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

#define test(expressionExpectedToBeTrue) XCTAssertTrue(expressionExpectedToBeTrue, @"")
#define testThrows(expressionExpectedToThrow) XCTAssertThrows(expressionExpectedToThrow, @"")
