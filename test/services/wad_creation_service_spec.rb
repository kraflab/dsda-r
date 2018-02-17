require 'test_helper'

describe WadCreationService do
  let(:params) {
    {
      name: 'test_wad',
      username: 'test_wad',
      author: 'teat_author',
      year: '2020',
      compatibility: 0,
      is_commercial: false,
      single_map: false,
      iwad: iwad.name,
      file: file,
      file_id: file_id
    }
  }
  let(:file) { nil }
  let(:file_id) { nil }
  let(:iwad) { iwads(:doom2) }
  let(:service) { WadCreationService.new(params) }

  describe '#create!' do
    let(:create) { service.create! }

    describe 'when the params are valid' do
      it 'creates a wad' do
        assert_difference 'Wad.count', +1 do
          create
        end
      end

      it 'returns a success hash' do
        create.keys.must_equal [:save, :id, :file_id]
      end

      describe 'when a file is associated' do
        describe 'when file data is passed' do
          let(:file) {
            {
              data: '1234',
              name: 'test_wad.zip'
            }
          }

          it 'creates a new wad file' do
            assert_difference 'WadFile.count', +1 do
              create
            end
          end
        end

        describe 'when a file id is passed' do
          let(:file_id) { wad_files(:btsx_zip).id }

          it 'does not create a new file' do
            assert_no_difference 'WadFile.count' do
              create
            end
          end

          it 'associates the wad with the existing file' do
            create[:file_id].must_equal file_id
          end
        end
      end
    end

    describe 'when the params are invalid' do
      let(:params) { { oops: 'nothing' } }

      it 'raises an error' do
        proc { create }.must_raise ActiveRecord::RecordInvalid
      end
    end
  end
end
