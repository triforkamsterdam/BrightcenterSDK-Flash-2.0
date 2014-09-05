BrightcenterSDK-Flash-2.0
=========================

This SDK makes it easier to communicate with Brightcenter. It uses an appswitch to retrieve the student that is logged in.

###Register your appUrl
When you register or edit an assessment you can change your appUrl. your appUrl needs to be the same as your CFBundleURLSchemes. If you register your appUrl you can generate a test link on: www.brightcenter.nl/dashboard/createSdkUrl . There you can select your app and a student and your link will be generated. If you open this link on a device or simulator your app will be opened.
When the BrightcenterApp is finished it'll open your app in the same way. 

###Download the project
To use this SDK you need to download this project. You'll need to at least include  brightcenterController.as into your own project by just adding it to your project folder.

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
 The second thing you'll need to do is to create a callback for when your app is being switched to. In the demo this is done in the preinitialize event by using `BrightcenterController.callback = appSwitchCallBack`. 
 
 You also need to set the app url to your chosen url scheme by doing this: `BrightcenterController.appUrl = "YOURAPPURL"`. 
 
 you also need to make a call to `BrightcenterController.application_preinitializeHandler(event);` here. This ensures that the appswitch will be activated. After the appswitch is done, you callback will be made. From there you can do whatever you want. 
 
You can acces the student that is picked by using: `BrightcenterController.student` You can look into the `student.as` file for which variables it has.

###Open the Brightcenter App
 To open the brightcenter app you can call `BrightcenterController.openBrightcenterApp(assessmentId:String);` the assessment id can also be empty but NOT null! This function will open the brightcenter app with the given assessmentId.
 
 
###Posting a result
 to post a result you can call `BrightcenterController.postResult(result:Result, assessmentId:String, callBackError:Function)` The callback will only be called when an error occured.
 
###Retrieve results
 To retrieve a result you can call `BrightcenterController.getResults(assessmentId:String, personId:String, callBackSucces:Function, callBackError:Function)`. The succes callback will return you an array with all the results of the student. The error callback will be called when something went wrong. The personId of a student can be retrieved by using `BrightcenterController.student.getPersonId();`
 
 See the demo files for examples.
