
import {LightningElement} from 'lwc';
import {oppService} from "./oppService";

export default class SrpExample extends LightningElement {
  // Old way
  // userType;
  // calculateOpps() {
  //   if (this.userType === 'CTO') {
  //     this.calculateOppsCTO()
  //   }
  //
  // }
  //
  // calculateOppsCTO() {
  //   console.log('Opps for CTO')
  // }

  // New way
  // in real world, push in the userType dynamically.
  userType = 'CTO';
  //userType = 'Manager';
  calculateOpps () {
    // calling the oppService class
    // Based on the userType, the oppService class determines which oppService implementation to run
    const oppService1 = new oppService();
    oppService1.calculateOpps(this.userType);
  }


}