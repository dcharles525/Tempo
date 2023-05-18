public class Tempo : Gtk.Application {

  const string path = "/storage/Code/Tempo/src/Styles/TempText.css";

  public Tempo () {

    Object (
      application_id: "com.github.dcharles525.tempo",
      flags: ApplicationFlags.FLAGS_NONE
    );

  }

  protected override void activate () {
    
    Gtk.CssProvider cssProvider = new Gtk.CssProvider ();

    if (!FileUtils.test (path, FileTest.EXISTS))
      return;
      
    Gtk.Settings.get_default ().set (
      "gtk-application-prefer-dark-theme", 
      true
    );

    try {
      
      cssProvider.load_from_path (path);
      Gtk.StyleContext.add_provider_for_screen (
        Gdk.Screen.get_default (), 
        cssProvider, 
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
      );
    
    } catch (Error e) {
      
      error ("Cannot load CSS stylesheet: %s", e.message);

    }

    Gtk.HeaderBar headerbar = new Gtk.HeaderBar () {
      title = "Tempo"
    };

    var headerContext = headerbar.get_style_context ();
    headerContext.add_class (Gtk.STYLE_CLASS_FLAT);

    Gtk.ApplicationWindow mainWindow = new Gtk.ApplicationWindow (this) {
      default_height = 200,
      default_width = 200,
      title = "Tempo",
      resizable = false
    };
    
    TempText tempText = new TempText ();
    mainWindow.set_titlebar (headerbar);
    mainWindow.add (tempText.get_box ());
    mainWindow.show_all ();

  }

  public static int main (string[] args) {

    return new Tempo ().run (args);

  }

}
