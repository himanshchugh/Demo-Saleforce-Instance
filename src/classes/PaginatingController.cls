/**
 * This abstract Controller is useful when you want to display paginated data in an
 * apex:pageBlockTable where the data is fetched or created all at once such as is
 * the case for some API calls.
 *
 * @see ContactInterestController.cls/Contact_Interest.page for a working example
 */
public abstract class PaginatingController {
       
    private Integer itemCount = 0;    
    private Integer startPosition = 0;
            
    private Integer pageSize = 20; // default
    private Integer pageNumber = 1; // 1-based numbering
    private Integer totalPageNumber = 0; // calculated
    
    /**
     * derivative class should call this once the item array has been built.
     * You will have some method on your derivative that exposes the array
     * to your visual force page code.
     */    
    public void setItemCount (Integer itemCount) {
    	this.itemCount = itemCount;
    	positionToPage (pageNumber);
    }    
    
    public void setPageSize (Integer pageSize) {
    	this.pageSize = pageSize;
    }

    public void setPageNumber(Integer pageNumber) {
        this.pageNumber=pageNumber;
    }

    public void setStartPosition(Integer startPosition) {
        this.startPosition=startPosition;
    }

    public void setTotalPageNumber(Integer totalPageNumber) {
        this.totalPageNumber=totalPageNumber;
    }
    /////////////////////////////
    // pageBlockTable Helpers
    /////////////////////////////
        
    /**
     * the index of the array item to start with in the rendering pass
     */    
    public Integer getFirst () {
        return startPosition;   
    }
        
    /**
     * the current page number
     */    
    public Integer getPageNumber() {   
        return pageNumber;  
    }
    
    /**
     * how many rows to display with in the rendering pass
     */    
    public Integer getPageSize() {   
        return pageSize;    
    }
    
    /**
     * used to calculate the total number of 
     * pages present in the data based on page size
     */    
    public Integer getTotalPageNumber() {       
        if (totalPageNumber == 0) {           
            totalPageNumber = itemCount / pageSize;           
            Integer mod = itemCount - (totalPageNumber * pageSize);           
            if (mod > 0)            
              totalPageNumber++;        
        }
        
        //toString ('totalPageNumber exit');    
        return totalPageNumber; 
    }
        
    /**
     * returns true of there are multiple pages to display
     */    
    public Boolean getIsMoreThanOnePage() {
        return itemCount > pageSize;
    }
    
    /**
     * returns true of the previous button should be shown but disabled
     */    
    public Boolean getPreviousButtonDisabled() {       
        return pageNumber <= 1;   
    }
    
    /**
     * returns true of the next button should be shown but disabled
     */    
    public Boolean getNextButtonDisabled() {   
        return pageNumber >= getTotalPageNumber();  
    }
    
    /**
     * action click causing the next page to be displayed while remaining in the same render context.
     */          
    public PageReference nextBtnClick() {   
        positionToPage (pageNumber + 1);       
        return null;    
    }
    
    /**
     * action click causing the previous page to be displayed while remaining in the same render context.
     */          
    public PageReference previousBtnClick() {   
        positionToPage (pageNumber - 1);       
        return null;    
    }
    
    ////////////////////////
    // Helpers
    ////////////////////////
        
    /**
     * positions to the requested page index
     */    
    private void positionToPage (Integer newPageIndex) {
        //toString ('positionToPage newPageIndex=' + newPageIndex);
        
        try {   
        	if (newPageIndex <= 0)
        	    /*throw new Exceptions.IllegalArgumentException 
        	    ('page index must be > 0 newPageIndex=' + newPageIndex);*/

        	if (newPageIndex > getTotalPageNumber() && getTotalPageNumber() != 0)
                //throw new Exceptions.IllegalArgumentException 
                //('newPageIndex=' + newPageIndex + ' not <= totalPageNumber=' + getTotalPageNumber());
                
            if (getTotalPageNumber() == 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No data found.'));
        	    
            startPosition = (newPageIndex-1) * pageSize;               	             
        	pageNumber = newPageIndex;               	 
        }
        
        catch(Exception ex) {       
            ApexPages.addmessage (new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));      
        }
        
        //toString ('positionToPage exit');
    } 
    
    private void toString (String msg) {
            System.debug (LoggingLevel.DEBUG, 
            msg +
            ' itemCount=' + itemCount +
            ' startPosition=' + startPosition +
            ' pageNumber=' + pageNumber +
            ' pageSize=' + pageSize +
            ' totalPageNumber=' + totalPageNumber);                          	
    }    
}