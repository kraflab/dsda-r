require 'test_helper'

describe Domain::Wad do
  describe '.create' do
    let(:create) {
      Domain::Wad.create(
        iwad: 'iwad', name: 'name', short_name: 'name', author: 'author'
      )
    }

    before do
      Domain::Wad::Create.stubs(:call)
      Domain::Iwad.stubs(:single).with(either_name: 'iwad')
    end

    it 'delegates wad creation' do
      Domain::Wad::Create.expects(:call)
      create
    end

    it 'retrieves the iwad' do
      Domain::Iwad.expects(:single).with(either_name: 'iwad')
      create
    end
  end

  describe '.list' do
    it 'returns a list of wads' do
      Domain::Wad.list.first.must_be_instance_of Wad
    end
  end

  describe '.single' do
    let(:wad) { wads(:btsx) }

    it 'returns a wad' do
      Domain::Wad.single(short_name: wad.username).must_equal wad
    end

    describe 'when using either_name' do
      it 'returns a wad' do
        Domain::Wad.single(either_name: wad.username).must_equal wad
      end
    end

    describe 'when the wad does not exist' do
      let(:single) {
        Domain::Wad.single(short_name: 'not found', assert: assert_presence)
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
end
