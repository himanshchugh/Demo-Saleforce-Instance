public class testJSRemotingFileUploadController {
    public static Blob blobImage {get; set;}
    public static Attachment image{get;set;}
    private static Id accId = '0012800001WQdTn';
    public String strImage {get; set;}
    
    public testJSRemotingFileUploadController() {
        strImage = '';
    }
    
    @RemoteAction
    public static Boolean testUpload(String strImage, String fileName, String imgType) {
        
        System.debug('__testUpload__');
        if (strImage.length() > 0){
            /*System.debug('__fileRecieved__');
            image =  new Attachment();
            //blobImage = EncodingUtil.base64Decode(strImage);
            //return true;
            
           //Adding the image to attachments
           image.body = EncodingUtil.base64Decode(strImage);
           image.name = fileName;
           image.parentId = accId;
           image.ContentType = imgType;
           insert image;
           
           System.debug('__imageId__'+image.id);*/
            
           //Testing upload to salesforce files.
           ContentVersion file = new ContentVersion();
           //file.ParentId = accId;
           file.VersionData = EncodingUtil.base64Decode(strImage);
           file.Title = fileName;
           file.PathOnClient = fileName;
           insert file;
           
           ContentDocument doc = [select id, parentId from ContentDocument where id IN (select ContentDocumentId from ContentVersion where id = :file.id) LIMIT 1];
           
           /*ContentDocumentLink docLink = [Select id, linkedEntityId from ContentDocumentLink where ContentDocumentId = :doc.Id];
           docLink.linkedEntityId = accId;
           update docLink;*/
            
           ContentDocumentLink cdl = new ContentDocumentLink();
           cdl.ContentDocumentId = doc.id;
           cdl.LinkedEntityId = accId;
           cdl.ShareType = 'I';
           insert cdl;
		
        }
        return false;
    }
    
    public void reloadImage() {
        
    }
    
    public PageReference uploadFiles() {
        system.debug('__file__recieved__');
        system.debug('__FILE__: '+ strImage);
        return null;
    }
    
    public class test_Wrapper {
        public String testField;
    }

}