// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "appName": "NammaPallathur",
  "loginAndActivationScreen": {
    "login": "Login",
    "mobileNumber": "Mobile Number",
    "continue": "Continue",
    "textFieldHint": "888 999 7777",
    "mobileNumberRequiredError": "Mobile number is required",
    "mobileNumberLengthError": "Mobile number must be 10 digits long",
    "mobileNumberInputTypeError": "Mobile number can only contain digits",
    "welcome": "Welcome\nBack",
    "enterOtp": "Enter OTP",
    "otpNotRecieved": "Didn’t receive the OTP yet?",
    "resendOtp": "Resend OTP",
    "timeoutErrorMessage": "Connection Timeout!",
    "unknownErrorMessage": "Unknown error occurred!",
    "phoneNotRegistered": "Provided mobile number is not yet registered!",
    "exeeded3attemptsError": "You have exceeded 3 attempts.\nPlease use \"Resend OTP\" to try again."
  },
  "homeScreen": {
    "enrollUser": "Enroll Users",
    "monitorGrievances": "Monitor Grievances",
    "searchUser": "Search User",
    "profile": "Profile",
    "search": "Search"
  },
  "enrollUsers": {
    "screenTitle": "Enroll User",
    "firstName": "First Name",
    "lastName": "Last Name",
    "contactNumber": "Contact Number",
    "contactNumberHint": "888 999 7777",
    "email": "Email",
    "emailHint": "you@example.com",
    "ward": "Ward",
    "wardDropdownInitialValue": "Select Ward",
    "wardDropdownError": "Please select a value!",
    "location": "Location",
    "submit": "Submit",
    "dialogSucess": "Success",
    "dialogOk": "Ok",
    "userEnrolledSuccessMessage": "User has been added to the system!",
    "userEnrolledFailedMessage": "Enrolling user failed!",
    "dialogSuccessMessage": "User has been added!",
    "wardValidationErrorMessage": "Please select a value!",
    "firstNameValidationErrorMessage": "First name is required",
    "lastNameValidaitonErrorMessage": "Last name is required",
    "mobileNumberRequiredErrorMessage": "Mobile number is required",
    "mobileNumberLengthErrorMessage": "Mobile number must be 10 digits long",
    "mobileNumberTypeErrorMessage": "Mobile number can only contain digits"
  },
  "grievancesScreen": {
    "screenTitle": "Grievances",
    "viewMap": "View Map",
    "resultsOrderedBy": "Results ordered by date and time",
    "grievanceSearchHint": "Search grievance by type",
    "locaiton": "Location",
    "reporter": "Reporter",
    "date": "Date",
    "noGrievanceErrorMessage": "No Grievance Found"
  },
  "grievanceDetail": {
    "screenTitle": "Grievance Detail",
    "type": "Grievance Type",
    "reporter": "Reporter",
    "status": "Status",
    "changeStatus": "Change Status",
    "expectedCompletionIn": "Expected completion in",
    "change": "Change",
    "priority": "Priority",
    "photosAndVideos": "Photos / Videos",
    "voiceAndAudio": "Voice / Audio",
    "audio": "Audio",
    "locaiton": "Location",
    "description": "Description",
    "contactByPhoneEnabled": "Contact by phone enabled?",
    "commentsByReporter": "Comments by the reporter",
    "viewAll": "View all",
    "comments": "Comments",
    "latest6Comments": "Latest 6",
    "closeGrievance": "Close grievance",
    "comment": "Comment",
    "noCommentsMessage": "No Comments Yet!",
    "closingMessage": "Closing message",
    "submitCommentButton": "Submit"
  },
  "reporterComments": {
    "screenTitle": "Reporter Comments",
    "allComments": "All Comments"
  },
  "myComments": {
    "screenTitle": "My Comments",
    "allComments": "All Comments"
  },
  "comments": {
    "screenTitle": "Comments",
    "allComments": "All Comments"
  },
  "addComment": {
    "screenTitle": "Add Comment",
    "comment": "Comment",
    "commentTexthint": "Type your comment...",
    "attachments": "Attachments",
    "noAttachments": "No Attachments!",
    "addCommentButton": "Add Comment",
    "stop": "Tap the icon to stop recording",
    "record": "Tap the icon to start recording",
    "recordAudio": "Record Audio",
    "chooseAudio": "Choose audio",
    "recordingDoneMessage": "Recording done!",
    "addCommentFailed": "⚠️Could not send the comment!",
    "noComments": "No Comments Yet!",
    "videoLibrary": "Video Library",
    "recordVideo": "Record Video",
    "camera": "Camera",
    "uploadRecoding": "Upload",
    "photoLibrary": "Photo Library"
  },
  "map": {
    "screenTitle": "Map"
  },
  "searchUsers": {
    "screenTitle": "Search Users",
    "searchFieldHint": "Search",
    "resultsBasedOn": "Results based on",
    "startByTypingA": "Start by\ntyping a",
    "filterBy": "Filter by",
    "apply": "Apply",
    "name": "Name",
    "streetName": "Street Name",
    "userNotFound": "Unable to find the user!",
    "userDisabled": "User Disabled",
    "mobileNumber": "Mobile Number"
  },
  "userDetails": {
    "screenTitle": "User Details",
    "call": "Call",
    "about": "About",
    "ward": "Ward",
    "municipality": "Municipality",
    "contact": "Contact",
    "location": "Location",
    "disableUser": "Disable User",
    "enableUser": "Enable User",
    "phone": "Phone",
    "email": "Email",
    "sms": "SMS",
    "mobile": "Mobile"
  },
  "editUserDetails": {
    "screenTitle": "Edit User",
    "municipality": "Municipality",
    "editUserFailed": "An unknown error occurred!",
    "editUserSuccess": "✅ Successfully edited the user.",
    "addressRequiredMessage": "Address is required!",
    "countryRequiredMessage": "Country is required!"
  },
  "profile": {
    "screenTitle": "Profile",
    "edit": "Edit",
    "about": "About",
    "location": "Location",
    "allocatedGrievancesAndWards": "Allocated grievances and wards",
    "logoutFailed": "Logout failed!",
    "logout": "Logout"
  },
  "editProfile": {
    "screenTitle": "Edit Profile",
    "firstName": "First Name",
    "lastName": "Last Name",
    "location": "Location",
    "contactNumber": "Contact Number",
    "email": "Email",
    "about": "About",
    "aboutHint": "Type here...",
    "submit": "Submit",
    "wardError": "Ward is required",
    "firstNameError": "First name is required",
    "lastNameError": "Last name is required",
    "aboutError": "This field is required",
    "emailError": "Email is required",
    "profileUpdatedErrorMessage": "⚠️Something went wrong!",
    "profileUpdatedSuccessMessage": "✅ Profile updated successfully.",
    "mobileNumberRequiredErrorMessage": "Mobile number is required",
    "mobileNumberLengthErrorMessage": "Mobile number must be 10 digits long",
    "mobileNumberInputTypeError": "Mobile number can only contain digits"
  }
};
static const Map<String,dynamic> es = {
  "appName": "NammaPallathur",
  "loginAndActivationScreen": {
    "login": "Login",
    "mobileNumber": "Mobile Number",
    "continue": "Continue",
    "textFieldHint": "888 999 7777",
    "mobileNumberRequiredError": "Mobile number is required",
    "mobileNumberLengthError": "Mobile number must be 10 digits long",
    "mobileNumberInputTypeError": "Mobile number can only contain digits",
    "welcome": "Welcome\nBack",
    "enterOtp": "Enter OTP",
    "otpNotRecieved": "Didn’t receive the OTP yet?",
    "resendOtp": "Resend OTP",
    "timeoutErrorMessage": "Connection Timeout!",
    "unknownErrorMessage": "Unknown error occurred!",
    "phoneNotRegistered": "Provided mobile number is not yet registered!",
    "exeeded3attemptsError": "You have exceeded 3 attempts.\nPlease use \"Resend OTP\" to try again."
  },
  "homeScreen": {
    "enrollUser": "Enroll Users",
    "monitorGrievances": "Monitor Grievances",
    "searchUser": "Search User",
    "profile": "Profile",
    "search": "Search"
  },
  "enrollUsers": {
    "screenTitle": "Enroll User",
    "firstName": "First Name",
    "lastName": "Last Name",
    "contactNumber": "Contact Number",
    "contactNumberHint": "888 999 7777",
    "email": "Email",
    "emailHint": "you@example.com",
    "ward": "Ward",
    "wardDropdownInitialValue": "Select Ward",
    "wardDropdownError": "Please select a value!",
    "location": "Location",
    "submit": "Submit",
    "dialogSucess": "Success",
    "dialogOk": "Ok",
    "userEnrolledSuccessMessage": "User has been added to the system!",
    "userEnrolledFailedMessage": "Enrolling user failed!",
    "dialogSuccessMessage": "User has been added!",
    "wardValidationErrorMessage": "Please select a value!",
    "firstNameValidationErrorMessage": "First name is required",
    "lastNameValidaitonErrorMessage": "Last name is required",
    "mobileNumberRequiredErrorMessage": "Mobile number is required",
    "mobileNumberLengthErrorMessage": "Mobile number must be 10 digits long",
    "mobileNumberTypeErrorMessage": "Mobile number can only contain digits"
  },
  "grievancesScreen": {
    "screenTitle": "Grievances",
    "viewMap": "View Map",
    "resultsOrderedBy": "Results ordered by date and time",
    "grievanceSearchHint": "Search grievance by type",
    "locaiton": "Location",
    "reporter": "Reporter",
    "date": "Date",
    "noGrievanceErrorMessage": "No Grievance Found"
  },
  "grievanceDetail": {
    "screenTitle": "Grievance Detail",
    "type": "Grievance Type",
    "reporter": "Reporter",
    "status": "Status",
    "changeStatus": "Change Status",
    "expectedCompletionIn": "Expected completion in",
    "change": "Change",
    "priority": "Priority",
    "photosAndVideos": "Photos / Videos",
    "voiceAndAudio": "Voice / Audio",
    "audio": "Audio",
    "locaiton": "Location",
    "description": "Description",
    "contactByPhoneEnabled": "Contact by phone enabled?",
    "commentsByReporter": "Comments by the reporter",
    "viewAll": "View all",
    "comments": "Comments",
    "latest6Comments": "Latest 6",
    "closeGrievance": "Close grievance",
    "comment": "Comment",
    "noCommentsMessage": "No Comments Yet!",
    "closingMessage": "Closing message",
    "submitCommentButton": "Submit"
  },
  "reporterComments": {
    "screenTitle": "Reporter Comments",
    "allComments": "All Comments"
  },
  "myComments": {
    "screenTitle": "My Comments",
    "allComments": "All Comments"
  },
  "comments": {
    "screenTitle": "Comments",
    "allComments": "All Comments"
  },
  "addComment": {
    "screenTitle": "Add Comment",
    "comment": "Comment",
    "commentTexthint": "Type your comment...",
    "attachments": "Attachments",
    "noAttachments": "No Attachments!",
    "addCommentButton": "Add Comment",
    "stop": "Tap the icon to stop recording",
    "record": "Tap the icon to start recording",
    "recordAudio": "Record Audio",
    "chooseAudio": "Choose audio",
    "recordingDoneMessage": "Recording done!",
    "addCommentFailed": "⚠️Could not send the comment!",
    "noComments": "No Comments Yet!",
    "videoLibrary": "Video Library",
    "recordVideo": "Record Video",
    "camera": "Camera",
    "uploadRecoding": "Upload",
    "photoLibrary": "Photo Library"
  },
  "map": {
    "screenTitle": "Map"
  },
  "searchUsers": {
    "screenTitle": "Search Users",
    "searchFieldHint": "Search",
    "resultsBasedOn": "Results based on",
    "startByTypingA": "Start by\ntyping a",
    "filterBy": "Filter by",
    "apply": "Apply",
    "name": "Name",
    "streetName": "Street Name",
    "userNotFound": "Unable to find the user!",
    "userDisabled": "User Disabled",
    "mobileNumber": "Mobile Number"
  },
  "userDetails": {
    "screenTitle": "User Details",
    "call": "Call",
    "about": "About",
    "ward": "Ward",
    "municipality": "Municipality",
    "contact": "Contact",
    "location": "Location",
    "disableUser": "Disable User",
    "enableUser": "Enable User",
    "phone": "Phone",
    "email": "Email",
    "sms": "SMS",
    "mobile": "Mobile"
  },
  "editUserDetails": {
    "screenTitle": "Edit User",
    "municipality": "Municipality",
    "editUserFailed": "An unknown error occurred!",
    "editUserSuccess": "✅ Successfully edited the user.",
    "addressRequiredMessage": "Address is required!",
    "countryRequiredMessage": "Country is required!"
  },
  "profile": {
    "screenTitle": "Profile",
    "edit": "Edit",
    "about": "About",
    "location": "Location",
    "allocatedGrievancesAndWards": "Allocated grievances and wards",
    "logoutFailed": "Logout failed!",
    "logout": "Logout"
  },
  "editProfile": {
    "screenTitle": "Edit Profile",
    "firstName": "First Name",
    "lastName": "Last Name",
    "location": "Location",
    "contactNumber": "Contact Number",
    "email": "Email",
    "about": "About",
    "aboutHint": "Type here...",
    "submit": "Submit",
    "wardError": "Ward is required",
    "firstNameError": "First name is required",
    "lastNameError": "Last name is required",
    "aboutError": "This field is required",
    "emailError": "Email is required",
    "profileUpdatedErrorMessage": "⚠️Something went wrong!",
    "profileUpdatedSuccessMessage": "✅ Profile updated successfully.",
    "mobileNumberRequiredErrorMessage": "Mobile number is required",
    "mobileNumberLengthErrorMessage": "Mobile number must be 10 digits long",
    "mobileNumberInputTypeError": "Mobile number can only contain digits"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "es": es};
}
