require 'spec_helper'

describe UsedGem do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:url).of_type(String) }
  it { should have_field(:author).of_type(String) }
end
