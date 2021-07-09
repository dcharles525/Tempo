//============================================================+
// File name   : Sense.vala
// Last Update : 2020-7-26
//
// Version: 0.0.1
//
// Description : This is a small abstraction layer for the /sys/class/hwmon/ modules in the linux kernel to extract 
// temperature data. Our Temperature struct has an average_core_temp which is calculated within, and seemed to be a 
// bit more accurate, however the first core within the raw_data file seems to be the one calculated by the kernel 
// driver. Currently this only supports Intel and AMD chips, but I might add more as needed.
//
// NOTE: I have not tested on an amd chip. 
//
// Author: David Johnson
//============================================================+

public class Sense{
  
  public struct Core{
    public string core_label;
    public double current_temp;
  }

  public struct Temperature {
    public string cpu_type; //coretemp (Intel) or k10temp (AMD)
    public double average_core_temp;
    public Array<Core?> raw_data; 
  }

  public Temperature temperature_struct;

  public Sense () {
    
    Array<Core?> core_array = new Array<Core?>();

    temperature_struct = {
      "",
      0,
      core_array
    };

    collect_data();
  
  }
  
  /*
  * Opens files 
  *
  * Small private function to open kernel files to get our data from.
  *
  * @param string filename
  * @return string
  */ 
  private string open_file (string filename) {

    try {
      
      string read;
      FileUtils.get_contents (filename, out read);
      
      return read;

    } catch (FileError e) {
      
      stderr.printf ("%s\n", e.message);
      return "0";

    }

  }
  
  /*
  * Collects Temperature Data 
  *
  * The function first begins traversing the hwmon directories looking for the processor, once found we find the 
  * real average of each core and set information to our struct. 
  *
  * @return void
  */ 
  public void collect_data () {
    
    //clear array if collect_data is in a loop
    this.temperature_struct.raw_data.set_size(0);
    double total_temperature = 0;
    int hwmon_counter = 0, temperature_counter = 1;
    bool hwmon_traversing = true, core_traversing = true;

    while (hwmon_traversing) {
      
      string path = "/sys/class/hwmon/hwmon".concat(hwmon_counter.to_string(),"/");
      string hwmon_name_path = path.concat("name");

      if (FileUtils.test (hwmon_name_path, FileUtils.EXISTS)) {
        
        //Note we strip out newlines
        string cpu_name = open_file (hwmon_name_path).replace("\n","");
        
        //If we find either intel or amd chip
        if (cpu_name == "coretemp" || cpu_name == "k10temp"){

          this.temperature_struct.cpu_type = cpu_name;

          while (core_traversing) {
            
            string core_temperature_path = path.concat("temp",temperature_counter.to_string(),"_input");
            string core_label_path = path.concat("temp",temperature_counter.to_string(),"_label");

            if (FileUtils.test (core_temperature_path, FileUtils.EXISTS)) {

              double core_temperature = double.parse (open_file(core_temperature_path));
              //Note we strip out newlines
              string core_label = open_file(core_label_path).replace("\n","");
            
              total_temperature += core_temperature;
              temperature_counter++;
              
              Core core = {
                core_label,
                core_temperature,
              };

              this.temperature_struct.raw_data.append_val (core);

            } else 
              core_traversing = false;

          }
          
          //Gets the true average based on the data, seems to be fairly accurate.
          this.temperature_struct.average_core_temp = total_temperature / (temperature_counter - 1);

        }

        hwmon_counter++;

      }else 
        hwmon_traversing = false;
    }

  }

}

/*
  
  //Example of how to handle the class.

  void main (string[] args) {
  
  Sense sense_instance = new Sense();
  
  string cpu_type = sense_instance.temperature_struct.cpu_type;
  double raw_temperature = sense_instance.temperature_struct.average_core_temp;
  double fahrenheit = (raw_temperature/1000) * (9.00/5.00) + 32;

  stdout.printf ("%s \n", "|||||||||||||||||| CPU INFO |||||||||||||||||||||");
  stdout.printf ("%s | %f \n", cpu_type, fahrenheit);

  stdout.printf ("%s \n", "|||||||||||||||||| CORE INFO |||||||||||||||||||||");

  for (int i = 0; i < sense_instance.temperature_struct.raw_data.length; i++) {
  
    string core_label = sense_instance.temperature_struct.raw_data.index(i).core_label;
    double current_temperature = sense_instance.temperature_struct.raw_data.index(i).current_temp;
    
    current_temperature = (current_temperature/1000) * (9.00/5.00) + 32;

    stdout.printf ("%s | Current: %f \n", core_label, current_temperature);

  }

}
*/
