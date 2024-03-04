import {oppServiceManager} from "./oppServiceManager";
import {oppServiceCTO} from "./oppServiceCTO";
import {oppServiceFactory} from "./oppServiceFactory";

export class oppService {
  calculateOpps(userType) {
    let classType;
    // assign the classType variable, the oppService implementation
    if (userType === 'CTO') {
      classType = new oppServiceCTO();
    }
    else if (userType === 'Manager') {
      classType = new oppServiceManager();
    }
    // passing the implementation of oppService to oppServiceFactory
    const oppServiceFactory1 = new oppServiceFactory(classType);
    // call the calculateOpps method.
    oppServiceFactory1.calculateOpps();

  }
}