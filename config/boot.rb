<<<<<<< HEAD
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
=======
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
>>>>>>> f1805c303aecceb8a87fcef656bdf41fce4c796c

require "bundler/setup" # Set up gems listed in the Gemfile.
