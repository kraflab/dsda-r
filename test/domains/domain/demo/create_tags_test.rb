require 'test_helper'

describe Domain::Demo::CreateTags do
  let(:params) {
    {
      demo: demo,
      sub_categories: [sub_category]
    }
  }
  let(:demo) { demos(:bt01speed) }
  let(:sub_category) { sub_categories(:reality) }
  let(:create_tags) { Domain::Demo::CreateTags.call(params) }

  it 'creates a tag' do
    Tag.expects(:create!).with(demo: demo, sub_category: sub_category)
    create_tags
  end

  it 'updates demo tag fields' do
    create_tags
    demo.has_shown_tag.must_equal true
    demo.has_hidden_tag.must_equal false
  end
end
