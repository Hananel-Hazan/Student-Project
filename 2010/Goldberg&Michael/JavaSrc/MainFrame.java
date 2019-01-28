/********************************************************************************
 *                  Psychophysics Software Suit. v1.0                           * 
 ********************************************************************************  
 * File: MainFrame.java                                                         *
 * Description: Trial's main frame.                                             *
 * Author: Michael Lvovsky                                                      *
 *         Stas Goldberg                                                        * 
 ********************************************************************************/

import java.awt.Container;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Rectangle;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowEvent;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JOptionPane;


public class MainFrame extends JFrame 
{               
    private static final long serialVersionUID = 6742079323949055794L;

    /** 
     * Number of images in one theme.  
     */    
    final static int NUM_OF_THEME_IMG  = 16;
    
    /** 
     * Screen's X size.   
     */    
    final static int SCREEN_SIZE_X_DEF = 800;
    
    /** 
     * Screen's Y size.   
     */    
    final static int SCREEN_SIZE_Y_DEF = 600;

    /**
     * Collection of images, used in theme. 
     */ 
    private ImageIcon[] themesImage = new ImageIcon[NUM_OF_THEME_IMG]; 
                      
    /**
     * Theme - abstract class
     */
    private Theme trialTheme;
    
    /**
     * Collection of panels, used to animate theme's figures. 
     */  
    public  PaintSurface motionPnl[];
    
    /**
     * Progress bar panel.  
     */
    public  PaintSurface progressPnl;
    
    /**
     * Sign Start/Stop panel. 
     */
    public  PaintSurface signPnl;
    
    /**
     * Happy face panel. 
     */
    public  PaintSurface facePnl;
    
    /**
     * Main panel, contains all other panels. 
     */
    private PaintSurface contentPane;
    
    /**
     * Total steps number. 
     */
    private int numOfSteps;
    
    /**
     * Figure's number.
     */ 
    private int numOfFigures;
    
    /**
     * Indicates index of current step. 
     */
    private int currentStep;
    
    /** 
     * Task definition (e.g. XABX)
     */  
    private String taskString; 

