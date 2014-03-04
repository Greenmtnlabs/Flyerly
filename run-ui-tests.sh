#!/bin/bash
cd UITests/features/
ZUCCHINI_DEVICE="iPhone 5" zucchini run 0_welcome
ZUCCHINI_DEVICE="iPhone 5" zucchini run 1_signin
ZUCCHINI_DEVICE="iPhone 5" zucchini run 2_signup
ZUCCHINI_DEVICE="iPhone 5" zucchini run 3_forgotpassword
ZUCCHINI_DEVICE="iPhone 5" zucchini run 4_home
ZUCCHINI_DEVICE="iPhone 5" zucchini run 5_flyer_text
ZUCCHINI_DEVICE="iPhone 5" zucchini run 6_flyer_photo
ZUCCHINI_DEVICE="iPhone 5" zucchini run 7_flyer_Symbols_icons
ZUCCHINI_DEVICE="iPhone 5" zucchini run 8_Flyer_Undo
ZUCCHINI_DEVICE="iPhone 5" zucchini run 9_Flyer_Delete
ZUCCHINI_DEVICE="iPhone 5" zucchini run 10_Share_Screen
ZUCCHINI_DEVICE="iPhone 5" zucchini run 11_Flyer_Background
ZUCCHINI_DEVICE="iPhone 5" zucchini run 12_Save_Flyer
ZUCCHINI_DEVICE="iPhone 5" zucchini run 13_Account_Setting