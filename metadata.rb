name             "drush"
maintainer       "Ben Clark"
maintainer_email "ben@benclark.com"
license          "Apache 2.0"
description      "Installs drush. Fork of msonnabaum/chef-drush"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.30.5"
depends          "php"
depends          "git"

recipe           "drush",       "Installs Drush and dependencies."
recipe           "drush::pear", "Installs Drush via PEAR."
recipe           "drush::git",  "Installs Drush via Git (drupal.org repository)"
recipe           "drush::make", "Installs Drush Make via Drush. NOT required for Drush 5."

%w{ debian ubuntu centos redhat }.each do |os|
  supports os
end
