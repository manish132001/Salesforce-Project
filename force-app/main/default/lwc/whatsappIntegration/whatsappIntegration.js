import { LightningElement,api } from 'lwc';
import sendTemplateMessage from '@salesforce/apex/WhatsAppIntegration.sendTemplateMessage';

export default class WhatsappIntegration extends LightningElement {
    @api recordId;

    onSendMessageTemplate(){
        sendTemplateMessage({contactId:this.recordId})
        .then(result=>{
            window.alert("Message Sent");
        })
        .catch(errro=>{
            window.alert("message not sent");
        })

    }
}