    /**
     * MainFrame - Constructor. 
     */
    public MainFrame(String figureStr, int stepsNum ,String themeName) 
    {
	//Initialize num of figures and steps
	numOfFigures = figureStr.length();
	taskString = figureStr.toUpperCase();
	numOfSteps   = stepsNum;	
	currentStep  = 0;
	
	//Initial theme
	trialTheme = createTheme( themeName);
	
	//In case of failed
	if ( trialTheme == null) 
	{
	    System.out.println("Can't load theme: " + themeName + ". Aplication terminated");
	    dispose();	    
	}
	
	//Initialize theme's images
	trialTheme.setThemeImage( themesImage);
	
        contentPane = new PaintSurface( themesImage[6]);
	
        PaintSurface mainPnl = new PaintSurface(themesImage[15]);        
	mainPnl.setLayout(null);
	mainPnl.setBounds(0, 0, 500, 500);
	
	//Sets properties for main frame.
	setDefaultCloseOperation( DISPOSE_ON_CLOSE);
	setLocationRelativeTo(null);	
	setIconImage(new ImageIcon( this.getClass().getResource("images/face_stop.gif")).getImage());
	setTitle("Psychophysics Software Suite");
	
	addComponentListener( new ResizeListener( this, contentPane));
		
	Container cont = getContentPane();
	mainPnl.add( contentPane); 
	
	cont.add( mainPnl);
	contentPane.setLayout(null);
	contentPane.setBounds(0, 0, SCREEN_SIZE_X_DEF, SCREEN_SIZE_Y_DEF);        

	//Inits and locates figures.
	motionPnl = new PaintSurface[numOfFigures];
	for(int i=0; i< numOfFigures; i++)
	{
	    switch ( taskString.charAt(i))
	    {
	       case 'X': //if X figure 
	       {
	         motionPnl[i] = new PaintSurface( themesImage[13]);        	
	         motionPnl[i].setBounds( calcIntervals(i),350, themesImage[13].getIconWidth(),themesImage[13].getIconHeight());
	         break;
	       }//case 'X'
	       default: //regular figure
	       {
	         motionPnl[i] = new PaintSurface( themesImage[9]);        	
	         motionPnl[i].setBounds( calcIntervals(i),350, themesImage[9].getIconWidth(),themesImage[9].getIconHeight());
	         break;
	       }//default
	    }//switch
	       
	    motionPnl[i].setOpaque(false);
	    motionPnl[i].setLayout( null);            
	    contentPane.add(motionPnl[i]);
	}//for            
	contentPane.addMouseListener( new StartStopMouseListener(motionPnl, themesImage[9], themesImage[13], taskString));

	//Inits and locates progress bar        
	progressPnl = new PaintSurface(themesImage[2]);
	progressPnl.setBounds( 0, 20, themesImage[2].getIconWidth(), themesImage[2].getIconHeight());

	contentPane.add(progressPnl);

	//Inits and locates sign
	signPnl = new PaintSurface( themesImage[4]);
	signPnl.setOpaque(false);	
	signPnl.setBounds(5,470, themesImage[4].getIconWidth(),themesImage[4].getIconHeight());
	signPnl.setLayout( null);            

	contentPane.add(signPnl);
	
	//Inits and locates face
	facePnl = new PaintSurface( themesImage[0]);
	facePnl.setOpaque(false);	
	facePnl.setBounds(380,160, 0,0);
	facePnl.setLayout( null);            

	contentPane.add( facePnl); 
	
	//Set full screen if supported. 
	GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment(); 
	GraphicsDevice[] device = env.getScreenDevices();
	
	if ( device[0].isFullScreenSupported())
	{
           device[0].setFullScreenWindow( this);
	}
	else
	{
	    System.out.println("Full Screen mode does not supported");
	}

	//Make the frame visible. 
	setVisible(true);
    }

    /**
     * Calculates intervals between figures. 
     * @param i - figure's index.
     * 
     * @return i's figure position 
     */
    private int calcIntervals(int i)
    {
	//Calculates space between figures. 
	int space = ( contentPane.getWidth() - numOfFigures*themesImage[7].getIconWidth())/(numOfFigures+1);
	//Return location. 
	return space + (themesImage[7].getIconWidth() + space)*i;
    }

    /**
     * Start "Sound" animation. 
     * 
     * @param index   - figure's index. 
     * @param millSec - duration. 
     */
    public void animateSound(int index, long millSec)
    {
	if ( index < 1 || index > numOfSteps)
	    return;
	AnimateRunnable animRun = null;    	    
	
	//if X figure. 
	if ( taskString.charAt( index-1) != 'X')
	{    
	    animRun = new AnimateRunnable(motionPnl, 
			    	          themesImage[10], 
		                          themesImage[9],
		                          index-1,
		                          millSec,
		                          false);
	}
	else //if regular figure. 
	{
	    animRun = new AnimateRunnable( motionPnl, 
	    	                           themesImage[14], 
                                           themesImage[13],
                                           index-1,
                                           millSec, 
                                           false );
	}
	
	
	//Create thread and run it. 
	Thread animThread = new Thread( animRun);
	animThread.start();
    }

    /**
     * Start "Happy" animation. 
     * 
     * @param index   - figure's index. 
     * @param millSec - duration. 
     */
    public void animateHappy(int index, long millSec)
    {
	if ( index < 1 || index > numOfSteps)
	    return;
	
	AnimateRunnable animRun = null;   
	//if X figure.
	if ( taskString.charAt( index-1) != 'X')
	{  
	    animRun = new AnimateRunnable( motionPnl, 
		   		           themesImage[7], 
		                           themesImage[9],
		                           index-1,
		                           millSec,
		                           false );
	}
	else //if regular figure.
	{
	    animRun = new AnimateRunnable( motionPnl, 
		                           themesImage[11], 
                                           themesImage[13],
                                           index-1,
                                           millSec,
                                           false );
	}
	
	//Create thread and run it. 
	Thread animThread = new Thread( animRun);
	animThread.start();
    }

