import {LightningElement, api} from 'lwc';
import {objectService} from "./objectService";

export default class OpenClosedExample extends LightningElement {
  @api objectApiName;
  message;
  connectedCallback() {
    this.getObjectMessage();
  }

  getObjectMessage(){
    const objectService1 = new objectService();
    this.message = objectService1.setMessage(this.objectApiName);
  }
}