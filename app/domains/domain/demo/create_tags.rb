module Domain
  module Demo
    module CreateTags
      extend self

      def call(demo:, tags:)
        sub_categories(tags).each do |sc|
          ::Tag.create!(demo: demo, sub_category: sc)
        end
        update_tag_fields(demo)
      end

      private

      def sub_categories(tags)
        return [] unless tags.present?
        tags.map do |tag|
          ::SubCategory.find_by(name: tag[:text]) ||
            ::SubCategory.create!(name: tag[:text], show: tag[:show])
        end
      end

      def update_tag_fields(demo)
        demo.update!(
          has_hidden_tag: demo.sub_categories.hidden.exists?,
          has_shown_tag: demo.sub_categories.shown.exists?
        )
      end
    end
  end
end
