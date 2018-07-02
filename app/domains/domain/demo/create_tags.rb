module Domain
  module Demo
    module CreateTags
      extend self

      def call(demo:, sub_categories:)
        sub_categories.each do |sc|
          ::Tag.create!(demo: demo, sub_category: sc)
        end
        update_tag_fields(demo)
      end

      private

      def update_tag_fields(demo)
        demo.update!(
          has_hidden_tag: demo.sub_categories.hidden.exists?,
          has_shown_tag: demo.sub_categories.shown.exists?
        )
      end
    end
  end
end
