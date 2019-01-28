/********************************************************************************
 *                  Psychophysics Software Suit. v1.0                           * 
 ********************************************************************************  
 * File: Theme.java                                                             *
 * Description: Theme - abstract class                                          *
 * Author: Michael Lvovsky                                                      *
 *         Stas Goldberg                                                        * 
 ********************************************************************************/

import javax.swing.ImageIcon;


abstract class Theme 
{
    //Constants
    
    //Theme's types
    public static int THEME_MOUSE  = 1; 
    public static int THEME_DRAGON = 2;
    
    //Theme's name
    public static String THEME_MOUSE_NAME  = "mouse";
    public static String THEME_DRAGON_NAME = "dragon";
    
    /**
     * Gets Theme's Type.
     * 
     * @return theme's type - int 
     */  
    abstract public int getThemeType();
           
    /**
     * Gets theme's prefix
     * 
     * @return theme's prefix - string 
     */ 
    abstract protected String getPrefix();
    
    /**
     * Set Theme's images.
     * 
     * @param imgArray - ImageIcon[].  
     */ 
    public void setThemeImage(ImageIcon[] imgArray)
    {
	String prefix = getPrefix(); 

	setCommonImages( imgArray); 
	
	//Background  
	imgArray[6] = new ImageIcon(this.getClass().getResource("images/"+prefix+"/"+prefix+"_back.jpg"));
		
	//Happy figure 
	imgArray[7] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_happy.gif"));
	
	//Cry figure 
	imgArray[8] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_cry.gif"));
	
	//Stop figure 
	imgArray[9] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_stop.gif"));
	
	//Sound figure 
	imgArray[10] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_sound.gif"));
	
	//Happy X figure 
	imgArray[11] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_X_happy.gif"));
	
	//Cry X figure 
	imgArray[12] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_X_cry.gif"));
	
        //Stop X figure 
	imgArray[13] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_X_stop.gif"));

	//Sound X figure 
	imgArray[14] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_X_sound.gif"));
	
	//Background Color
	imgArray[15] = new ImageIcon( this.getClass().getResource("images/"+prefix+"/"+prefix+"_color.jpg"));
    }
    
    /**
     * Sets common Images 
     * @param imgArray - ImageIcon[].
     */
    private void setCommonImages(ImageIcon[] imgArray)
    {
	//Stop face 
	imgArray[0] = new ImageIcon( this.getClass().getResource("images/face_stop.gif"));
	
	//Happy face
        imgArray[1] = new ImageIcon( this.getClass().getResource("images/happy_face.gif"));
        
        //Progress figure stop
	imgArray[2] = new ImageIcon( this.getClass().getResource("images/shell_stop.gif"));
	    
	//Progress figure move
        imgArray[3] = new ImageIcon( this.getClass().getResource("images/shell_move.gif"));
        
        //Start sign
        imgArray[4] =  new ImageIcon( this.getClass().getResource("images/gosign.gif"));
        
        //Stop sign 
        imgArray[5] = new ImageIcon( this.getClass().getResource("images/stopsign.gif"));
    }
}
