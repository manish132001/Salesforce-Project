@RestResource(urlMapping='/DataAvailable/*')
global class ConnectedApps {
    
    @httpget
    global static Contact getContact(){
        Contact con=[Select Id, Name from Contact where Name='Andy Young'];
        return con;
    }

}