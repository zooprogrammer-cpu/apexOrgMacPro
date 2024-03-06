import {objectServiceContactImpl} from "./objectServiceContactImpl";
import {objectServiceLeadImpl} from "./objectServiceLeadImpl";
import {objectServiceFactory} from "./objectServiceFactory";

export class objectService {
  classType;
   setMessage(objectType) {
     if (objectType === 'Contact') {
       this.classType = new objectServiceContactImpl();

     } else if (objectType === 'Lead') {
       this.classType = new objectServiceLeadImpl();

     }
     const serviceFactory = new objectServiceFactory(this.classType);
     return serviceFactory.setMessage();

   }
}