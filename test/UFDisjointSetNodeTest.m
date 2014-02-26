#import "Testing.h"
#import "UFDisjointSetNode.h"

@interface UFDisjointSetNodeTest : XCTestCase
@end

@implementation UFDisjointSetNodeTest

-(void)compareAgainstReferenceWithOperations:(NSArray*)operations andCount:(int)count {
    NSMutableArray* sets = [NSMutableArray new];
    NSMutableArray* nodes = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSMutableSet* s = [NSMutableSet new];
        [s addObject:@(i)];
        [sets addObject:s];
        [nodes addObject:[UFDisjointSetNode new]];
    }
    
    for (NSArray* op in operations) {
        assert(op.count == 3);
        bool isCompareElseUnion = ((NSNumber*)op[0]).boolValue;
        NSUInteger i1 = ((NSNumber*)op[1]).unsignedIntegerValue;
        NSUInteger i2 = ((NSNumber*)op[2]).unsignedIntegerValue;
        
        UFDisjointSetNode* node1 = nodes[i1];
        UFDisjointSetNode* node2 = nodes[i2];
        NSMutableSet* set1 = sets[i1];
        NSMutableSet* set2 = sets[i2];
        
        if (isCompareElseUnion) {
            bool isSame = node1.currentRepresentative == node2.currentRepresentative;
            bool isSame2 = [node1 isInSameSetAs:node2];
            bool isSameRef = set1 == set2;
            test(isSame == isSameRef);
            test(isSame2 == isSameRef);
        } else {
            bool didUnion = [node1 unionWith:node2];
            bool shouldUnion = set1 != set2;
            test(didUnion == shouldUnion);
            if (shouldUnion) {
                for (NSNumber* e in set1) {
                    [set2 addObject:e];
                    sets[e.unsignedIntegerValue] = set2;
                }
            }
        }
    }
}

-(void)testTrivialUnion {
    UFDisjointSetNode* r1 = [UFDisjointSetNode new];
    test(r1.currentRepresentative == r1.currentRepresentative);
    test(![r1 unionWith:r1]);
    
    UFDisjointSetNode* r2 = [UFDisjointSetNode new];
    test([r1 unionWith:r2]);
    test(![r1 unionWith:r2]);
    
    UFDisjointSetNode* r3 = [UFDisjointSetNode new];
    test([r1 unionWith:r3]);
    test(![r2 unionWith:r3]);
}
-(void)testTrivialRepresentative {
    UFDisjointSetNode* r1 = [UFDisjointSetNode new];
    test(r1.currentRepresentative == r1.currentRepresentative);

    UFDisjointSetNode* r2 = [UFDisjointSetNode new];
    test(r2.currentRepresentative == r2.currentRepresentative);
    test(r1.currentRepresentative != r2.currentRepresentative);

    test([r1 unionWith:r2]);
    test(r1.currentRepresentative == r1.currentRepresentative);
    test(r2.currentRepresentative == r2.currentRepresentative);
    test(r1.currentRepresentative == r2.currentRepresentative);

    UFDisjointSetNode* r3 = [UFDisjointSetNode new];
    test(r1.currentRepresentative != r3.currentRepresentative);
    
    [r1 unionWith:r3];
    test(r1.currentRepresentative == r3.currentRepresentative);
    test(r2.currentRepresentative == r3.currentRepresentative);
}
-(void)testTrivial {
    UFDisjointSetNode* r1 = [UFDisjointSetNode new];
    UFDisjointSetNode* r2 = [UFDisjointSetNode new];
    
    test([r1 isInSameSetAs:r1]);
    test([r2 isInSameSetAs:r2]);
    test(![r1 isInSameSetAs:r2]);
    
    test([r1 unionWith:r2]);
    test([r1 isInSameSetAs:r1]);
    test([r2 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r2]);
}
-(void)testTrivial2 {
    UFDisjointSetNode* r1 = [UFDisjointSetNode new];
    UFDisjointSetNode* r2 = [UFDisjointSetNode new];
    UFDisjointSetNode* r3 = [UFDisjointSetNode new];
    test(![r1 isInSameSetAs:r2]);
    test(![r1 isInSameSetAs:r3]);
    test(![r2 isInSameSetAs:r3]);
    
    test([r1 unionWith:r3]);
    test(![r1 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r3]);
    test(![r2 isInSameSetAs:r3]);
    
    test([r1 unionWith:r2]);
    test([r1 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r3]);
    test([r2 isInSameSetAs:r3]);
}
-(void)testChain {
    NSMutableArray* r = [NSMutableArray new];
    [r addObject:[UFDisjointSetNode new]];
    for (int repeat = 0; repeat < 100; repeat++) {
        [r addObject:[UFDisjointSetNode new]];
        test([r.lastObject unionWith:r.firstObject]);
        for (UFDisjointSetNode* e1 in r) {
            for (UFDisjointSetNode* e2 in r) {
                test([e1 isInSameSetAs:e2]);
            }
        }
    }
}

-(void)testRandomizedOperationsAgainstReferenceImplementation {
    const int n = 1000;
    const int uni = 200;
    const int cmpPerUni = 20;
    for (int repeat = 0; repeat < 10; repeat++) {
        NSMutableArray* ops = [NSMutableArray new];
        for (int i = 0; i < uni*cmpPerUni; i++) {
            bool compareElseUnion = i % cmpPerUni == 0;
            NSUInteger i1 = arc4random_uniform(n);
            NSUInteger i2 = arc4random_uniform(n);
            [ops addObject:@[@(compareElseUnion), @(i1), @(i2)]];
        }
        [self compareAgainstReferenceWithOperations:ops andCount:n];
    }
}

@end
