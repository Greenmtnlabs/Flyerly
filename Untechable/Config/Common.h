/*
 *  Common.h
 *  Untechable
 *
 *  Created by Abdul Rauf on 23/sep/2014
 *  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
 *
 */

#define APP_NAME @"Untechable"


// http://iosdevelopertips.com/cocoa/date-formatters-examples-take-2.html
#define DATE_FORMATE_1 @"MMM dd, YYYY hh:mm a"
#define DATE_FORMATE_2 @""
#define APP_FONT @"Pigiarniq"


#define TITLE_NEXT_TXT @"NEXT"
#define TITLE_BACK_TXT @"BACK"
#define TITLE_DONE_TXT @"DONE"
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

#define SAVE @"SAVE"
#define SET @"SET"

#define TESTING @"TESTING"

#define LOCALHOST @"LOCALHOST"
#define DEVELOPMENT @"DEVELOPMENT"
#define PRODUCTION @"PRODUCTION"


//#define SERVER_URL @"http://192.168.0.118:3001" //LOCALHOST
#define SERVER_URL @"http://riksof.com:8000" //DEVELOPMENT
//#define SERVER_URL @"http://untechable.com" //PRODUCTION

#define API_GET_NUMBER SERVER_URL@"/get-forwading-number"
#define API_SAVE SERVER_URL@"/event/save"


#define TEST_UID @"0"
#define TEST_EID @""
#define TEST_TWILLIO_NUM @""
//#define TEST_TWILLIO_NUM @"+16464551382"

//PAID PRODUCTS
#define PRODUCT_UntechableMessage @"com.greenmtnlabs.UntechableMessage"



#define APP_IN_MODE PRODUCTION




