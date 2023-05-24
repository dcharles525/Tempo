public class TempText : Gtk.Widget {

  public TempText () { }

  public Gtk.Box get_box () {

    return this.renderTemperatureData ();
  
  }

  private Gtk.Box renderTemperatureData () {

    var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
    hbox.homogeneous = true;

    Gtk.Label temperatureLabel = new Gtk.Label (this.getFormattedTemp ());
    temperatureLabel.get_style_context ().add_class ("temperature-font");

    Timeout.add (1000, () => {
      temperatureLabel.label = this.getFormattedTemp ();
      return true;
    });

    hbox.add (temperatureLabel);

    return hbox;
  
  }

  private string getFormattedTemp () {
  
    Temperature temperature = new Temperature ();

    return "%0.0f°F".printf (temperature.getTemperatureData ());
  
  }

}
