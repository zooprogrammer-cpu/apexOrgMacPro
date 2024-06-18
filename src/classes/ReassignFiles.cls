/**
 * 
 */

public with sharing class ReassignFiles {
    public static void reassignFiles(Id originalRecordId) {
        List<ContentDocumentLink> contentLinks = [SELECT Id, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :originalRecordId];
        System.debug('contentLinks' + contentLinks);

        // Create a map to store ContentDocumentId in contentLinks to Order Record Id
        Map<Id,Id> contentToOrderMap = new Map<Id,Id>();

        for (ContentDocumentLink link : contentLinks) {
            //Extract order number from the ContentDocument
            String orderNumber = link.ContentDocument.Title.replaceAll('\\(\\d+\\)', '').trim();

            // Query the order record where the RPM_Order_Number__c matches the order number from the document
            List<Order> orders = [SELECT Id, RPM_Order_Number__c FROM Order WHERE RPM_Order_Number__c =: orderNumber LIMIT 1];

            if (!orders.isEmpty()) {
                contentToOrderMap.put(link.ContentDocumentId, orders[0].Id);
                System.debug('contentToOrderMap' + contentToOrderMap);
            }
            else {
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



}