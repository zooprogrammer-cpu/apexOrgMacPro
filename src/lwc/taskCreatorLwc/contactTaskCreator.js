import {taskCreator} from "./taskCreator";
export class contactTaskCreator extends taskCreator {
  createTasks() {
    console.log('Creating tasks for contacts');
  }

}