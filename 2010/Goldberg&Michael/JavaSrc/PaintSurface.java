/********************************************************************************
 *                  Psychophysics Software Suit. v1.0                           * 
 ********************************************************************************  
 * File: PaintSurface.java                                                      *
 * Description: Pannel with image background                                    *
 * Author: Michael Lvovsky                                                      *
 *         Stas Goldberg                                                        * 
 ********************************************************************************/

import java.awt.Graphics;
import javax.swing.ImageIcon;
import javax.swing.JPanel;


public class PaintSurface extends JPanel
{
    private static final long serialVersionUID = 1244719381796519942L;
    private ImageIcon backgroundGif;

    /** 
     * C'tor
     */ 
    public PaintSurface( ImageIcon backGif) 
    {
	backgroundGif = backGif;		
    }

    /**
     * Gets opaque. 
     *   
     * Since we're always going to fill our entire
     * bounds, allow Swing to optimize painting of us
     * 
     * @return false 
     */
    public boolean isOpaque() 
    {
        return false;
    }

    /**
     * Paint component.
     * Draws background image.
     * 
     * @param g
     */
    protected void paintComponent(Graphics g) 
    {
        if ( backgroundGif == null) 
            return;
	
	int width = getWidth();
	int height = getHeight();
	int imageW = backgroundGif.getImage().getWidth(this);
	int imageH = backgroundGif.getImage().getHeight(this);	    

	// Tile the image to fill our area.
	for (int x = 0; x < width; x += imageW) 
	{
	    for (int y = 0; y < height; y += imageH) 
	    {
		g.drawImage(backgroundGif.getImage(), x, y, this);
	    }
	}	    		    
    }
    
    /**
     * Sets background image and repaint
     * 
     * @param newImg
     */ 
    public void setImage(ImageIcon newImg)
    {
	backgroundGif = newImg;
	repaint();
    }
}
