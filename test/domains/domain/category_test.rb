require 'test_helper'

describe Domain::Category do
  describe '.list' do
    it 'returns a list of categories' do
      Domain::Category.list.first.must_be_instance_of Category
    end

    describe 'when using a soft category' do
      it 'returns related categories' do
        Domain::Category.list(soft_category: 'UV Speed')
          .map(&:name).must_equal ['UV Speed', 'Pacifist']
      end
    end

    describe 'when asking for only skill 4 speed categories' do
      it 'returns them' do
        Domain::Category.list(only: :skill_4_speed)
          .map(&:name).must_equal ['UV Speed', 'SM Speed', 'Sk4 Speed']
      end
    end

    describe 'when asking for an iwad' do
      it 'returns all the categories for the iwad' do
        Domain::Category.list(iwad: 'heretic').size.must_equal(12)
        Domain::Category.list(iwad: 'hexen').size.must_equal(10)
        Domain::Category.list(iwad: 'doom').size.must_equal(12)
        Domain::Category.list(iwad: 'other').size.must_equal(12)
      end
    end
  end

  describe '.single' do
    let(:category) { categories(:uvspeed) }

    it 'returns a category' do
      Domain::Category.single(name: category.name).must_equal category
    end

    describe 'when using id' do
      it 'returns a category' do
        Domain::Category.single(id: category.id).must_equal category
      end
    end

    describe 'when the category does not exist' do
      let(:single) {
        Domain::Category.single(name: 'not found', assert: assert_presence)
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
