public with sharing class addMultipleCasesController {
@AuraEnabled
public static ResponseWrapper saveMultipleCases(List<Case> cases){
    ResponseWrapper response=new ResponseWrapper();
    try {
        insert cases;
        response.isSuccess=true;
    } catch (Exception e) {
        response.isSuccess=false;
        response.message=e.getMessage();
    }
    return response;
}

public class ResponseWrapper
{
    @AuraEnabled
    public Boolean isSuccess{get;set;}
    @AuraEnabled
    public String message{get;set;}

}
}


