public class Tempo : Gtk.Application {

  public Tempo () {

    Object (
      application_id: "com.github.dcharles525.tempo",
      flags: ApplicationFlags.FLAGS_NONE
    );

  }

  protected override void activate () {
    
    var headerbar = new Gtk.HeaderBar () {
      show_close_button = true,
      title = "Tempo"
    };

    var header_context = headerbar.get_style_context ();
    header_context.add_class (Gtk.STYLE_CLASS_FLAT);

    var main_window = new Gtk.ApplicationWindow (this) {
      default_height = 300,
      default_width = 300,
      title = "Tempo",
      resizable = false
    };
    
    main_window.set_titlebar (headerbar);
    main_window.show_all ();

  }

  public static int main (string[] args) {

    return new Tempo ().run (args);

  }

}
