public class WhatsAppIntegration {
    @AuraEnabled 
    public static Boolean sendTemplateMessage(String contactId){
        Contact con=[Select Id,Name,Phone from Contact where Id=:contactId];
        String whatsAppnumber = '91' + con.Phone;
        System.debug('number is'+whatsAppnumber);
        Http http= new Http();
        HttpRequest req= new HttpRequest();
        req.setEndpoint('https://graph.facebook.com/v18.0/264529836733922/messages');
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        
        string body = '{"messaging_product":"whatsapp", "to":"'+whatsAppnumber+'","type":"template","template":{"name":"hello_world", "language":{"code":"en_US"}}}';
        req.setBody(body);
        
        string apiToken='EAAai9f6sT30BO37nnO0p9SB9chT717rALmMndXdHDBGj4QtugcICCg0K191BPZCuQq0KkVOhwUJ0adfPo6lgLi54h0VLfj7ECDYTgjPKhZBh6z4rgjXXa9FiUTPoWb1K4gA3Yc0Fq13VQ2YTEvN1f8eMNZCV3XQYitVZA7AOriBD9s7oLoYF2aiqlCFbiOfuyoZBZAU05pyItTUXgzXYIZD';
        req.setHeader('Authorization','Bearer '+apiToken);
        
        HttpResponse res=http.send(req);
        System.debug(res.getStatusCode());
        
        if(res.getStatusCode()==200){
            return true;
        }
        return false;
        
        
    }

}