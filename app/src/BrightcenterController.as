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
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;
import flash.utils.Dictionary;

import mx.controls.Button;
import mx.utils.Base64Decoder;

public class BrightcenterController {

    private var _student:Student;
    private var _cookie:String;
    private var _assessmentIdFromUrl:String;
    private var _baseURL:String = "http://www.brightcenter.nl/dashboard/api";
    private var _appUrl:String;
    private var _callBack:Function;
    private static var _instance:BrightcenterController;

    public function BrightcenterController() {
        trace("init brightcenterController")
    }

    public static function getInstance():BrightcenterController {
        if (_instance == null) {
            trace("created new instance of Brightcentercontroller")
            _instance = new BrightcenterController();
        }
        return _instance;
    }

    public function getStudent():Student {
        return _student;
    }

    public function setStudent(value:Student):void {
        _student = value;
    }

    public function getCookie():String {
        return _cookie;
    }

    public function setCookie(value:String):void {
        _cookie = value;
    }

    public function getAssessmentIdFromUrlVar():String {
        return _assessmentIdFromUrl;
    }

    public function setAssessmentIdFromUrl(value:String):void {
        _assessmentIdFromUrl = value;
    }

    public function getBaseURL():String {
        return _baseURL;
    }

    public function seBaseURL(value:String):void {
        _baseURL = value;
    }

    public function getAppUrl():String {
        return _appUrl;
    }

    public function setAppUrl(value:String):void {
        _appUrl = value;
    }

    public function getCallBack():Function {
        return _callBack;
    }

    public function setCallBack(value:Function):void {
        _callBack = value;
    }


    public function application_preinitializeHandler():void {
        trace("preinitialize");
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
    }

    function onInvoke(event:InvokeEvent):void {
        trace("on invoke!");
        if (event.arguments[0] != null) {
            handleUrl(event.arguments[0]);
            _callBack()
        }
    }

    public function handleUrl(url:String):void {
        var paramPairs : Array = url.split("?")[1].split("&");
        var dict = new Dictionary();
        for each (var pair : String in paramPairs){
            var param : Array = pair.split("=");
            trace("key: " + param[0] + ", value: " + param[1]);
            dict[param[0]] = param[1];
        }
        _student = getStudentFromUrl(dict["data"]);
        trace("_student: " + _student.getFirstName() + " " + _student.getLastName());
        _cookie = dict["cookie"];
        trace("Cookie: " + _cookie);
        _assessmentIdFromUrl = dict["assessmentId"];
        trace("assessmentId from url: " + _assessmentIdFromUrl);
    }

    public function getStudentFromUrl(data:String):Student {
        data = data.replace("*", "=");
        trace(data);
        var b64:Base64Decoder = new Base64Decoder();
        b64.decode(data);
        var result:Object = JSON.parse(b64.toByteArray().toString());
        var student:Student = new Student(result.personId, result.firstName, result.lastName);
        return student;
    }

    public function getResults(assessmentId:String, personId:String, callBackSucces:Function, callBackError:Function) {
        var path:String = "/assessment/" + assessmentId + "/students/" + personId + "/assessmentItemResult";
        var cookieHeader:URLRequestHeader = new URLRequestHeader("Cookie", "JSESSIONID=" + _cookie);
        var request:URLRequest = new URLRequest(_baseURL + path);
        request.requestHeaders.push(cookieHeader);

        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, urlLoaderComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderError);

        loader.load(request);

        function urlLoaderComplete(evt:Event):void {
            trace("data: " + loader.data);
            var results:Object = JSON.parse(loader.data);
            var newResults:Array = new Array();
            for each(var i in results) {
                var result:Result = new Result(i.questionId, new Date(i.date), i.attempts, i.duration, i.score, i.completionStatus);
                newResults.push(result);
            }
            callBackSucces(newResults);
        }

        function urlLoaderError(evt:IOErrorEvent):void {
            callBackError();
        }
    }

    public function postResult(result:Result, assessmentId:String, callBackError:Function) {
        var path:String = "/assessment/" + assessmentId + "/student/" + _student.getPersonId() + "/assessmentItemResult/" + result.getQuestionId();
        var cookieHeader:URLRequestHeader = new URLRequestHeader("Cookie", "JSESSIONID=" + _cookie);
        var json:String = "{\"duration\":" + result.getDuration() + ", \"score\":" + result.getScore() + ", \"completionStatus\":\"" + result.getCompletionStatus() + "\"}";
        trace(json);

        var request:URLRequest = new URLRequest(_baseURL + path);
        request.method = URLRequestMethod.POST;
        request.data = json;
        request.requestHeaders.push(cookieHeader);
        request.contentType = "application/json";

        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderError);
        loader.load(request);

        function urlLoaderError(evt:IOErrorEvent):void {
            callBackError();
        }
    }

    public function openBrightcenterApp(assessmentId:String, callBack:Function):void {
        trace("opening brightcenter app");
        _callBack = callBack;
        navigateToURL(new URLRequest("brightcenterApp://?protocolName=" + _appUrl + "&assessmentId=" + assessmentId));
    }

    //add mx.swc include frameworks/projects/mx/src
    public function createBrightcenterButton(assessmentId:String, callBack:Function, screenWidth:int, screenHeight:int):Button{
        var button:Button = new Button();
        button.x = screenWidth - 150;
        button.y = screenHeight - 150;
        button.setStyle("overSkin", Class(BrightcenterButtonSkin));
        button.setStyle("upSkin", Class(BrightcenterButtonSkin));
        button.setStyle("downSkin", Class(BrightcenterButtonSkin));


        button.addEventListener("click", function myBtn_clickHandler(event:MouseEvent):void {
            openBrightcenterApp(assessmentId, callBack);
        });
        return button;
    }
}
}