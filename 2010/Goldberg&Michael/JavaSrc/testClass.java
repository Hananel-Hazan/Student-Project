
public class testClass 
{
   public static void main(String[] args) 
   {
       MainFrame m = new MainFrame("XXXXX",8, "dragon");
       m.animateHappy(2, 3000);
       m.animateCry(1, 3000);
       m.animateSound(3, 3000);
       m.animateHappyFace(3000);
       
       //m.moveNextStep();
       for ( int i = 0; i < 20; i++)
       {
//	   try 
//	   {
//	       Thread.sleep(1000);
//	   }
//	   catch (InterruptedException e) 
//	   {
//	       // TODO Auto-generated catch block
//	       e.printStackTrace();
//	   }
//	   m.moveNextStep();
       }
       
   }
}
