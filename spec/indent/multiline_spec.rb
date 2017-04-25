require 'spec_helper'

describe "Indenting multiline tags" do
  specify "nested tags" do
    assert_correct_indenting <<~EOF
      <p
          a="a">
        <q/>
      </p>
    EOF
  end

  specify "empty tags" do
    assert_correct_indenting <<~EOF
      <p>
        <q
            a="a"/>
        <q
            a="a"/>
      </p>
    EOF
  end

  specify "separate line tag ending" do
    assert_correct_indenting <<~EOF
      <p
          a="a"
          >
        <q>
          <r/>
        </q>
      </p>
    EOF
  end

  specify "separate line empty tag ending" do
    assert_correct_indenting <<~EOF
      <p>
        <q
            a="a"
            />
        <q/>
      </p>
    EOF
  end

  specify "close on same line" do
    assert_correct_indenting <<~EOF
      <p>
        <q
            a="a"
            >foo</q>
      </p>
    EOF
  end
end

