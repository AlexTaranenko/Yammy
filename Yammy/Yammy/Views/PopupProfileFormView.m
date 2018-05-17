//
//  PopupProfileFormView.m
//  Yammy
//
//  Created by Alex on 10/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PopupProfileFormView.h"
#import "PopupProfileFormTableViewCell.h"

static NSInteger const kTitleCellRow = 0;
static CGFloat const kTopAndButtonsHeight = 43.f;
static CGFloat const kCellHeight = 44.f;
static NSInteger const kMaxCountOfItemsArray = 6;
static CGFloat const kMargin = 15.f;

@interface PopupProfileFormView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutContainerHeight;

@property (strong, nonatomic) NSArray *interestsArray;
@property (strong, nonatomic) NSString *titleRow;
@property (strong, nonatomic) NSNumber *selectAnswerId;

@property (strong, nonatomic) InterestMapping *mapping;
@property (strong, nonatomic) DictionaryMapping *characterDictionaryMapping;
@property (strong, nonatomic) DictionaryMapping *genderDictionaryMapping;

@property (strong, nonatomic) NSMutableArray *addedInterests;

@property (strong, nonatomic) NSMutableArray *addedTraits;

@property (strong, nonatomic) NSMutableArray *addedInterestedGenders;

@end

@implementation PopupProfileFormView

+ (PopupProfileFormView *)createInterestPopupProfileFormView {
    PopupProfileFormView *popupProfileFormView = [PopupProfileFormView createPopup];
    popupProfileFormView.addedInterests = [NSMutableArray new];
    [popupProfileFormView setupInterestTableViewCells];
    return popupProfileFormView;
}

+ (PopupProfileFormView *)createPopupProfileFormView {
    PopupProfileFormView *popupProfileFormView = [PopupProfileFormView createPopup];
    popupProfileFormView.selectAnswerId = nil;
    [popupProfileFormView setupTableViewCells];
    return popupProfileFormView;
}

+ (PopupProfileFormView *)createCharacterPopupProfileFormView {
    PopupProfileFormView *popupProfileFormView = [PopupProfileFormView createPopup];
    popupProfileFormView.addedTraits = [NSMutableArray new];
    [popupProfileFormView setupTableViewCells];
    return popupProfileFormView;
}

+ (PopupProfileFormView *)createInterestedGendersPopupProfileFormView {
    PopupProfileFormView *popupProfileFormView = [PopupProfileFormView createPopup];
    popupProfileFormView.addedInterestedGenders = [NSMutableArray new];
    [popupProfileFormView setupTableViewCells];
    return popupProfileFormView;
}


+ (PopupProfileFormView *)createPopup {
    PopupProfileFormView *popupProfileFormView = (PopupProfileFormView *)[[[NSBundle mainBundle] loadNibNamed:@"PopupProfileFormView" owner:self options:nil] firstObject];
    popupProfileFormView.frame = [UIScreen mainScreen].bounds;
    return popupProfileFormView;
}

#pragma mark - Public

- (void)loadInterestsByMapping:(InterestsMapping *)interestsMapping {
    self.titleRow = interestsMapping.Group;
    self.interestsArray = interestsMapping.Items;
    [self.addedInterests addObjectsFromArray:self.selectedInterests];
    self.layoutContainerHeight.constant = kTopAndButtonsHeight + kCellHeight * (self.addedInterests.count - 1) + kMargin;
    [self.tableView reloadData];
}

- (void)loadSelectedTraitsByArray:(NSArray *)selectedTraits {
    [self.addedTraits addObjectsFromArray:selectedTraits];
}

- (void)loadSelectedGendersByArray:(NSArray *)selectedGenders {
    [self.addedInterestedGenders addObjectsFromArray:selectedGenders];
}

- (void)calculateHeight {
    int itemsCount = (int)self.interestsArray.count > 0 ? (int)self.interestsArray.count + 1 /*for header*/ : (int)self.answersArray.count;
    
    if (itemsCount > kMaxCountOfItemsArray) {
        self.layoutContainerHeight.constant = kTopAndButtonsHeight + kCellHeight * kMaxCountOfItemsArray + kMargin;
        self.tableView.scrollEnabled = YES;
    } else {
        self.layoutContainerHeight.constant = kTopAndButtonsHeight + kCellHeight * itemsCount + kMargin;
        self.tableView.scrollEnabled = NO;
    }
}

#pragma mark - Table View

