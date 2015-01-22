/**
 * Created with IntelliJ IDEA.
 * User: Rick
 * Date: 28/08/14
 * Time: 12:31
 * To change this template use File | Settings | File Templates.
 */
package {
public class Result {
    private var questionId:String;
    private var date:Date;
    private var attempts:int;
    private var duration:Number;
    private var score:Number;
    private var completionStatus:String;


    public function Result(questionId:String, date:Date, attempts:int, duration:Number, score:Number, completionStatus:String) {
        this.questionId = questionId;
        this.date = date;
        this.attempts = attempts;
        this.duration = duration;
        this.score = score;
        this.completionStatus = completionStatus;
    }


    public function getQuestionId():String {
        return questionId;
    }

    public function getDate():Date {
        return date;
    }

    public function getAttempts():int {
        return attempts;
    }

    public function getDuration():Number {
        return duration;
    }

    public function getScore():Number {
        return score;
    }

    public function getCompletionStatus():String {
        return completionStatus;
    }
}
}
