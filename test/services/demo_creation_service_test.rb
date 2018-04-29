require 'test_helper'

describe DemoCreationService do
  let(:params) {
    {
      time: '1:11.13',
      tas: 0,
      guys: 1,
      level: 'E1M1',
      recorded_at: '2018-03-15 23:08:46 +0100',
      levelstat: '',
      engine: 'ZDoom v2.7',
      version: 0,
      video_link: 'xyz',
      wad: wad.username,
      category: 'UV Speed',
      players: demo_players.map(&:name),
      tags: [{ text: 'Also reality', style: 1 }],
      file: file,
      file_id: file_id
    }
  }
  let(:file) { nil }
  let(:file_id) { demo_files(:demo_zip).id }
  let(:wad) { wads(:btsx) }
  let(:demo_players) { [players(:kraflab), players(:kingdime)] }
  let(:service) { DemoCreationService.new(params) }

  describe '#create!' do
    let(:create) { service.create! }

    describe 'when the params are valid' do
      it 'creates a demo' do
        assert_difference 'Demo.count', +1 do
          create
        end
      end

      it 'returns the demo' do
        create.must_be_instance_of Demo
      end

      it 'handles tags' do
        create.tags.count.must_equal 1
      end

      describe 'when a file id is passed' do
        it 'does not create a new file' do
          assert_no_difference 'DemoFile.count' do
            create
          end
        end
      end

      describe 'when file data is passed' do
        let(:file) {
          {
            data: '1234',
            name: 'test_demo.zip'
          }
        }

        it 'creates a new demo file' do
          assert_difference 'DemoFile.count', +1 do
            create
          end
        end
      end
    end
  end
end
