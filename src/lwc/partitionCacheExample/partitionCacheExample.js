/**
 * Created by ashbas on 3/11/25.
 */

import {LightningElement, api, wire} from 'lwc';
import retrieveDataCachedController from '@salesforce/apex/PartitionCacheExample.retrieveDataCachedController';
import storeDataController from '@salesforce/apex/PartitionCacheExample.storeDataController';
import retrieveDataSOQLController from '@salesforce/apex/PartitionCacheExample.retrieveDataSOQLController';
import {CurrentPageReference} from "lightning/navigation";


export default class PartitionCacheExample extends LightningElement {
 @api recordId;
  accountId;
  currentPageReference;

  connectedCallback() {
    this.storeData();
  }

  @wire(CurrentPageReference)
  setCurrentPageReference(currentPageReference) {
    this.currentPageReference = currentPageReference;
    this.recordId = this.currentPageReference.attributes.recordId;
  }


  storeData() {
    console.log('this.recordId: ', this.recordId);
    storeDataController({recordId : this.recordId}).then(()=> {
      console.log('We stored the data');
    })
  }

  retrieveDataCache() {
    retrieveDataCachedController().then(data=> {
      console.log('This is the data from the cache: ', data);
      this.accountId = data.AccountId
    });
  }

  retrieveDataSOQL() {
    retrieveDataSOQLController({recordId : this.recordId}).then(data=> {
      console.log('This is the data from the SOQL: ', data);
      this.accountId = data.AccountId
    });
  }

}