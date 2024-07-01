@RestResource(UrlMapping='/studentsInfo/*')
global class StudentInformationService {
    global class StudentInfo {
        String studentName {get;set;}
        String studentAddress{get;set;}
        String studentPhone{get;set;}

    }

    @httpGet
    global static StudentInfo getStudent() {
        RestRequest request = RestContext.Request;
        String studentId = request.requestURI.substring(request.RequestURI.lastIndexOf('/')+1);
        apxio__Student__c student = [SELECT Id, Name, Address__c, apxio__Phone__c
        FROM apxio__Student__c WHERE Id =: studentId];
        StudentInfo stdInfo = new StudentInfo();
        stdInfo.studentName = student.Name;
        stdInfo.studentAddress = student.Address__c;
        stdInfo.studentPhone = student.apxio__Phone__c;
        //stdInfo.schoolName = student.School__r.Name;

        return stdInfo;

    }


}