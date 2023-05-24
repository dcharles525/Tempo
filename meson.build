project ('com.github.dcharles525.Tempo', 'vala', 'c')

executable (
  meson.project_name (),
  'src/Tempo.vala',
  'src/Libraries/Sense.vala',
  'src/Services/Temperature.vala',
  'src/Widgets/TempText.vala',
  dependencies: [
    dependency ('gtk+-3.0')
  ],
  install: true
)

install_data (
  'data' / 'tempo.desktop',
  install_dir: get_option ('datadir') / 'applications',
  rename: meson.project_name () + '.desktop'
)

install_data(
  'data' / 'tempo.metainfo.xml',
  install_dir: get_option ('datadir') / 'metainfo',
  rename: meson.project_name () + '.metainfo.xml'
)

install_data (
  'data' / 'gschema.xml',
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
  rename: meson.project_name () + '.gschema.xml'
)

meson.add_install_script ('meson/post_install.py')

