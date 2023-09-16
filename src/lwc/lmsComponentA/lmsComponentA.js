import { LightningElement, wire , api} from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c"
import {MessageContext,publish} from 'lightning/messageService'; 
export default class LmsComponentA extends LightningElement {
    recordId; 
    @api 
    get getRecordId(){
        return this.recordId; 
    }
    
    @wire(MessageContext)
    context

    inputValue

    inputHandler(event){
        this.inputValue = event.target.value
    }

    publishMessage(){
        const message={
            lmsData:{
                value:this.inputValue
            },
            recordId:{
                value: this.getRecordId
            }
        }
        //publish(messageContext,messageChannel,message)
        publish(this.context,SAMPLEMC,message)
    }
}