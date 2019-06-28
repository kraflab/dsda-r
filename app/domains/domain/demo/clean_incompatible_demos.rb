module Domain
  module Demo
    class CleanIncompatibleDemos
      def initialize(wad_id)
        @wad_id = wad_id
      end

      def self.call(wad_id)
        new(wad_id).call
      end

      def call
        demo_count = incompatible_demos.count
        move_incompatible_demos
        demo_count
      end

      private

      attr_reader :wad_id

      def move_incompatible_demos
        incompatible_demos.each do |demo|
          original_category_id = demo.category_id
          ::Demo.transaction do
            move_to_other(demo)
            add_tag(demo, original_category_id)
            refresh_records(demo, original_category_id)
          end
        end
      end

      def incompatible_demos
        ::Demo.where(wad_id: wad_id)
              .where.not(category_id: other.id)
              .where(
                "engine LIKE '%Z%' OR " \
                "engine LIKE '%ManDoom%' OR " \
                "engine LIKE '%Doomsday%' OR " \
                "engine LIKE '%wHeretic%'"
              )
      end

      def move_to_other(demo)
        demo.update!(
          tic_record: false,
          second_record: false,
          category: other
        )
      end

      def add_tag(demo, original_category_id)
        original_category = Domain::Category.single(id: original_category_id)
        text = "Incompatible #{original_category.name}"
        tag = { text: text, show: true }
        Demo::CreateTags.call(demo: demo, tags: [tag])
      end

      def refresh_records(demo, original_category_id)
        refresh_demo = ::Demo.find_by(
          wad_id: wad_id,
          category_id: original_category_id,
          level: demo.level
        )
        Demo::UpdateRecordFields.call(refresh_demo) if refresh_demo
      end

      def other
        @other ||= Domain::Category.single(name: 'Other')
      end
    end
  end
end
