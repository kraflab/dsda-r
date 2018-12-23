require 'test_helper'

describe Domain::Demo do
  describe '.list' do
    it 'returns a list of demos' do
      Domain::Demo.list.first.must_be_instance_of Demo
    end

    describe 'when using a soft category' do
      it 'returns demos for multiple categories' do
        Domain::Demo.list(soft_category: 'UV Speed')
          .map(&:category_name).uniq.size.must_equal 2
      end
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
      Domain::Demo.single(id: demo.id).must_equal demo
    end

    describe 'when the player does not exist' do
      let(:single) {
        Domain::Demo.single(id: 0, assert: assert_presence)
      }

      describe 'when asserting presence' do
        let(:assert_presence) { true }

        it 'raises error' do
          proc { single }.must_raise ActiveRecord::RecordNotFound
        end
      end

      describe 'when not asserting presence' do
        let(:assert_presence) { false }

        it 'returns nil' do
          single.must_be_nil
        end
      end
    end
  end

  describe '.create' do
    let(:create) {
      Domain::Demo.create(
        wad: wads(:btsx).name, category: 'UV Speed', time: '1:11', level: 'E1M1',
        tas: 0, guys: 1, players: [player]
      )
    }
    let(:player) { players(:elim).name }

    it 'delegates to the create object' do
      Domain::Demo::Create.expects(:call)
      create
    end

    describe 'when the player does not exist' do
      let(:player) { 'not found' }

      it 'raises error' do
        proc { create }.must_raise ActiveRecord::RecordNotFound
      end
    end
  end
end