    /**
     * Start "Cry" animation. 
     * 
     * @param index   - figure's index. 
     * @param millSec - duration. 
     */
    public void animateCry(int index, long millSec)
    {
	if ( index < 1 || index > numOfSteps)
	    return;
     
	AnimateRunnable animRun = null;   
	
	//if X figure 
	if ( taskString.charAt( index-1) != 'X')
	{  
	    animRun = new AnimateRunnable( motionPnl, 
		   		           themesImage[8], 
		                           themesImage[9],
		                           index-1,
		                           millSec,
		                           false );
	}
	else // if regular figure 
	{
	    animRun = new AnimateRunnable( motionPnl, 
		                           themesImage[12], 
                                           themesImage[13],
                                           index-1,
                                           millSec, 
                                           false );   
	}
	
	//Creates thread and run it. 
	Thread animThread = new Thread( animRun);
	animThread.start();
    }
    
    /**
     * Moves another step in progress bar.  
     * 
     */
    public void moveNextStep()
    {
	progressPnl.setImage( themesImage[3]);
	int totalWay = 700;


	try
	{
	    //Sleep few millisec
	    Thread.sleep(600);
	}
	catch (InterruptedException e) 
	{
	    e.printStackTrace();
	}

	//Calculates step size. 
	int prevStep = (totalWay/(numOfSteps+1))*(currentStep);
	int step     = (totalWay/(numOfSteps+1))*(++currentStep);
	int delata   = step - prevStep;

	//If limmit reached, don't make next step. 
	//Otherwise calculate step size. 
	if (currentStep <= numOfSteps)
	{	   
	    if (delata>40) 
	    {
		progressPnl.setBounds( step - (delata/2), 20, themesImage[3].getIconWidth(), themesImage[3].getIconHeight());
		try
		{
		    Thread.sleep(600);
		}
		catch (InterruptedException e) 
		{
		    e.printStackTrace();
		}	
	    }
	    progressPnl.setBounds( step , 20, themesImage[3].getIconWidth(), themesImage[3].getIconHeight());
	}
	progressPnl.setImage( themesImage[2]);
	themesImage[3].getImage().flush();
    }
    
    /**
     * Switch start sign to stop sign 
     *
     */
    public void changeToStopSign()
    {
	signPnl.setImage( themesImage[5]);
    }
    
    /**
     * Switch stop sign to start sign 
     *
     */
    public void changeToStartSign()
    {
	signPnl.setImage( themesImage[4]);
    }

    /**
     * Start "Happy face" animation. 
     * 
     * @param millSec - duration. 
     */
    public void animateHappyFace( double millSec)
    {
	
	PaintSurface tempArray[] = new PaintSurface[1]; 
	tempArray[0] = facePnl;
	tempArray[0].setBounds( 370,160, themesImage[0].getIconWidth(),themesImage[0].getIconHeight());
	
	AnimateRunnable animRun =  new AnimateRunnable( tempArray, 
	                                                themesImage[1], 
		                                        themesImage[0],
		                                        0,
		                                        (long)millSec,
		                                        true );

	//Create thread and run it.
	Thread animThread = new Thread( animRun);
	animThread.start();
    }

    /**
     * Starts exit dialog 
     */
    protected void processWindowEvent( WindowEvent e)
    {
	if ( e.getID() == WindowEvent.WINDOW_CLOSING)
	{	    
	    int exit = JOptionPane.showConfirmDialog( this, 
		                                      "Are you sure ?",
		                                      "Exit",
		                                      JOptionPane.YES_NO_OPTION); 
	    	    
	    if ( exit == JOptionPane.YES_OPTION)
		dispose();
	}
	else 
	{
	    super.processWindowEvent( e);
	}
    }
    
