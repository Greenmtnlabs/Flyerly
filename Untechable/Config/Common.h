/*
 *  Common.h
 *  Untechable
 *
 *  Created on 23/sep/2014
 *  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
 *
 */

#define APP_NAME @"Untechable"


// http://iosdevelopertips.com/cocoa/date-formatters-examples-take-2.html
#define DATE_FORMATE_DATE @"MMM dd, YYYY"
#define DATE_FORMATE_TIME @"hh:mm a"

#define DATE_FORMATE_1 @"MMM dd, YYYY hh:mm a"
#define DATE_FORMATE_2 @""
#define APP_FONT @"Pigiarniq"

// Keys for Email Address and Email password for setting screen
#define EMAIL_KEY @"emailAddress"
#define PASSWORD_KEY @"emailPassword"
#define TITLE_HOME_TXT @"HOME"
#define TITLE_INVITE_TXT @"INVITE"
#define TITLE_HELP_TXT @"HELP"
#define TITLE_SKIP_TXT @"SKIP"
#define TITLE_SAVE_TXT @"SAVE"
#define TITLE_NEXT_TXT @"NEXT"
#define TITLE_NEW_TXT @"NEW"
#define TITLE_BACK_TXT @"BACK"
#define TITLE_SETTINGS_TXT @"SETTINGS"
#define TITLE_DONE_TXT @"DONE"
#define TITLE_FINISH_TXT @"FINISH"
#define TITLE_EDIT_TEXT @"EDIT"
#define TITLE_FONT @"Pigiarniq-Bold"
#define TITLE_FONT_SIZE 18
#define TITLE_LEFT_SIZE 12
#define TITLE_RIGHT_SIZE 12

#define CHECKBOX_FILLED 1
#define CHECKBOX_TICK 2
#define CHECKBOX_EMPTY 3

#define REC_FORMATE @".wav"
#define PIECES_FILE @"untechable.pieces"
#define RECORDING_LIMIT_IN_SEC 60

#define SUCCESS @"SUCCESS"
#define CANCEL @"CANCEL"
#define SAVE @"SAVE"
#define UPDATE @"UPDATE"

#define TESTING @"TESTING"
#define DISABLE @"DISABLE"
#define ENABLE @"ENABLE"

#define LOCALHOST @"LOCALHOST"
#define DEVELOPMENT @"DEVELOPMENT"
#define PRODUCTION @"PRODUCTION"

#define UNT_ENVIRONMENT PRODUCTION

//#define SERVER_URL @"http://192.168.0.109:3000" //LOCALHOST
//#define SERVER_URL @"http://riksof.com:8000"    //DEVELOPMENT
#define SERVER_URL @"http://app.untechable.com:3010"   //PRODUCTION


#define API_GET_NUMBER SERVER_URL@"/get-forwading-number"
#define API_SAVE SERVER_URL@"/event/save"
#define API_DELETE SERVER_URL@"/event/delete" // must pass parmeters{ eventId: 123 }


#define TEST_UID @"0"
#define TEST_EID @""
#define TEST_TWILLIO_NUM @""
//#define TEST_TWILLIO_NUM @"+16464551382"

//PAID PRODUCTS
#define PRODUCT_UntechableMessage @"com.greenmtnlabs.UntechableMessage"

#define IN_APP_MODE DISABLE

#define APP_IN_MODE PRODUCTION

// FLURRY
#define FLURRY_API_KEY @"97YNR3836CX357PBMTRW"

// CRITTERCISM
#define CRITTERCISM_APP_ID @"5465e512d478bc6ee1000004"
#define CRITTERCISM_APP_API_KEY @"2TZIJpEQoAguORwnQ7XdsTOJc9FGpfWY"

#define TW_CONSUMER_KEY @"GxQAvzs4YXBl2o39TN5nr4ogj"
#define TW_CONSUMER_SECRET @"IRO1i1pqUdKorBg1fwn4SEzniAeG1GrzpUVXd9mooG4GkpIlNA"

#define LINKEDIN_CLIENT_ID @"77xbm1nay7fgm7" //API KEY
#define LINKEDIN_CLIENT_SECRET @"egcM3osyJiBj1QHF" //SECRET
#define LINKEDIN_REDIRECT_URL SERVER_URL
#define LINKEDIN_STATE @"Untechable53sBCDef424"

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define DEF_ARAY_SPLITER @"-ary-spliter-"

#define DEF_GREEN [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:100.0/255.0 alpha:1.0]
#define DEF_GRAY [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0]
#define DEF_SPENDING_TIME_ARY @[@"spending time with family", @"driving", @"spending time outdoors", @"at the beach", @"enjoying the holidays", @"just needed a break", @"running", @"on vacation", @"finding my inner peace", @"removing myself from technology", @"in a meeting", @"biking",@"playing sports",@"hiking", @"yoga", @"relaxing", @"eating", @"drinking", @"spending time with friends", @"custom"]

#define ERROR @"Error"
#define OK @"OK"

#define PRO_MONTHLY_SUBS @"com.untech.MonthlySubscription"
#define PRO_YEARLY_SUBS @"com.untech.YearlySubscriptions"
