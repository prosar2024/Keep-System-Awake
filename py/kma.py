import tkinter as tk
from tkinter import messagebox
import threading
import time
import pyautogui
import datetime
import webbrowser
import winsound

# Initialize global variables
execution_time = 3600000  # default in ms - 60 mins
stop_button_clicked = False
mouse_thread = None

# Function to handle the mouse movement
def move_mouse(start_time, exec_time):
    global stop_button_clicked
    screen_width, screen_height = pyautogui.size()
    x1 = screen_width // 2 - 200
    y1 = screen_height // 2
    flap = True

    while not stop_button_clicked and (datetime.datetime.now() - start_time).total_seconds() * 1000 < exec_time:
        elapsed_time = (exec_time - (datetime.datetime.now() - start_time).total_seconds() * 1000) / 60000
        end_time_label.config(text=f"Program will execute for {round(elapsed_time, 1)} more minute(s)" if elapsed_time > 1 else "Program will execute for less than a minute.")
        
        x1 = x1 + (200 * 2) if flap else x1 - (200 * 2)
        pyautogui.moveTo(x1, y1)
        flap = not flap
        time.sleep(30)  # Move every 30 seconds

    stop_method = "Manually Stopped" if stop_button_clicked else "Auto Stop"
    end_time_label.config(text=f"Program ended at {datetime.datetime.now()} | {stop_method}")
    start_button.config(state=tk.NORMAL)
    if not stop_button_clicked and notify_var.get():
        for _ in range(5):
            winsound.Beep(440, 700)
            time.sleep(0.5) 

# Start button action
def start_program():
    global execution_time, stop_button_clicked, mouse_thread
    stop_button_clicked = False

    try:
        execution_time = float(time_input.get()) * 60 * 1000  # Convert to milliseconds
    except ValueError:
        time_input_error.config(text="Invalid Time Entered", fg="red")
        return

    start_time = datetime.datetime.now()
    start_time_label.config(text=f"Process started at {start_time}", fg="green")

    mouse_thread = threading.Thread(target=move_mouse, args=(start_time, execution_time))
    mouse_thread.start()

    time_input_error.config(text="")
    close_button.config(state=tk.NORMAL)
    start_button.config(state=tk.DISABLED)

# Stop button action
def stop_program():
    global stop_button_clicked
    stop_button_clicked = True
    close_button.config(state=tk.DISABLED)
    end_time_label.config(text="Stopping the program. Please wait.", fg="red")

# Open the website link
def open_link(event):
    webbrowser.open_new("http://www.aravindrpillai.com")

# Create the main window
root = tk.Tk()
root.title("Keep System Awake")
root.geometry("450x250")
root.resizable(False, False)

# UI Elements
time_input_label = tk.Label(root, text="How long (in mins) do you want to keep the system active?")
time_input_label.place(x=20, y=10)

time_input = tk.Entry(root)
time_input.insert(0, str(execution_time / (60 * 1000)))  # Default time in mins
time_input.place(x=20, y=50)

time_input_suffix = tk.Label(root, text="Minutes.")
time_input_suffix.place(x=125, y=50)

time_input_error = tk.Label(root)
time_input_error.place(x=200, y=50)

notify_var = tk.BooleanVar(value=True)
notify_checkbox = tk.Checkbutton(root, text="Notify me when the program execution ends.", variable=notify_var)
notify_checkbox.place(x=20, y=80)

start_button = tk.Button(root, text="Start", command=start_program)
start_button.place(x=20, y=120)

close_button = tk.Button(root, text="Stop", command=stop_program, state=tk.DISABLED)
close_button.place(x=140, y=120)

start_time_label = tk.Label(root)
start_time_label.place(x=20, y=150)

end_time_label = tk.Label(root)
end_time_label.place(x=20, y=170)

footer = tk.Label(root, text="Credits: Aravind R Pillai | Visit www.aravindrpillai.com", cursor="hand2", fg="blue")
footer.place(x=20, y=210)
footer.bind("<Button-1>", open_link)

root.mainloop()
