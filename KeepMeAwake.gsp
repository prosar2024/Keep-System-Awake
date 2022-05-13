uses java.io.InputStreamReader
uses java.io.BufferedReader
uses java.lang.Float

/**
 * Author : Aravind R Pillai (12 May 2022)
 * Reach me @ www.aravindrpillai.com
 */
 
System.out.println("\n");
System.out.println("#--------------  KEEP  SYSTEM  AWAKE  ---------------#");
System.out.println("#   Visit www.aravindrpillai.com for more details    #");
System.out.println("#----------------------------------------------------#");

var bfn = new BufferedReader(new InputStreamReader(System.in))
System.out.print("\nHow long (in mins) do you want to keep your system awake: ");
var limit = bfn.readLine();
var executionTime = Float.parseFloat(limit) * 60.00 * 1000.00
var screenDimensions = java.awt.Toolkit.getDefaultToolkit().getScreenSize()
var const = 200
var startTime = new Date()

System.out.println("\nStarting Process at : "+startTime)
System.out.println("\nAll set...! You are good to leave your system now.")
System.out.println("In every 10 seconds the mouse pointer will be moved.")
System.out.println("Process will be executing for "+limit+" minutes\n")

var x1 = ((screenDimensions.Width / 2) - const) as int
var y1 = (screenDimensions.Height / 2) as int
var flap = true
var robot = new java.awt.Robot()
while ((new Date().Time - startTime.Time) < (executionTime)) {
  x1 = flap ? (x1 + (const * 2)) : (x1 - (const * 2))
  flap = !flap
  robot.mouseMove(x1, y1)
  Thread.sleep(10000)
}
System.out.println("Completed at : "+new Date()+"\n")