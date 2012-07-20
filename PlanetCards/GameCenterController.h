/*
 
 File: GameCenterController.h
 
 */

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "GameCenterManager.h"

@class GameCenterManager;
@interface GameCenterController :  UITableViewController <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate>
{   
    GameCenterManager* gameCenterManager;
    
    IBOutlet UIView* resetAchievementsView;
    IBOutlet UIButton* achievementButton;
    
    NSString* personalBestScoreDescription;
    NSString* personalBestScoreString;
    
    NSString* leaderboardHighScoreDescription;
    NSString* leaderboardHighScoreString;
    
    NSString* currentLeaderBoard;
    
    int64_t  currentScore;
    NSString* cachedHighestScore;
    
    
}
@property (nonatomic, retain) GameCenterManager *gameCenterManager;

@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* cachedHighestScore;


@property (nonatomic, retain) UIView* resetAchievementsView;
@property (nonatomic, retain) UIView* gameButtonView;

@property (nonatomic, retain) NSString* personalBestScoreDescription;
@property (nonatomic, retain) NSString* personalBestScoreString;
@property (nonatomic, retain) NSString* leaderboardHighScoreDescription;
@property (nonatomic, retain) NSString* leaderboardHighScoreString;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (IBAction) resetAchievements: (id) sender;

- (void) addOne;
- (void) submitHighScore;
- (void) showLeaderboard;
- (void) showAchievements;
@end