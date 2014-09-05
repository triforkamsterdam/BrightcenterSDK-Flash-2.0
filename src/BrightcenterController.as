/**
 * Created with IntelliJ IDEA.
 * User: Rick
 * Date: 28/08/14
 * Time: 10:42
 * To change this template use File | Settings | File Templates.
 */
package {
import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.InvokeEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;

import mx.events.FlexEvent;

import mx.utils.Base64Decoder;


public class BrightcenterController {

    static var testUrl:String = "brightcenterAppClientCorona://data/eyJsYXN0TmFtZSI6IkJyb3V3ZXIiLCJwZXJzb25JZCI6IjUyYjMwYjRiMzAwNDdjZjlkZWQ5OGM3NiIsImZpcnN0TmFtZSI6Ikx1dWsifQ==/cookie/26A242C9773D40DE4033B5DCDEEB7755/assessmentId/987-654-321";
    static var student:Student;
    static var cookie:String;
    static var assessmentIdFromUrl:String;
    static var baseURL:String = "http://www.brightcenter.nl/dashboard/api";
    static var appUrl:String;
    static var callBack:Function;
    public function BrightcenterController() {
        trace("init brightcenterController")
    }


    static function application_preinitializeHandler(event:FlexEvent):void
    {
        trace("preinitialize");
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
    }

    static function onInvoke(event:InvokeEvent):void
    {
        trace("on invoke!");
        if(event.arguments[0]!=null) {
            BrightcenterController.handleUrl(event.arguments[0]);
            BrightcenterController.callBack();
        }
    }

    static function handleUrl(url:String):void {
        BrightcenterController.student = getStudentFromUrl(url);
        trace("student: " + BrightcenterController.student.getFirstName() + " " + BrightcenterController.student.getLastName());
        BrightcenterController.cookie = getCookieFromUrl(url);
        trace("Cookie: " + BrightcenterController.cookie);
        BrightcenterController.assessmentIdFromUrl = getAssessmentIdFromUrl(url)
        trace("assessmentId from url: " + BrightcenterController.assessmentIdFromUrl);
    }

    static function getStudentFromUrl(url:String):Student{
        var pattern1:RegExp = new RegExp(".*data/", "");
        var pattern2:RegExp = new RegExp("/cookie/.*", "")
        var data:String = url.replace(pattern1, "");
        data = data.replace(pattern2, "")
        var b64:Base64Decoder = new Base64Decoder();
        b64.decode(data);

        var result:Object = JSON.parse(b64.toByteArray().toString());
        var student:Student = new Student(result.personId, result.firstName, result.lastName);
        return student;
    }

    static function getCookieFromUrl(url:String):String{
        var cookie = "";
        var pattern1:RegExp = new RegExp(".*cookie/", "");
        var pattern2:RegExp = new RegExp("/assessmentId.*", "")
        var data:String = url.replace(pattern1, "");
        cookie = data.replace(pattern2, "")
        return cookie;
    }

    static function getAssessmentIdFromUrl(url:String):String{
        var pattern:RegExp = new RegExp(".*/assessmentId")
        var data:String = url.replace(pattern, "");
        data = data.replace("/", "");
        return data;
    }

    static function getResults(assessmentId:String, personId:String, callBackSucces:Function, callBackError:Function){
        var path:String = "/assessment/" + assessmentId + "/students/" + personId + "/assessmentItemResult";
        var cookieHeader:URLRequestHeader = new URLRequestHeader("Cookie", "JSESSIONID=" + BrightcenterController.cookie);
        var request:URLRequest = new URLRequest(BrightcenterController.baseURL + path);
        request.requestHeaders.push(cookieHeader);

        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, urlLoaderComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderError);

        loader.load(request);

        function urlLoaderComplete(evt:Event):void {
            trace("data: " + loader.data);
            var results:Object = JSON.parse(loader.data);
            var newResults:Array= new Array();
            for each(var i in results){
                var result:Result = new Result(i.questionId, new Date(i.date), i.attempts, i.duration, i.score, i.completionStatus);
                newResults.push(result);
            }
            callBackSucces(newResults);
        }

        function urlLoaderError(evt:IOErrorEvent):void{
            callBackError();
        }
    }

    static function postResult(result:Result, assessmentId:String, callBackError:Function){
        var path:String = "/assessment/" + assessmentId + "/student/" + BrightcenterController.student.getPersonId() + "/assessmentItemResult/" + result.getQuestionId();
        var cookieHeader:URLRequestHeader = new URLRequestHeader("Cookie", "JSESSIONID=" + BrightcenterController.cookie);
        var json:String = "{\"duration\":" + result.getDuration() + ", \"score\":" + result.getScore() + ", \"completionStatus\":\"" + result.getCompletionStatus() + "\"}";
        trace(json);

        var request:URLRequest = new URLRequest(BrightcenterController.baseURL + path);
        request.method = URLRequestMethod.POST;
        request.data = json;
        request.requestHeaders.push(cookieHeader);
        request.contentType = "application/json";

        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderError);
        loader.load(request);

        function urlLoaderError(evt:IOErrorEvent):void{
            callBackError();
        }
    }

    static function openBrightcenterApp(assessmentId:String, callBack:Function):void{
        trace("opening brightcenter app");
        BrightcenterController.callBack = callBack;
        navigateToURL(new URLRequest("brightcenterApp://protocolName/" + BrightcenterController.appUrl + "/assessmentId/" + assessmentId));
    }
}
}