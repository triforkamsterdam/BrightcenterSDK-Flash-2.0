BrightcenterSDK-Flash-2.0
=========================

This SDK makes it easier to communicate with Brightcenter. It uses an appswitch to retrieve the student that is logged in.

###Register your appUrl
When you register or edit an assessment you can change your appUrl. your appUrl needs to be the same as your CFBundleURLSchemes. If you register your appUrl you can generate a test link on: www.brightcenter.nl/dashboard/createSdkUrl . There you can select your app and a student and your link will be generated. If you open this link on a device or simulator your app will be opened.
When the BrightcenterApp is finished it'll open your app in the same way. 

###Download the project
To use this SDK you need to download this project. You can include all the source files or you can simply add the BrightcenterSDK-Flash-2_0-library.swc as an dependency of your project. If you use FLash cc you MUST add the .swc file as a dependency

###Use the sdk
To use the sdk you need to do a few things. First you'll need to put the following in your {project}-app.xml:

```
<key>CFBundleURLTypes</key>
	        <array>
		        <dict>
			        <key>CFBundleURLName</key>
			        <string>YOURBUNDLENAME</string>
			        <key>CFBundleURLSchemes</key>
			        <array>
				    <string>YOURAPPSCHEME</string>
			        </array>
		            </dict>
	        </array>
```

###Get an instance
To get a singleton instance of the Brightcentercontroller you can call: `var controller = BrightcenterController.getInstance()`. Use this instance to communicate with Brightcenter.
 The second thing you'll need to do is to create a callback for when your app is being switched to. In the demo this is done in the preinitialize event by using `controller.setCallBack(appSwitchCallBack)`. 
 
 You also need to set the app url to your chosen url scheme by doing this: `controller.setAppUrl("YOURAPPURL")`. 
 
 you also need to make a call to `controller.application_preinitializeHandler();` here. This ensures that the appswitch will be activated. After the appswitch is done, you callback will be made. From there you can do whatever you want. 
 
You can acces the student that is picked by using: `controller.getStudent()` You can look into the `student.as` file for which variables it has.

###Open the Brightcenter App
 To add the Brightcenter button you can use the following code:
```
button = controller.createBrightcenterButton("ASSESSMENTID", appSwitchCallBack, screenWidth, screenHeight);
addElement(button);
```
the assessment id can also be empty but NOT null! This function will open the brightcenter app with the given assessmentId. The appswitchCallback will be called when the Brightcenter app opens your app again.

To handle orientationchange you can add the following in your StageOrientationEvent(These values just need to be the width and the height of the stage):
```
button.x = FlexGlobals.topLevelApplication.width - 150;
button.y = FlexGlobals.topLevelApplication.height - 150;
```
Your button has to be global to do this.
See the source code for examples
 
 
BEFORE YOU MAKE THE FOLLOWING CALLS MAKE SURE YOUR APP IS OPENED BY URL OR APP!
###Posting a result
 to post a result you can call `controller.postResult(result:Result, assessmentId:String, callBackError:Function)` The callback will only be called when an error occured.
 
###Retrieve results
 To retrieve a result you can call `controller.getResults(assessmentId:String, personId:String, callBackSucces:Function, callBackError:Function)`. The succes callback will return you an array with all the results of the student. The error callback will be called when something went wrong. The personId of a student can be retrieved by using `controller.getStudent().getPersonId();`
 
 See the demo files for examples.
