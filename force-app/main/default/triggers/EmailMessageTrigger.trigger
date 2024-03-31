trigger EmailMessageTrigger on EmailMessage (after insert) {
    List<Attachment> attachmentsToInsert = new List<Attachment>();    
    
    // Map to store EmailMessage Ids and their corresponding ContentDocumentLink Ids
    Map<Id, Set<Id>> emailMessageToContentDocumentLinkMap = new Map<Id, Set<Id>>();
    
    // Collect ContentDocumentIds associated with EmailMessages
    Set<Id> contentDocumentIds = new Set<Id>();
    
    // Query ContentDocumentLinks associated with EmailMessages
    for (EmailMessage emailMessage : Trigger.new) {
        if (emailMessage.HasAttachment) {
            emailMessageToContentDocumentLinkMap.put(emailMessage.Id, new Set<Id>());
        }
    }
    
    for (ContentDocumentLink cdl : [SELECT ContentDocumentId, LinkedEntityId 
                                     FROM ContentDocumentLink 
                                    WHERE LinkedEntityId IN :emailMessageToContentDocumentLinkMap.keySet()]) {
        emailMessageToContentDocumentLinkMap.get(cdl.LinkedEntityId).add(cdl.ContentDocumentId);
        contentDocumentIds.add(cdl.ContentDocumentId);
    }
    
    // Query ContentVersions associated with ContentDocumentIds
    Map<Id, List<ContentVersion>> contentDocumentIdToContentVersionMap = new Map<Id, List<ContentVersion>>();
    for (ContentVersion cv : [SELECT Id, Title, VersionData, ContentDocumentId, FileExtension 
                                FROM ContentVersion 
                               WHERE ContentDocumentId IN :contentDocumentIds]) {
        if (!contentDocumentIdToContentVersionMap.containsKey(cv.ContentDocumentId)) {
            contentDocumentIdToContentVersionMap.put(cv.ContentDocumentId, new List<ContentVersion>());
        }
        contentDocumentIdToContentVersionMap.get(cv.ContentDocumentId).add(cv);
    }
    
    // Create Attachments
    for (EmailMessage emailMessage : Trigger.new) {
        if (emailMessage.HasAttachment && emailMessageToContentDocumentLinkMap.containsKey(emailMessage.Id)) {
            Set<Id> contentDocumentIdsForEmail = emailMessageToContentDocumentLinkMap.get(emailMessage.Id);
            for (Id contentDocumentId : contentDocumentIdsForEmail) {
                List<ContentVersion> attachments = contentDocumentIdToContentVersionMap.get(contentDocumentId);
                for (ContentVersion attachment : attachments) {
                    Attachment newAttachment = new Attachment();
                    newAttachment.ParentId = emailMessage.RelatedToId;
                    newAttachment.Name = attachment.Title;
                    newAttachment.Body = attachment.VersionData;
                    newAttachment.ContentType = attachment.FileExtension;
                    attachmentsToInsert.add(newAttachment);
                }
            }
        }
    }
    
    insert attachmentsToInsert;
}