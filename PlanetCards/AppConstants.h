//
//  AppConstants.h
//  HighCountryNews
//
//  Created by Beaudry on 11/14/10.
//  Copyright 2011 Better World Coding. All rights reserved.
//

// DEBUGGING
//#define DEBUG_

// views
#define kMainScrollViewTag 100
#define kInfoViewTag 200
#define kCardViewWidth 299.0
#define kCardViewHeight 377.0
#define kActivityIndicatorViewTag 29

// XML parsing
#define kXmlDataFile @"xmlDataFile"
#define kRoot @"object_data"
#define kFactItem @"fact_item"
#define kSatellites @"satellites"
#define kSatellite @"satellite"
#define kName @"name"
#define kType @"type"
#define kTeaser @"teaser"
#define kFactoids @"factoids"
#define kMass @"mass"
#define kDiameter @"diameter"
#define kDensity @"density"
#define kSpeed @"speed"
#define kDayLength @"daylength"
#define kTemperature @"temperature"
#define kSunDistance @"sundistance"
#define kImage @"image"
#define kTabImage @"tab_image"
#define kSatelliteImage @"satellite_image"
#define kSatelliteTabImage @"satellite_tab_image"
#define kCometType @"Comet"
#define kAsteroidType @"Asteroid"
#define kHaleBopp @"Hale-Bopp"
#define kCeres @"Ceres"
#define kHalley @"Halley"
#define kShoemakerLevy @"Shoemaker-Levy 9"
#define kTemple @"Temple 1"
#define kNumberOfCometsLessHaleBopp 3
#define kNumberOfAsteroids 5
#define kSupplement @"supplement"

// QUIZ PARSING
#define kQuizItem @"quiz_item"
#define kLevel @"level"
#define kQuestion @"question"
#define kWrongAnswer @"wrong_answer"
#define kRightAnswer @"right_answer"
#define kQuizDBLoaded @"quiz loaded"

// QUIZ VIEW MANIPULATION
#define kFrontCard 0
#define kBackCard 1
#define kNumberOfQuestions 20
#define kDefaultQuestionIntervalInSeconds 20
#define kAnswerLossIntervalInSeconds 5
#define kQuestionIntervalForTwoAnswersInSeconds 5

// QUIZ LOGIC
#define kLastScoreKey @"lastScore"
#define kLastDifficultyLevelKey @"lastDifficultyLevel"
#define kMinimumDifficultyLevel 1
#define kMaximumDifficultyLevel 10
#define kMaximumDifficultyLevel_lite 5
#define kLastStartingQuestionNumberKey @"lastStartingQuestionNumber"
#define kMaximumQuizPlaysBeforeRepeatCorrectAnswered 5
#define kQuestionsAnsweredCorrectlyKey @"questionsAnsweredCorrectlyKey"
#define kQuizDataFilename @"quizData"
#define RANDOM_SELECTION

// SCORING
#define kIncorrectDelay 1.0
#define kCorrectDelay 0.5
#define kFirstAnswerBlock 5
#define kSecondAnswerBlock 10
#define kThirdAnswerBlock 15
#define kFourthAnswerBlock 20
#define kNumberOfTimeBlocks 4.0

// PREFERENCES
#define kResetPreference @"kResetPreference"
#define kUnitPreference @"kUnitPreference"
#define kConvenientUnits @"Convenient"
#define kSIUnits @"SI"
#define kEarthUnits @"Earth"

#define kMetricUnitKey @"metric_units"
#define kVibrationKey @"vibration_on"
#define kQuizPlayCountKey @"quiz_play_count_key"
#define kAnswerTrackingQuizCountKey @"answerTrackingQuizCountKey"
#define kAllTimeBestScoreKey @"allTimeBestScoreKey"

// MANIPULATING PLANETS AND SATELLITES
#define kSatelliteType_moon 0
#define kSatelliteType_comet 1

// CONVERSION
#define kSIUnit_mass @"kg"
#define kSIUnit_diameter @"km"
#define kSIUnit_density @"kg/m"
#define kSIUnit_speed @"m/s"
#define kSIUnit_dayLength @"s"
#define kSIUnit_temperature @"K"
#define kSIUnit_sunDistance @"m"

#define kEarthUnit_mass @"Earth"
#define kEarthUnit_diameter @"Earth"
#define kEarthUnit_density @"Earth"
#define kEarthUnit_speed @"Earth"
#define kEarthUnit_dayLength @"Earth"
#define kEarthUnit_temperature @"°C"
#define kEarthUnit_sunDistance @"Earth"

#define kConvenientUnit_mass @"Earths"
#define kConvenientUnit_diameter @"km"
#define kConvenientUnit_density @"kg/m"
#define kConvenientUnit_speed @"km/hr"
#define kConvenientUnit_dayLength @"hrs"
#define kConvenientUnit_temperature @"°C"
#define kConvenientUnit_sunDistance @"Earth-sun"

#define kEarthToSIMassConversionFactor @"5.974e24"
#define kEarthToSIDiameterConversionFactor @"12.8e6"
#define kEarthToSIDensityConversionFactor 5520
#define kEarthToSISpeedConversionFactor 29700
#define kEarthToSIDayLengthConversionFactor 86400
#define kEarthToSITemperatureConversionFactor 273
#define kEarthToSISunDistanceConversionFactor 149600000000

#define kEarthToConvenientMassConversionFactor 1
#define kEarthToConvenientDiameterConversionFactor 12800
#define kEarthToConvenientDensityConversionFactor 5520
#define kEarthToConvenientSpeedConversionFactor 107000
#define kEarthToConvenientDayLengthConversionFactor 24
#define kEarthToConvenientTemperatureConversionFactor 1
#define kEarthToConvenientSunDistanceConversionFactor 1

// DIMENSIONS
#define kSatelliteScrollViewWidth 65.0
#define kSatelliteImageHeight 55.0
#define kSatelliteImageWidth 55.0
#define kSatelliteImageSideMargins 5.0
#define kSatelliteLabel_origin_y 10.0
#define kRandomCardOffset 2.5
#define kScrollObjectLabelFontSize 9.0

// GAME CENTER
//Leaderboard Category IDs
#define kLeaderboardID @"grp.021612_leaderboard_pk"
#define kMaxAuthenticationAttempts 2
#define kKnowledgeAchievement_1 @"grp.com.planetcards.knowledge.1"
#define kKnowledgeAchievement_2 @"grp.com.planetcards.knowledge.2"
#define kKnowledgeAchievement_3 @"grp.com.planetcards.knowledge.3"
#define kKnowledgeAchievement_4 @"grp.com.planetcards.knowledge.4"

#define kSpeedAchievement_1 @"grp.com.planetcards.speed.1"
#define kSpeedAchievement_2 @"grp.com.planetcards.speed.2"
#define kSpeedAchievement_3 @"grp.com.planetcards.speed.3"
#define kSpeedAchievement_4 @"grp.com.planetcards.speed.4"

#define kTotalAchievement_1 @"grp.com.planetcards.25percent"
#define kTotalAchievement_2 @"grp.com.planetcards.50percent"
#define kTotalAchievement_3 @"grp.com.planetcards.75percent"
#define kTotalAchievement_4 @"grp.com.planetcards.100percent"

// ANALYTICS
#define kGoogleAnalyticsKey @"UA-33693897-1"
#define kQuizAction @"quiz play event"
static const NSInteger kGANDispatchPeriodSec = 300;

// APP UPGRADE LINK
#define kPlanetCardsPaidLink @"http://itunes.apple.com/app/planetcards%20for%20iphone/id503510674?mt=8"