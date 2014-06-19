# FluxboxAppsMenu

FluxboxAppsMenu create an applications menu file for Fluxbox Window Manager
including all the applications stored within the folders containing all  the
_.desktop_ files.


## Installation

Add this line to your application's Gemfile:

    gem 'fluxbox_apps_menu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluxbox_apps_menu

## Usage

Build the menu

    $ fluxbox_apps_menu build
    
Create a copy of the config file under the ~/.fluxbox folder

    $ fluxbox_apps_menu menuconfig
    
Get help

    $ fluxbox_apps_menu help
    
Get help for a specific task

    $ fluxbox_apps_menu help build
    $ fluxbox_apps_menu help menuconfig

## Contributing

1. Fork it ( https://github.com/fabiomux/fluxbox_apps_menu/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
