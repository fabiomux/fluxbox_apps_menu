# FluxboxAppsMenu

FluxboxAppsMenu create an applications menu file for Fluxbox Window Manager
including the applications stored within the folders containing the
_.desktop_ files and discarding automatically those marked as hidden.

They will be organized in several categories and sub-categories specified
within the config file *fluxbox_apps_menu.yaml*


## Installation

Add this line to your application's Gemfile:

    gem 'fluxbox_apps_menu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluxbox_apps_menu

## Usage

Build the menu:

    $ fluxbox_apps_menu build

When the application menu is built it can be included in your main fluxbox menu file 
(usually *~/.fluxbox/menu*) adding the row below where you want display it:

    [include] (~/.fluxbox/menu-apps)


To start with customizations create a copy of the config file (*fluxbox_apps_menu.yaml*) 
under the _~/.fluxbox_ folder:

    $ fluxbox_apps_menu config

Once completed build again!

## Get help

Where to start

    $ fluxbox_apps_menu help
    
Get help for a specific task

    $ fluxbox_apps_menu help build
    $ fluxbox_apps_menu help config
    
More help

- The wiki page: https://github.com/fabiomux/fluxbox_apps_menu/wiki

## Contributing

1. Fork it ( https://github.com/fabiomux/fluxbox_apps_menu/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
