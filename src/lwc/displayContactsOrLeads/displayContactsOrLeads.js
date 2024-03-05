/**
 *
 */

import {api, LightningElement} from 'lwc';
import getUIDataController from '@salesforce/apex/LWCMapController.getDataForUI';


export default class DisplayContactsOrLeads extends LightningElement {
  @api objectApiName
  mapMarkers;

  // connectedCallback() {
  //   this.getMapMarkers();
  // }

  getList(){
    console.log('objectApiName:' , this.objectApiName);
    getUIDataController({"objectApiName":this.objectApiName, "uiType":"MapMarker"}).then(markers =>{
      console.log('markers', markers);
      this.mapMarkers = markers;
    });
  }

}