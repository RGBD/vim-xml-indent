require 'vimrunner'
require 'vimrunner/rspec'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  config.start_vim do
    vim = Vimrunner.start
    vim.prepend_runtimepath(File.expand_path('../..', __FILE__))
    vim.set 'expandtab'
    vim.set 'shiftwidth', 2
    vim
  end

  def unindent(string)
    string.split("\n").map { |x| x.gsub(/^\s*/, '') + "\n" }.join('')
  end

  def vim_indent(string)
    filename = 'test.xml'

    IO.write filename, string

    vim.edit filename
    vim.normal 'gg=G'
    vim.write

    IO.read(filename)
  end

  def assert_correct_indenting(string)
    expect(vim_indent(unindent(string))).to eq string
  end
end
