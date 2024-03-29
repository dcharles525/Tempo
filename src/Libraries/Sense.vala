public class Sense {
  
  public struct core {
    public string coreLabel;
    public double currentTemp;
  }

  public struct temperature {
    public string cpuType; //coretemp (Intel) or k10temp (AMD)
    public double averageCoreTemp;
    public Array<core?> rawData; 
  }

  public temperature temperatureStruct;
  private double totalTemperature = 0;
  private int temperatureCounter = 1;

  public Sense () {
    
    this.temperatureStruct = { "", 0, new Array<core?> () };
    this.testHwmon ();
  
  }

  private void testHwmon () {

    this.temperatureStruct.rawData.set_size (0);
    int hwmonCounter = 0;

    while (true) {
      
      string hwmonNamePath = "/sys/class/hwmon/hwmon".concat (
        hwmonCounter.to_string (),
        "/name"
       );
      
      if (!FileUtils.test (hwmonNamePath, FileTest.EXISTS)) 
        break;

      //Note we strip out newlines
      string cpuName = openFile (hwmonNamePath).replace ("\n","");

      //If we find either intel or amd chip
      if (cpuName == "coretemp" || cpuName == "k10temp") {

        this.temperatureStruct.cpuType = cpuName;
        this.parseRawTemp (
          "/sys/class/hwmon/hwmon".concat (hwmonCounter.to_string (), "/" )
        );

      }
        
      hwmonCounter++;

    }

  }

  private void parseRawTemp (string path) {
  
    while (true) {
      
      string coreTemperaturePath = path.concat (
        "temp", 
        this.temperatureCounter.to_string (),
        "_input"
      );
      string coreLabelPath = path.concat (
        "temp", 
        this.temperatureCounter.to_string (),
        "_label"
      );

      if (!FileUtils.test (coreTemperaturePath, FileTest.EXISTS)) 
        break;

      double coreTemperature = double.parse (openFile (coreTemperaturePath));
      string coreLabel = openFile (coreLabelPath).replace ("\n","");
    
      this.totalTemperature += coreTemperature;
      this.temperatureCounter++;
      core core = { coreLabel, coreTemperature };

      this.temperatureStruct.rawData.append_val (core);
      this.temperatureStruct.averageCoreTemp = this.totalTemperature / 
        (this.temperatureCounter - 1);

    }
  
  }
  
  private string openFile (string filename) {

    try {
      
      string read;
      FileUtils.get_contents (filename, out read);
      
      return read;

    } catch (FileError e) {
      
      stderr.printf ("%s\n", e.message);
      return "0";

    }

  }

}
