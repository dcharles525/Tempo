public class Temperature : Gtk.Widget {

  public Temperature () {}

  public double getTemperatureData () {

    Sense senseInstance = new Sense ();
    
    double rawTemperature = senseInstance.temperatureStruct.averageCoreTemp;
    double fahrenheit = (rawTemperature / 1000) * (9.00 / 5.00) + 32;

    return fahrenheit;

  }

}
