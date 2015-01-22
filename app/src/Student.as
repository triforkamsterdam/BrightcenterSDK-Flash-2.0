/**
 * Created with IntelliJ IDEA.
 * User: Rick
 * Date: 28/08/14
 * Time: 11:15
 * To change this template use File | Settings | File Templates.
 */
package {
public class Student {

    private var personId:String;
    private var firstName:String;
    private var lastName:String;
    public function Student(personId:String, firstName:String, lastName:String) {
        this.personId = personId;
        this.firstName = firstName;
        this.lastName = lastName;
    }


    public function getPersonId():String {
        return personId;
    }

    public function getFirstName():String {
        return firstName;
    }

    public function getLastName():String {
        return lastName;
    }
}
}
