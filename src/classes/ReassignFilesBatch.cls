/**
 * 
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
            System.debug('contentLinks' + contentLinks);

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
                System.debug('contentId' + contentId);
                ContentDocumentLink newLink = new ContentDocumentLink();
                newLink.ContentDocumentId = contentId; //document  Id
                newLink.LinkedEntityId = contentToOrderMap.get(contentId); //Order Id
                System.debug('contentToOrderMap.get(contentId);' + contentToOrderMap.get(contentId));
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
                System.debug('inserted' + newLinks.size() + 'new contentDocumentLinks');
            }
            else {
                System.debug('No new contentDocumentLinks to insert');
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