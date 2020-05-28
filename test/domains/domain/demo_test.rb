require 'test_helper'

describe Domain::Demo do
  describe '.list' do
    it 'returns a list of demos' do
      _(Domain::Demo.list.first).must_be_instance_of Demo
    end

    describe 'when using a soft category' do
      it 'returns demos for multiple categories' do
        _(
          Domain::Demo.list(soft_category: 'UV Speed')
                      .map(&:category_name).uniq.size
        ).must_equal 2
      end
    end
  end

  describe '.standard_record_list' do
    before do
      Domain::Demo::FindStandardRecordList.stubs(:call)
    end

    it 'finds the standard record' do
      Domain::Demo::FindStandardRecordList.expects(:call)
      Domain::Demo.standard_record_list(
        wad_id: 1, levels: ['Map 01', 'Map 02'], category: 'UV Speed'
      )
    end
  end

  describe '.standard_record' do
    before do
      Domain::Demo::FindStandardRecord.stubs(:call)
    end

    it 'finds the standard record' do
      Domain::Demo::FindStandardRecord.expects(:call)
      Domain::Demo.standard_record(wad_id: 1, level: 'Map 01', category: 'UV Speed')
    end
  end

  describe '.single' do
    let(:demo) { demos(:bt01speed) }

    it 'returns a player' do
      _(Domain::Demo.single(id: demo.id)).must_equal demo
    end

    describe 'when the player does not exist' do
      let(:single) {
        Domain::Demo.single(id: 0, assert: assert_presence)
      }

      describe 'when asserting presence' do
        let(:assert_presence) { true }

        it 'raises error' do
          _(proc { single }).must_raise ActiveRecord::RecordNotFound
        end
      end

      describe 'when not asserting presence' do
        let(:assert_presence) { false }

        it 'returns nil' do
          _(single).must_be_nil
        end
      end
    end
  end

  describe '.create' do
    let(:create) {
      Domain::Demo.create(
        wad: wads(:btsx).name, category: 'UV Speed', time: '1:11', level: 'E1M1',
        tas: false, guys: 1, players: [player]
      )
    }
    let(:player) { players(:elim).name }

    it 'delegates to the create object' do
      Domain::Demo::Create.expects(:call)
      create
    end
  end

  describe '.update' do
    let(:update) {
      Domain::Demo.update(id: demo.id, recorded_at: Time.now)
    }
    let(:demo) { demos(:bt01speed) }

    it 'delegates to the update object' do
      Domain::Demo::Update.expects(:call)
      update
    end
  end

  describe '.demo_count_by_year' do
    before do
      DemoYear.create(year: 2012, count: 1234)
      DemoYear.create(year: 2013, count: 3333)
    end

    it 'returns demo count by year' do
      _(Domain::Demo.demo_count_by_year).must_equal(2012 => 1234, 2013 => 3333)
    end
  end

  describe '.find_matches' do
    let(:details) { { level: 'Map 01' } }

    it 'delegates' do
      Domain::Demo::FindMatches.expects(:call).with(details)
      Domain::Demo.find_matches(details)
    end
  end
end
