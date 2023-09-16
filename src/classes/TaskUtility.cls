public with sharing class TaskUtility {
  public static String getTaskPriority(String leadCountry) {
    if (String.isBlank(leadCountry) || leadCountry.length() > 2) {
      return null;
    } else {
        String taskPriority;
        if (leadCountry == 'US'){
            taskPriority = 'High';
        }
        else{
            taskPriority = 'Normal';
        }
        System.debug('The Task Priority is: ' + taskPriority);
        return taskPriority;
    }
  }
}