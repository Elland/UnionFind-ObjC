#import "Testing.h"
#import "UnionFindNode.h"

@interface UnionFindNodeTest : XCTestCase
@end

@implementation UnionFindNodeTest

-(void)compareAgainstReferenceWithOperations:(NSArray*)operations andCount:(int)count {
    NSMutableArray* sets = [NSMutableArray new];
    NSMutableArray* nodes = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        NSMutableSet* s = [NSMutableSet new];
        [s addObject:@(i)];
        [sets addObject:s];
        [nodes addObject:[UnionFindNode new]];
    }
    
    for (NSArray* op in operations) {
        assert(op.count == 3);
        bool isCompareElseUnion = ((NSNumber*)op[0]).boolValue;
        NSUInteger i1 = ((NSNumber*)op[1]).unsignedIntegerValue;
        NSUInteger i2 = ((NSNumber*)op[2]).unsignedIntegerValue;
        
        UnionFindNode* node1 = nodes[i1];
        UnionFindNode* node2 = nodes[i2];
        NSMutableSet* set1 = sets[i1];
        NSMutableSet* set2 = sets[i2];
        
        if (isCompareElseUnion) {
            bool isSame = node1.currentRepresentative == node2.currentRepresentative;
            bool isSame2 = [node1 isInSameSetAs:node2];
            bool isSameRef = set1 == set2;
            test(isSame == isSameRef);
            test(isSame2 == isSameRef);
        } else {
            [node1 unionWith:node2];
            if (set1 != set2) {
                for (NSNumber* e in set1) {
                    [set2 addObject:e];
                    sets[e.unsignedIntegerValue] = set2;
                }
            }
        }
    }
}

-(void)testTrivial {
    UnionFindNode* r1 = [UnionFindNode new];
    UnionFindNode* r2 = [UnionFindNode new];
    
    test([r1 isInSameSetAs:r1]);
    test([r2 isInSameSetAs:r2]);
    test(![r1 isInSameSetAs:r2]);
    
    [r1 unionWith:r2];
    test([r1 isInSameSetAs:r1]);
    test([r2 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r2]);
}
-(void)testTrivial2 {
    UnionFindNode* r1 = [UnionFindNode new];
    UnionFindNode* r2 = [UnionFindNode new];
    UnionFindNode* r3 = [UnionFindNode new];
    test(![r1 isInSameSetAs:r2]);
    test(![r1 isInSameSetAs:r3]);
    test(![r2 isInSameSetAs:r3]);
    
    [r1 unionWith:r3];
    test(![r1 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r3]);
    test(![r2 isInSameSetAs:r3]);
    
    [r1 unionWith:r2];
    test([r1 isInSameSetAs:r2]);
    test([r1 isInSameSetAs:r3]);
    test([r2 isInSameSetAs:r3]);
}
-(void)testChain {
    NSMutableArray* r = [NSMutableArray new];
    for (int repeat = 0; repeat < 100; repeat++) {
        [r addObject:[UnionFindNode new]];
        [r.lastObject unionWith:r.firstObject];
        for (UnionFindNode* e1 in r) {
            for (UnionFindNode* e2 in r) {
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
