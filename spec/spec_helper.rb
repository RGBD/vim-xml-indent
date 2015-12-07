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

  def strip_and_unindent(string)
    whitespace = string.scan(/^\s*/).first
    string.split("\n").map do |line|
      line.gsub /^#{whitespace}/, ''
    end.join("\n").strip
  end

  def vim_indent(string)
    sting = strip_and_unindent(string)

    filename = ENV['TMPDIR'].to_s + 'test.xml'

    File.open filename, 'w' do |f|
      f.write string
    end

    vim.edit filename
    vim.normal 'gg=G'
    vim.write

    IO.read(filename).strip
  end

  def assert_correct_indenting(string)
    expect(vim_indent(string)).to eq strip_and_unindent(string)
  end

  def assert_balanced_indenting(string)
    last_line = vim_indent(string).split("\n").last
    last_line_ident = last_line.scan(/^\s*/).first.size

    expect(last_line_ident).to eq 0
  end
end
