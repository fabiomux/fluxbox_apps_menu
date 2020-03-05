# FluxboxAppsMenu

FluxboxAppsMenu builds an application's menu for the Fluxbox window manager starting from
the _desktop_ files installed by the applications themselves.

Categories and sub-categories listed within these files will be used to assign the related
application to the proper _folder_ in order to create a tree representation automatically.

Customizations are allowed enhancing the configuration file.

## Installation

Install it as:

    $ gem install fluxbox_apps_menu

## Usage

Build the menu:

    $ fluxbox_apps_menu build

When the application menu is built it can be included in your main fluxbox menu file 
(usually *~/.fluxbox/menu*) adding the row below wherever you want to display it:

    [include] (~/.fluxbox/menu-apps)

## Configuration

To start with customizations create a copy of the config file (*fluxbox_apps_menu.yaml*)
under the _~/.fluxbox_ folder using the related command:

    $ fluxbox_apps_menu config

Edit it with your favorite editor:

    $ vi ~/fluxbox/fluxbox_apps_menu.yaml

Once changes are done build the menu again!

## Get help

Where to start:

    $ fluxbox_apps_menu help

Get help for a specific task:

    $ fluxbox_apps_menu help build
    $ fluxbox_apps_menu help config

More help:

- The wiki page: https://github.com/fabiomux/fluxbox_apps_menu/wiki

## Contributing

1. Fork it ( https://github.com/fabiomux/fluxbox_apps_menu/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