- (void)setupInterestTableViewCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormTitleCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupTableViewCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.answersArray.count > 0) {
        return self.answersArray.count;
    } else {
        if (self.interestsArray != nil) {
            return self.interestsArray.count + 1;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.answersArray.count > 0) {
        PopupProfileFormTableViewCell *popupProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
        DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
        popupProfileFormCell.dictionaryMapping = dictionaryMapping;
        if (self.selectAnswerId != nil) {
            [popupProfileFormCell compareFirstId:dictionaryMapping.IdDictionary toSecondId:self.selectAnswerId];
        } else {
            if (self.addedTraits != nil) {
                [self preparePopupProfileFormTableViewCellByIndexPath:indexPath andAddedArray:self.addedTraits andCell:popupProfileFormCell];
            } else if (self.addedInterestedGenders != nil) {
                [self preparePopupProfileFormTableViewCellByIndexPath:indexPath andAddedArray:self.addedInterestedGenders andCell:popupProfileFormCell];
            } else {
                [popupProfileFormCell prepareIconImageViewByPublicProfileAboutMeModel:self.publicProfileAboutMeModel andIndexPath:self.indexPath];
            }
        }
        [popupProfileFormCell prepareSecondTitleByText:dictionaryMapping.Title];
        return popupProfileFormCell;
    } else {
        if (indexPath.row == kTitleCellRow) {
            PopupProfileFormTableViewCell *popupProfileFormTitleCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormTitleCellIdentifier];
            [popupProfileFormTitleCell prepareTitleByText:self.titleRow];
            return popupProfileFormTitleCell;
        } else {
            PopupProfileFormTableViewCell *popupProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
            InterestMapping *mapping = [self.interestsArray objectAtIndex:indexPath.row - 1];
            NSArray *filteredArray = [self.addedInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdInterest == %@", mapping.IdInterest]];
            [popupProfileFormCell prepareInterestIconImageViewBySelected:filteredArray.count > 0 ? YES : NO];
            [popupProfileFormCell prepareSecondTitleByText:mapping.Title];
            return popupProfileFormCell;
        }
    }
}

- (void)preparePopupProfileFormTableViewCellByIndexPath:(NSIndexPath *)indexPath andAddedArray:(NSArray *)addedArray andCell:(PopupProfileFormTableViewCell *)cell {
    DictionaryMapping *mapping = [self.answersArray objectAtIndex:indexPath.row];
    NSArray *filteredArray = [addedArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
    [cell prepareInterestIconImageViewBySelected:filteredArray.count > 0 ? YES : NO];
    [cell prepareSecondTitleByText:mapping.Title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.answersArray.count > 0) {
        if (self.addedTraits != nil) {
            self.characterDictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
            NSArray *filteredArray = [self.addedTraits filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", self.characterDictionaryMapping.IdDictionary]];
            if (filteredArray.count > 0) {
                DictionaryMapping *mapping = [filteredArray firstObject];
                NSInteger index = [self.addedTraits indexOfObject:mapping];
                [self.addedTraits removeObjectAtIndex:index];
            } else {
                [self.addedTraits addObject:self.characterDictionaryMapping];
            }
            
            [self.tableView reloadData];
        } else if (self.addedInterestedGenders != nil) {
            self.genderDictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
            NSArray *filteredArray = [self.addedInterestedGenders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", self.genderDictionaryMapping.IdDictionary]];
            if (filteredArray.count > 0) {
                DictionaryMapping *mapping = [filteredArray firstObject];
                NSInteger index = [self.addedInterestedGenders indexOfObject:mapping];
                [self.addedInterestedGenders removeObjectAtIndex:index];
            } else {
                [self.addedInterestedGenders addObject:self.genderDictionaryMapping];
            }
            
            [self.tableView reloadData];
        } else {
            DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
            self.selectAnswerId = dictionaryMapping.IdDictionary;
            [self.tableView reloadData];
        }
    } else {
        if (indexPath.row != kTitleCellRow) {
            self.mapping = [self.interestsArray objectAtIndex:indexPath.row - 1];
            
            NSArray *filteredArray = [self.addedInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdInterest == %@", self.mapping.IdInterest]];
            if (filteredArray.count > 0) {
                InterestMapping *mapping = [filteredArray firstObject];
                NSInteger index = [self.addedInterests indexOfObject:mapping];
                [self.addedInterests removeObjectAtIndex:index];
            } else {
                [self.addedInterests addObject:self.mapping];
            }
            
            [self.tableView reloadData];
        }
    }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
    [self hidePopup];
}

- (IBAction)okDidTap:(UIButton *)sender {
    if (self.delegate != nil) {
        if (self.answersArray.count > 0 && self.selectAnswerId != nil) {
            [self.delegate selectAnswerBySelectAnswerId:self.selectAnswerId andIndexPath:self.indexPath];
        } else if (self.answersArray.count > 0 && self.addedTraits != nil) {
            [self.delegate selectCharacterBySelectedArray:[self.addedTraits copy] andIndexPath:self.indexPath];
        } else if (self.answersArray.count > 0 && self.addedInterestedGenders != nil) {
            [self.delegate selectInterestedGendersBySelectedArray:[self.addedInterestedGenders copy] andIndexPath:self.indexPath];
        } else {
            [self.delegate selectInterestBySelectedArray:[self.addedInterests copy] andIndexPath:self.indexPath];
        }
    }
    [self hidePopup];
}

- (void)hidePopup {
    if (self.delegate != nil) {
        [self.delegate dismissPopupProfileFormView];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

