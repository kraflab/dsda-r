require 'test_helper'

describe Domain::Wad::Update do
  let(:update) do
    Domain::Wad::Update.call(wad, new_attributes)
  end

  describe 'attribute updating' do
    let(:wad) { Wad.new(author: '4shockblast') }
    let(:old_attributes) do
      { author: '4shockblast' }
    end
    let(:new_attributes) do
      { author: 'kraflab' }
    end

    before do
      Domain::Wad::Save.stubs(:call)
      wad.stubs(:attributes).returns(old_attributes).then.returns(new_attributes)
    end

    it 'assigns the attributes' do
      update
      _(wad.author).must_equal('kraflab')
    end

    it 'saves the wad' do
      Domain::Wad::Save.expects(:call).with(wad)
      update
    end
  end

  describe 'file updating' do
    let(:wad) { wads(:btsx) }
    let(:new_attributes) do
      {
        file: {
          data: 'btsx_zip_new',
          name: 'btsx_zip_new.zip'
        }
      }
    end

    it 'updates the file' do
      update
      _(wad.reload.file_path.include?('btsx_zip_new')).must_equal(true)
    end
  end
end
