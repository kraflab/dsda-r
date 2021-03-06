require 'test_helper'

describe Domain::Category do
  describe '.list' do
    it 'returns a list of categories' do
      _(Domain::Category.list.first).must_be_instance_of Category
    end

    describe 'when using a soft category' do
      it 'returns related categories' do
        _(
          Domain::Category.list(soft_category: 'UV Speed').map(&:name)
        ).must_equal ['UV Speed', 'Pacifist']
      end
    end

    describe 'when asking for only skill 4 speed categories' do
      it 'returns them' do
        _(
          Domain::Category.list(only: :skill_4_speed).map(&:name)
        ).must_equal ['UV Speed', 'SM Speed', 'Sk4 Speed']
      end
    end

    describe 'when asking for an iwad' do
      it 'returns all the categories for the iwad' do
        _(Domain::Category.list(iwad: 'heretic').size).must_equal(12)
        _(Domain::Category.list(iwad: 'hexen').size).must_equal(10)
        _(Domain::Category.list(iwad: 'doom').size).must_equal(12)
        _(Domain::Category.list(iwad: 'other').size).must_equal(12)
      end
    end
  end

  describe '.single' do
    let(:category) { categories(:uvspeed) }

    it 'returns a category' do
      _(Domain::Category.single(name: category.name)).must_equal category
    end

    describe 'when using id' do
      it 'returns a category' do
        _(Domain::Category.single(id: category.id)).must_equal category
      end
    end

    describe 'when the category does not exist' do
      let(:single) {
        Domain::Category.single(name: 'not found', assert: assert_presence)
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

  describe '.multiple_exits?' do
    describe 'when the category has multiple exits' do
      it 'is true' do
        _(Domain::Category.multiple_exits?(name: 'UV Speed')).must_equal(true)
      end
    end

    describe 'when the category does not have multiple exits' do
      it 'is false' do
        _(Domain::Category.multiple_exits?(name: 'NoMo 100S')).must_equal(false)
      end
    end
  end
end
