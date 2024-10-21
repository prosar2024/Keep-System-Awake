uses java.awt.*
uses java.lang.*
uses javax.swing.*
uses java.awt.event.*
uses java.math.BigDecimal
uses java.net.URI

/**
 * Author : Aravind R Pillai
 * Date : 12 May 2021
 */
var executionTime : Double = 60
var stopButtonClicked = false
var mouseThread : Thread
var frame = new JFrame("Keep System Alive")

var timeInputLabel = new JLabel("How long (in mins) do you want to keep the system active? ")
timeInputLabel.setBounds(20, 10, 1000, 30)

var timeInput = new JTextField()
timeInput.setText(executionTime as String)
timeInput.setBounds(20, 50, 100, 30)

var timeInputSuffix = new JLabel("Minutes. ")
timeInputSuffix.setBounds(125, 50, 100, 30)

var timeInputError = new JLabel()
timeInputError.setBounds(200, 50, 200, 30)

var notifyCheckbox = new JCheckBox("Notify me when the program execution ends.")
notifyCheckbox.setBounds(20, 80, 1000, 30)
notifyCheckbox.Selected = true

var startButton = new JButton("Start")
startButton.setBounds(20, 120, 80, 30)

var closeButton = new JButton("Stop")
closeButton.setBounds(140, 120, 80, 30)
closeButton.setEnabled(false)

var startTimeLabel = new JLabel()
startTimeLabel.setBounds(20, 150, 1000, 50)

var endTimeLabel = new JLabel()
endTimeLabel.setBounds(20, 170, 1000, 50)


var ftr = "<html>Credits: Aravind R Pillai | Visit <a href=\"\">www.aravindrpillai.com</a> for more details.</html>"
var footer = new JLabel(ftr)
footer.setCursor(new Cursor(Cursor.HAND_CURSOR))
footer.setBounds(20, 210, 1000, 30)


var dim = Toolkit.getDefaultToolkit().getScreenSize()
frame.setLocation(dim.width / 3 - frame.getSize().width, dim.height / 3 - frame.getSize().height)

frame.setResizable(false)
frame.setSize(500, 300)
frame.setLayout(null)
frame.setVisible(true)

frame.add(timeInputLabel)
frame.add(timeInput)
frame.add(timeInputSuffix)
frame.add(timeInputError)
frame.add(notifyCheckbox)
frame.add(startButton)
frame.add(closeButton)
frame.add(startTimeLabel)
frame.add(endTimeLabel)
frame.add(new JSeparator())
frame.add(footer)
frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);



startButton.addActionListener(new ActionListener() {
  @Override
  public function actionPerformed(e : ActionEvent) : void {
    stopButtonClicked = false
    var error : Exception = null
    try {
      executionTime = Float.parseFloat(timeInput.getText()) * 60.00 * 1000.00
    } catch (ex : Exception) {
      error = new Exception("Invalid Time Entered")
    }

    if (error == null) {
      var startTime = new Date()
      var isLoopInsideTimeFrame = (new Date().Time - startTime.Time) < (executionTime)
      startTimeLabel.setText("<html><font color=\"green\">Process started at " + startTime +"</font></html>")
      mouseThread = new Thread(new MouseHandler(startTime, executionTime), "My mouse handling thread")
      mouseThread.start()
      timeInputError.setText("")
      closeButton.setEnabled(true)
      startButton.setEnabled(false)
    } else {
      timeInputError.setText("<html><font color=\"red\"> [" + error.Message + "]</font></html>")
    }
  }
})


closeButton.addActionListener(new ActionListener() {
  @Override
  public function actionPerformed(e : ActionEvent) : void {
    stopButtonClicked = true
    closeButton.setEnabled(false)
    endTimeLabel.setText("<html><font color=\"red\">Stopping the program. Please wait.</font></html>")
  }
})

frame.addWindowListener(new WindowAdapter() {
  public function windowClosing(e : WindowEvent) : void {
    if(mouseThread != null){
      mouseThread.stop()
    }
  }
})

footer.addMouseListener(new MouseAdapter() {
  public function mouseClicked(e : MouseEvent) : void {
    Desktop.getDesktop().browse(new URI("www.aravindrpillai.com"))
  }
})


public class MouseHandler implements Runnable {

  var _startTime : Date
  var _executionTime : Double
  var screenDimensions = java.awt.Toolkit.getDefaultToolkit().getScreenSize()
  var const = 200

  construct(startTime : Date, execTime : Double) {
    _startTime = startTime
    _executionTime = execTime
  }

  public function run() : void {
    var isLoopInsideTimeFrame = (new Date().Time - _startTime.Time) < (_executionTime)

    var x1 = ((screenDimensions.Width / 2) - const) as int
    var y1 = (screenDimensions.Height / 2) as int
    var flap = true
    var robot = new java.awt.Robot()

    while (!stopButtonClicked and isLoopInsideTimeFrame) {
      var elapsedTime = new BigDecimal((new Date().Time - (_startTime.Time+_executionTime) ) / 60000)
      var roundOffVal = (((elapsedTime.setScale(1, BigDecimal.ROUND_HALF_EVEN))*(-1)))
      if(roundOffVal < 1){
        endTimeLabel.setText("Program will execute for less than a minute.")
      }else {
        endTimeLabel.setText("Program will execute for " + roundOffVal + " more minute(s)")
      }

      x1 = flap ? (x1 + (const * 2)) : (x1 - (const * 2))
      flap = !flap
      robot.mouseMove(x1, y1)

      Thread.sleep(10000)
      isLoopInsideTimeFrame = (new Date().Time - _startTime.Time) < (_executionTime)
    }
    var stopMethod = stopButtonClicked ? "Manually Stopped" : "Auto Stop"
    endTimeLabel.setText("Program ended at "+new Date()+" | "+stopMethod)
    startButton.setEnabled(true)
    if((not stopButtonClicked) and notifyCheckbox.Selected){
      makeBeep()
    }
  }
  
  function makeBeep(){
    var buf = new byte[1]
    var af = new javax.sound.sampled.AudioFormat(44100 as float, 8, 1, true, false)
    var sdl = javax.sound.sampled.AudioSystem.getSourceDataLine(af)
    sdl.open()
    sdl.start()
    var beepCount = 5
    var j = 0
    while(j <= beepCount){
      var i = 0
      while (i < 500 * 44100 as float / 1000) {
        var angle = i / (44100 as float / 440) * 2.0 * Math.PI
        buf[0] = (Math.sin(angle) * 100) as byte
        sdl.write(buf, 0, 1)
        i++
      }
      Thread.sleep(700)
      j++
    }
    sdl.drain()
    sdl.stop()
  }
}

