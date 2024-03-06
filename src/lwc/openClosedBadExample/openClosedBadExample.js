
import {api, LightningElement} from 'lwc';

export default class OpenClosedBadExample extends LightningElement {
  @api objectApiName;
  message;
  connectedCallback() {
    this.getObjectMessage();
  }

  getObjectMessage() {
    if (this.objectApiName === 'Contact') {
      this.getContactMessage();
    } else if (this.objectApiName === 'Lead') {
      this.getLeadMessage();
    }

  }

  getContactMessage() {
    this.message = 'Contact Message';

  }

  getLeadMessage() {
    this.message = 'Lead Message';

  }
}