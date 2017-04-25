require 'spec_helper'

describe "Indenting" do
  specify "nested tags" do
    assert_correct_indenting <<~EOF
      <p>
        <q>
          <r>
            foo
          </r>
        </q>
        <q>
          bar
        </q>
      </p>
    EOF
  end

  specify "one line tags" do
    assert_correct_indenting <<~EOF
      <p>
        <q>foo</q>
        <q>foo</q>
      </p>
    EOF
  end

  specify "empty tags" do
    assert_correct_indenting <<~EOF
      <p>
        <q/>
        <q>
          <r/>
        </q>
        <q/>
      </p>
    EOF
  end

  specify "nested tags with attributes" do
    assert_correct_indenting <<~EOF
      <p a="a">
        <q a="a">
        </q>
        <q a="a"/>
      </p>
    EOF
  end

  specify "declaration" do
    # actually, second line keeps it's indent
    assert_correct_indenting <<~EOF
      <?xml version="1.0" encoding="UTF-8" ?>
      <p>
        <q>
        </q>
      </p>
    EOF
  end

  specify "multiple tags in single line" do
    assert_correct_indenting <<~EOF
      <p><q>
          <r/>
      </q></p>
    EOF
  end
end
