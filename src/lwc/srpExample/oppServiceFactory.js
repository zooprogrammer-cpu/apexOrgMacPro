export class oppServiceFactory {
  classType;
  constructor(classType) {
    this.classType = classType;
  }
  calculateOpps() {
    this.classType.calculateOpps();

  }
}