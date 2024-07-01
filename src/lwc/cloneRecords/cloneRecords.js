/**
 *
 */

import {LightningElement, api} from 'lwc';
import cloneRecordsController from '@salesforce/apex/CloneRecordsController.cloneRecords';
import cloneRelatedRecordsController from '@salesforce/apex/CloneRecordsController.cloneRelatedRecords'
export default class CloneRecords extends LightningElement {
  @api recordId;
  @api className;

  handleCloneRecord() {
    cloneRecordsController({"recordId" :this.recordId, "className" : this.className}).then(()=>{
      console.log('Cloned Record Success')
      this.handleCloneRelatedRecord();
    })

  }

  handleCloneRelatedRecord() {
    cloneRelatedRecordsController({"recordId": this.recordId, "className": this.className}).then(() => {
      console.log('Cloned Related Record Success')
    })
  }

}