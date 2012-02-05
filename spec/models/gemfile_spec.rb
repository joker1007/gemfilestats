require 'spec_helper'

describe Gemfile do
  it { should have_field(:body).of_type(String) }
  it { should be_embedded_in(:repository) }
end
