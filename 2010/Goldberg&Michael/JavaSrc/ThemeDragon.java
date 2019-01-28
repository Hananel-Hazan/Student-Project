/********************************************************************************
 *                  Psychophysics Software Suit. v1.0                           * 
 ********************************************************************************  
 * File: ThemeDragon.java                                                       *
 * Description: Theme Dragon
 * Author: Michael Lvovsky                                                      *
 *         Stas Goldberg                                                        * 
 ********************************************************************************/


public class ThemeDragon extends Theme
{    
    /**
     * Dragon theme factory class. 
     */
    public static class ThemeDragonFactory
    {
	/**
	 * Creates and return Theme, DragonTheme in this case. 
	 * 
	 * @return ThemeMouse
	 */
	public static ThemeDragon getNewItem()
	{
	    return new ThemeDragon(); 
	}
    }
   
    /**
     * Gets Theme's Type.
     * 
     * @return theme's type - int 
     */  
    public int getThemeType() 
    {	
	return THEME_DRAGON;
    }

    /**
     * Gets theme's prefix
     * 
     * @return theme's prefix - string 
     */ 
    protected String getPrefix() 
    {	
	return THEME_DRAGON_NAME;
    }

}
