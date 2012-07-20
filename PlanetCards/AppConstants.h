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

// XML parsing
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

// QUIZ PARSING
#define kQuizItem @"quiz_item"
#define kLevel @"level"
#define kQuestion @"question"
#define kWrongAnswer @"wrong_answer"
#define kRightAnswer @"right_answer"

// QUIZ VIEW MANIPULATION
#define kFrontCard 0
#define kBackCard 1
#define kNumberOfQuestions 20
#define kDefaultQuestionIntervalInSeconds 20
#define kAnswerLossIntervalInSeconds 5
#define kQuestionIntervalForTwoAnswersInSeconds 5

// SCORING
#define kIncorrectDelay 1.0
#define kCorrectDelay 0.5
#define kFirstAnswerBlock 5
#define kSecondAnswerBlock 10
#define kThirdAnswerBlock 20

// PREFERENCES
#define kUnitPreference @"kUnitPreference"
#define kConvenientUnits @"Convenient"
#define kSIUnits @"SI"
#define kEarthUnits @"Earth"

#define kMetricUnitKey @"metric_units"
#define kVibrationKey @"vibration_on"
#define kQuizPlayCountKey @"quiz_play_count_key"
#define kAllTimeBestScoreKey @"allTimeBestScoreKey"

// CONVERSION
#define kSIUnit_mass @"kg"
#define kSIUnit_diameter @"km"
#define kSIUnit_density @"kg/m3"
#define kSIUnit_speed @"m/s"
#define kSIUnit_dayLength @"s"
#define kSIUnit_temperature @"K"
#define kSIUnit_sunDistance @"m"

#define kEarthUnit_mass @"Earths"
#define kEarthUnit_diameter @"Earths"
#define kEarthUnit_density @"Earths"
#define kEarthUnit_speed @"Earths"
#define kEarthUnit_dayLength @"Earths"
#define kEarthUnit_temperature @"°C"
#define kEarthUnit_sunDistance @"Earths"

#define kConvenientUnit_mass @"Earths"
#define kConvenientUnit_diameter @"km"
#define kConvenientUnit_density @"kg/m3"
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
#define kLeaderboardID @"021612_leaderboard_pk"
#define kMaxAuthenticationAttempts 2

//Achievement IDs
#define kAchievement50PercentOrMore @"com.planetcards.50percent"
//#define kAchievement75PercentOrMore @"com.planetcards.75percent"
//#define kAchievement90PercentOrMore @"com.planetcards.90percent"