    /**
     * Creates themes object
     * @param themeName - String. 
     * @return Theme 
     */
    private Theme createTheme( String themeName)
    {
	//Mouse theme. 
	if ( themeName.toLowerCase().equals( Theme.THEME_MOUSE_NAME)) 
	    return ThemeMouse.ThemeMouseFactory.getNewItem();
	//Dragon theme.
	if ( themeName.toLowerCase().equals( Theme.THEME_DRAGON_NAME))
	    return ThemeDragon.ThemeDragonFactory.getNewItem();	
	return null;
    }
}

//Listeners. 

/** 
 * Invoked by windows resizing 
 */
class ResizeListener extends ComponentAdapter
{
    private JFrame mainFrame; 
    private PaintSurface contentPane;
        
    public ResizeListener( JFrame frame, PaintSurface panel) 
    {
	mainFrame   = frame;
	contentPane = panel; 
    }
    
    public void componentResized( ComponentEvent e)
    {
	//Gets window size 
	int width = mainFrame.getWidth();
	int heigh = mainFrame.getHeight();
	
	//Gets screen size 
	int screenX = contentPane.getWidth(); 
	int screenY = contentPane.getHeight();
	
	//Calc new location 
	int newX = (width - screenX)/2; 
	int newY = (heigh - screenY)/2;

	contentPane.setLocation( newX, newY);
    }
}

/**
 *Invoked by Mouse.
 */
class StartStopMouseListener implements MouseListener
{
    private PaintSurface[] motionPnl;
    private int numOfFigures;
    private ImageIcon stopedFigure;
    private ImageIcon stopedXFigure;
    private String figureString; 

    private boolean isStoped; 

    public StartStopMouseListener( PaintSurface[] imgPanels, 
                                   ImageIcon stopFig,
	                           ImageIcon stopXFig,
	                           String    str) 
    {
	motionPnl     = imgPanels; 
	numOfFigures  = str.length();
	stopedFigure  = stopFig;
	stopedXFigure = stopXFig;
	figureString  = str;
	isStoped      = true;
    }

    public void mouseClicked(MouseEvent arg0) 
    {		
	for(int i=0; i< numOfFigures; i++)
	{
	    if ( figureString.charAt(i) != 'X')
		motionPnl[i].setImage( stopedFigure);
	    else 
		motionPnl[i].setImage( stopedXFigure);
	}
	isStoped = !isStoped; 
    }

    //Unimplemented methods.
    public void mouseEntered(MouseEvent arg0){} 
    public void mouseExited(MouseEvent arg0){} 
    public void mousePressed(MouseEvent arg0){} 
    public void mouseReleased(MouseEvent arg0){}    
}

//Runnable 

/**
 * Animation's thread.
 */
class AnimateRunnable implements Runnable
{
    private int index;
    private long millSec;
    private PaintSurface[] motionPnl;
    private ImageIcon motionFigure; 
    private ImageIcon stopedFigure;
    private boolean makeInvisibleInEnd;

    public AnimateRunnable( PaintSurface[] imgPanels, 
	                    ImageIcon motionFig,
	                    ImageIcon stopFig,
	                    int indx, 
	                    long mSec, 
	                    boolean makeInvisible) 
    {
	index              = indx;
	millSec            = mSec;
	motionPnl          = imgPanels; 
	motionFigure       = motionFig;
	stopedFigure       = stopFig;
	makeInvisibleInEnd = makeInvisible;

    }

    public void run() 
    {
	motionPnl[index].setImage( motionFigure);
	try 
	{
	    Thread.sleep( millSec);
	} 
	catch (InterruptedException e) 
	{	
	    e.printStackTrace();
	}
	motionPnl[index].setImage( stopedFigure);
	
	if ( makeInvisibleInEnd) 
	{
	    Rectangle rec = motionPnl[index].getBounds();
	    rec.width  = 0;
	    rec.height = 0;
	    motionPnl[index].setBounds( rec);
	}
    }

}