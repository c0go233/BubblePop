#import "ScoreViewController.h"

typedef enum { NAME, SCORE } dataIndexes;

@interface ScoreViewController () {
    NSMutableArray *nameArray;
    NSMutableArray *scoreArray;
}

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setArrays];
    [self sortArray];
}

-(void)sortArray {
    NSString *fileDirect = [self getFileDirectoryForFileName:@"scores.csv"];
        [self getDataWordByWordFromFile:fileDirect];
        [self sortInDescendingOrder];
}

-(void)sortInDescendingOrder {
    for (int i = 0; i < [scoreArray count] - 1; i++) {
        NSArray *tempSubArray = [scoreArray subarrayWithRange:NSMakeRange(i, [scoreArray count] - i)];
        int highestObjectIndex = (int)[self getHighestObjectIndexInArray:tempSubArray] + i;
        [self switchObjectFromIndex: highestObjectIndex ToIndex: i InArray: scoreArray];
        [self switchObjectFromIndex: highestObjectIndex ToIndex: i InArray: nameArray];
    }
}

-(void)getDataWordByWordFromFile: (NSString*)fileDirect {
    NSString *file = [[NSString alloc] initWithContentsOfFile: fileDirect encoding: NSUTF8StringEncoding error: nil];
    NSArray *tempLineArray = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in tempLineArray) {
        if (![line isEqualToString:@""]) {
            NSArray *tempWordArray = [line componentsSeparatedByString:@","];
            [nameArray addObject:[tempWordArray objectAtIndex:NAME]];
            [scoreArray addObject: [tempWordArray objectAtIndex:SCORE]];
        }
    }
}

-(NSString*)getFileDirectoryForFileName: (NSString*)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileDirect = [docPath stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileDirect]) {
        return nil;
    }
    return fileDirect;
}

-(void)setArrays {
    nameArray = [[NSMutableArray alloc] init];
    scoreArray = [[NSMutableArray alloc] init];
}

-(int)getHighestObjectIndexInArray: (NSArray*)array {
    int firstObjectIntegerValue = (int)[[array objectAtIndex:0] integerValue];
    int highestObjectIndex = 0;
    for (int i = 1; i < [array count]; i++) {
        if ([[array objectAtIndex:i] integerValue] > firstObjectIntegerValue) {
            firstObjectIntegerValue = (int)[[array objectAtIndex:i] integerValue];
            highestObjectIndex = i;
        }
    }
    return highestObjectIndex;
}

-(void)switchObjectFromIndex: (int)fromIndex ToIndex: (int)toIndex InArray: (NSMutableArray*)array{
    NSString *toIndexObject = [array objectAtIndex:toIndex];
    [array replaceObjectAtIndex:toIndex withObject:[array objectAtIndex:fromIndex]];
    [array replaceObjectAtIndex:fromIndex withObject:toIndexObject];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scoreArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [scoreArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
