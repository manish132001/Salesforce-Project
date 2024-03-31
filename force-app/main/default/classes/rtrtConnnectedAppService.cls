public class rtrtConnnectedAppService {
        public static void getCases(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://rtrt-dev-ed.develop.lightning.force.com/services/apexrest/Cases/');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        // Deserialize the JSON string into collections of primitive data types.
        List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
        for(Object obj : results){
            Map<String, Object> caseProps = (Map<String, Object>)obj;
            System.debug(caseProps.get('CaseNumber')+'-'+caseProps.get('Subject'));
        }
        System.debug(res.getBody());
    }

}