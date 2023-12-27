# frozen_string_literal: true

require_relative "lib/fluxbox_apps_menu/version"

Gem::Specification.new do |spec|
  spec.name = "fluxbox_apps_menu"
  spec.version = FluxboxAppsMenu::VERSION
  spec.authors = ["Fabio Mucciante"]
  spec.email = ["fabio.mucciante@gmail.com"]

  spec.summary = "Build the Fluxbox apps menu."
  spec.description = "Reads the .desktop files installed and build the application's menu under the Fluxbox home folder"
  spec.homepage = "https://freeaptitude.altervista.org/projects/fluxbox-apps-menu.html"
  spec.license = "GPL-3.0"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fabiomux/fluxbox_apps_menu"
  spec.metadata["changelog_uri"] = "https://freeaptitude.altervista.org/projects/fluxbox-apps-menu.html#changelog"
  spec.metadata["wiki_uri"] = "https://github.com/fabiomux/fluxbox_apps_menu/wiki"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"

  spec.add_runtime_dependency "iniparse"
  spec.add_runtime_dependency "thor"
end
