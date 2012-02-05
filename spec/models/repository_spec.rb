require 'spec_helper'

describe Repository do
  it { should have_field(:name).of_type(String).with_default_value_of(false) }
  it { should have_field(:url).of_type(String).with_default_value_of(false) }
  it { should embed_one(:gemfile) }
end
