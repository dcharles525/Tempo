//valac --pkg gtk+-3.0 --pkg gee-0.8 --pkg caroline-0.3 see.vala Sense.vala

using Gtk;
using Gee;
using Cairo;

public void main (string[] args) {

  //Setting up the GTK window
  Gtk.init (ref args);
  var window = new Gtk.Window ();
  window.set_position (Gtk.WindowPosition.CENTER);
  window.set_default_size(250,250);

  //Building grid to put the widget into
  Gtk.Grid mainGrid = new Gtk.Grid ();
  mainGrid.orientation = Gtk.Orientation.VERTICAL;

  int benchNumber = 10;

  GenericArray<double?> y = new GenericArray<double?> ();
  GenericArray<double?> y2 = new GenericArray<double?> ();
  GenericArray<double?> y3 = new GenericArray<double?> ();
  GenericArray<double?> x = new GenericArray<double?> ();
  Array<string> cArray = new Array<string> ();
  Array<GenericArray<double?>> yArray = new Array<GenericArray<double?>> ();
  
  for (int i = 0; i < benchNumber; i++) {
  
    y.add (0);
    x.add (i);
    y2.add (120);
    y3.add (32);

  }

  cArray.append_val ("smooth-line");
  yArray.append_val (y);
  
  cArray.append_val ("scatter");
  yArray.append_val (y);

  cArray.append_val ("line");
  yArray.append_val (y2);
  
  cArray.append_val ("line");
  yArray.append_val (y3);

  var carolineWidget = new Caroline.without_colors (
    x, //dataX
    yArray, //dataY
    cArray, //chart type
    true, //yes or no for generateColors function (needed in the case of the pie chart),
    true,
    false // yes or no for scatter plot labels
   );

   //Add the Caroline widget tp the grid
   mainGrid.attach (carolineWidget, 0, 0, 1, 1);
   mainGrid.set_row_homogeneous (true);
   mainGrid.set_column_homogeneous (true);

   window.add (mainGrid);
   window.destroy.connect (Gtk.main_quit);
   window.show_all ();

   Timeout.add (5000, () => {

     Sense sense_instance = new Sense ();
     string cpu_type = sense_instance.temperature_struct.cpu_type;
     double raw_temperature = sense_instance.temperature_struct.average_core_temp;
     double fahrenheit = (raw_temperature/1000) * (9.00/5.00) + 32; 
    
     for (int k = 0; k < benchNumber; k++) {

       y[k] = y[k+1];

     }

     y[9] = fahrenheit;
     
     carolineWidget.updateData (x, y, "scatter", false, true, 1);
     carolineWidget.updateData (x, y, "smooth-line", false, true, 0);
     carolineWidget.queue_draw ();

     return true;

   });

   var m = new MainLoop();
   m.run();
   Gtk.main ();

}
