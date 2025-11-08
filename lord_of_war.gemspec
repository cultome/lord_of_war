require_relative 'lib/lord_of_war/version'

Gem::Specification.new do |spec|
  spec.name = 'lord_of_war'
  spec.version = LordOfWar::VERSION
  spec.authors = ['cultome']
  spec.email = ['csoria@cultome.io']

  spec.summary = 'TODO: Write a short summary, because RubyGems requires one.'
  spec.description = 'TODO: Write a longer description or delete this line.'
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = "TODO: Put your gem's public repo URL here."
  spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."
  spec.metadata['rubygems_mfa_required'] = 'true'

  gemspec = File.basename __FILE__
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .rubocop.yml])
    end
  end

  spec.require_paths = ['lib']
end
