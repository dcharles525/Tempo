project ('com.github.dcharles525.Tempo', 'vala', 'c')
i18n = import ('i18n')

# Set our translation domain
add_global_arguments ('-DGETTEXT_PACKAGE="@0@"'.format (
  meson.project_name ()
), language:'c')

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
  'data' / 'Tempo.desktop.in',
  type: 'desktop',
  rename: meson.project_name () + '.desktop',
  install_dir: get_option ('datadir') / 'applications'
)

install_data(
  'data' / 'Tempo.metainfo.xml.in',
  install_dir: get_option ('datadir') / 'metainfo',
  rename: meson.project_name () + '.metainfo.xml'
)

install_data (
  'data' / 'gschema.xml',
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
  rename: meson.project_name () + '.gschema.xml'
)

# Install our icons in all the required sizes
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
  install_data(
    'data' / i + '.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
    rename: meson.project_name() + '.svg'
  )
  install_data(
    'data' / i + '.svg',
    install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
    rename: meson.project_name() + '.svg'
  )
endforeach

meson.add_install_script ('meson/post_install.py')

i18n.merge_file (
  input: 'data' / 'Tempo.desktop.in',
  output: meson.project_name () + '.desktop',
  po_dir: meson.source_root () / 'po',
  type: 'desktop',
  install: true,
  install_dir: get_option ('datadir') / 'applications'
)

i18n.merge_file (
  input: 'data' / 'Tempo.metainfo.xml.in',
  output: meson.project_name () + '.metainfo.xml',
  po_dir: meson.source_root () / 'po',
  install: true,
  install_dir: get_option ('datadir') / 'metainfo'
)

subdir ('po')
