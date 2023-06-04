public class TempText : Gtk.Widget {

  public TempText () { }

  public Gtk.Box get_box () {

    return this.renderTemperatureData ();
  
  }

  private Gtk.Box renderTemperatureData () {

    var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
    hbox.homogeneous = true;

    Gtk.Label temperatureLabel = new Gtk.Label (this.getFormattedTemp ());
    this.setTempStyle (temperatureLabel);

    Timeout.add (1000, () => {

      this.setTempStyle (temperatureLabel);
      temperatureLabel.label = this.getFormattedTemp ();
      return true;

    });

    hbox.add (temperatureLabel);

    return hbox;
  
  }

  private void setTempStyle (Gtk.Label temperatureLabel) {

    Temperature temperature = new Temperature ();

    this.removeAllTempStyle (temperatureLabel);

    if (temperature.getTemperatureData () <= 90)
      temperatureLabel.get_style_context ().add_class ("blue-text");
    else if (
      temperature.getTemperatureData () > 90 && 
      temperature.getTemperatureData () <= 100
    )
      temperatureLabel.get_style_context ().add_class ("yellow-text");
    else if (
      temperature.getTemperatureData () > 100 && 
      temperature.getTemperatureData () <= 110
    )
      temperatureLabel.get_style_context ().add_class ("orange-text");
    else 
      temperatureLabel.get_style_context ().add_class ("red-text");

  }

  private void removeAllTempStyle (Gtk.Label temperatureLabel) {
        
    temperatureLabel.get_style_context ().remove_class ("blue-text");
    temperatureLabel.get_style_context ().remove_class ("yellow-text");
    temperatureLabel.get_style_context ().remove_class ("orange-text");
    temperatureLabel.get_style_context ().remove_class ("red-text");

  }

  private string getFormattedTemp () {
  
    Temperature temperature = new Temperature ();

    return _("%0.0f°F".printf (temperature.getTemperatureData ()));
  
  }

}
