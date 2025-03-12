/**
 * Created by ashbas on 3/11/25.
 */

import {LightningElement, api} from 'lwc';
import retrieveDataCachedController from '@salesforce/apex/PartitionCacheExample.retrieveDataCachedController';
import storeDataController from '@salesforce/apex/PartitionCacheExample.storeDataController';
import retrieveDataSOQLController from '@salesforce/apex/PartitionCacheExample.retrieveDataSOQLController';


export default class PartitionCacheExample extends LightningElement {
 @api recordId;
  accountId;

  connectedCallback() {
    this.storeData();
  }

  storeData() {
    storeDataController().then(()=> {
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
    retrieveDataSOQLController().then(data=> {
      console.log('This is the data from the SOQL: ', data);
      this.accountId = data.AccountId
    });
  }

}