/**
 * This module is responsible for information related
 * to Events .
 * @mraheelmateen , abdul.rauf
 */
var db = require(__dirname + '/db');

/**
 * Scehma of the user object.
 */
var eventsSchema = db.Schema({

    userId: String,
    paid: String,

    timezoneOffset: String,
    spendingTimeTxt: String,
    startTime: String,
    endTime: String,
    hasEndDate: String,

    userName: String,
    phoneNumber: String,

    twillioNumber: String,
    location: String,
    customizedContacts: Object,
    socialStatus: String,
    fbAuth: String,
    fbAuthExpiryTs: String,
    twitterAuth: String,
    twOAuthTokenSecret: String,
    linkedinAuth: String,

    //Field will show on screen2    
    acType: String, //< ICLOUD / EXCHANGE / GOOGLE / YAHOO / AOL / OUTLOOK / OTHER > 	
    email: String,
    password: String,
    respondingEmail: String,
    //Field will show on screen1
    serverType: String, //< IMAP >
    iSsl: String, //< YES / NO >
    //INCOMING MAIL SERVER
    imsHostName: String, // < mail.thecreativeblink.com >
    imsPort: String, // 143
    //OUTGOING MAIL SERVER
    omsHostName: String, // < mail.thecreativeblink.com >
    omsPort: String, // 25
    oSsl: String, //< YES / NO >

    updatedOn: String,
    postSocialStatus: Boolean

});
module.exports = db.model('Events', eventsSchema);