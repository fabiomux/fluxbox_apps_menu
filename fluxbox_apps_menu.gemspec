# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluxbox_apps_menu/version'

Gem::Specification.new do |spec|
  spec.name          = 'fluxbox_apps_menu'
  spec.version       = FluxboxAppsMenu::VERSION
  spec.authors       = ['Fabio Mucciante']
  spec.email         = ['fabio.mucciante@gmail.com']
  spec.summary       = %q{Build the Fluxbox apps menu.}
  spec.description   = %q{This script reads the .desktop files installed and build the application's menu under the Fluxbox home folder.}
  spec.homepage      = 'https://github.com/fabiomux/fluxbox_apps_menu'
  spec.license       = 'GPL-3.0'

  spec.metadata      = {
    "bug_tracker_uri"   => "https://github.com/fabiomux/fluxbox_apps_menu/issues",
    #"changelog_uri"     => "",
    "documentation_uri" => "https://www.rubydoc.info/gems/fluxbox_apps_menu/#{spec.version}",
    "homepage_uri"      => "https://github.com/fabiomux/fluxbox_apps_menu",
    #"mailing_list_uri"  => "",
    "source_code_uri"   => "https://github.com/fabiomux/fluxbox_apps_menu",
    "wiki_uri"          => "https://github.com/fabiomux/fluxbox_apps_menu/wiki"
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "iniparse"
  spec.add_runtime_dependency "thor"
end
