/********************************************************************************
 *                  Psychophysics Software Suit. v1.0                           * 
 ********************************************************************************  
 * File: ThemeMouse.java                                                       *
 * Description: Theme Mouse
 * Author: Michael Lvovsky                                                      *
 *         Stas Goldberg                                                        * 
 ********************************************************************************/


public class ThemeMouse extends Theme
{
    /**
     * Mouse theme factory class. 
     */
    public static class ThemeMouseFactory
    {
	/**
	 * Creates and return Theme, MouseTheme in this case. 
	 * 
	 * @return ThemeMouse
	 */
	public static ThemeMouse getNewItem()
	{
	    return new ThemeMouse(); 
	}
    }
    
    /**
     * Gets Theme's Type.
     * 
     * @return theme's type - int 
     */  
    public int getThemeType() 
    {	
	return THEME_MOUSE;
    }

    /**
     * Gets theme's prefix
     * 
     * @return theme's prefix - string 
     */ 
    protected String getPrefix() 
    {	
	return THEME_MOUSE_NAME;
    }
}
