/**
 * Description: This class is used to reassign files from one Order record to other Order records.
 * ------------------------------------------------------------------------------------------------------------------
 * Date            Developer                 Company                       Comments
 * ------------------------------------------------------------------------------------------------------------------
 * 06/19/2024      Ash Basnyat               Coastal                - Original Version
 */

global class ReassignFilesBatch implements Database.Batchable<SObject> {
    global final Id originalRecordId;

    global ReassignFilesBatch(Id originalRecordId) {
        this.originalRecordId = originalRecordId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :originalRecordId]);
    }

    global void execute(Database.BatchableContext context, List<SObject> scope) {
        try {
            List<ContentDocumentLink> contentLinks = (List<ContentDocumentLink>) scope;

            // Create a map to store ContentDocumentId in contentLinks to Order Record Id
            Map<Id,Id> contentToOrderMap = new Map<Id,Id>();

            // Collect all order numbers
            Set<String> orderNumbers = new Set<String>();
            for (ContentDocumentLink link : contentLinks) {
                String orderNumber = link.ContentDocument.Title.replaceAll('\\(\\d+\\)', '').trim();
                orderNumbers.add(orderNumber);
            }

            // Query all orders at once
            Map<String, Order> orderMap = new Map<String, Order>();
            for (Order order : [SELECT Id, RPM_Order_Number__c FROM Order WHERE RPM_Order_Number__c IN :orderNumbers]) {
                orderMap.put(order.RPM_Order_Number__c, order);
            }

            for (ContentDocumentLink link : contentLinks) {
                String orderNumber = link.ContentDocument.Title.replaceAll('\\(\\d+\\)', '').trim();
                Order order = orderMap.get(orderNumber);
                if (order != null) {
                    contentToOrderMap.put(link.ContentDocumentId, order.Id);
                } else {
                    System.debug('Not matching order found for document:' + orderNumber);
                }
            }

            List<ContentDocumentLink> newLinks = new List<ContentDocumentLink>();
            List<ContentDocumentLink> linksToDelete = new List<ContentDocumentLink>();

            for (Id contentId: contentToOrderMap.keySet()) {
                ContentDocumentLink newLink = new ContentDocumentLink();
                newLink.ContentDocumentId = contentId; //document  Id
                newLink.LinkedEntityId = contentToOrderMap.get(contentId); //Order Id
                newLink.ShareType = 'I';
                newLinks.add(newLink);

                // FInd and prepare existing link for deletion
                for (ContentDocumentLink link: contentLinks) {
                    if(link.ContentDocumentId == contentId) {
                        linksToDelete.add(link);
                    }
                }
                System.debug('Created new ContentDocumentLink for ContentDocumentId:' + contentId + 'to Order Id:' + contentToOrderMap.get(contentId));
            }

            if (!linksToDelete.isEmpty()) {
                delete linksToDelete;
                System.debug('Deleted' + linksToDelete.size() + 'old ContentDocumentLinks');
            }
            else {
                System.debug('No old ContentDocumentLinks to delete');
            }

            if (!newLinks.isEmpty()) {
                insert newLinks;
            }

            // Print Unsuccessful files
            for (ContentDocumentLink link : contentLinks) {
                String orderNumber = link.ContentDocument.Title.replaceAll('\\(\\d+\\)', '').trim();
                Order order = orderMap.get(orderNumber);
                if (order == null) {
                    System.debug('File Name: ' + link.ContentDocument.Title + ' could not be reassigned');
                }
            }

        }
        catch (Exception e) {
            System.debug('An error occurred:' + e.getMessage());
        }

    }

    global void finish(Database.BatchableContext context) {
        System.debug('Finished ReassignFilesBatch ');
    }
}