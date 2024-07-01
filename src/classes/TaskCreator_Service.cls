public with sharing class TaskCreator_Service {
    private static Map<String, Type>objectTypeToImplementation = new Map<String, Type> {
        'Opp' => OpportunityTask_Service.class,
        'Contact' => ContactTask_Service.class
    };

    public static void createTask(String objectType) {
        TaskCreatorLSP_Interface taskCreator = (TaskCreatorLSP_Interface) objectTypeToImplementation.get(objectType).newInstance();
        taskCreator.createTasks(null);
    }

}