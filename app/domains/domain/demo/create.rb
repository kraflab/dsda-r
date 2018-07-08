module Domain
  module Demo
    module Create
      extend self

      def call(attributes)
        attributes[:demo_file] = demo_file(attributes)
        tags = attributes.delete(:tags)
        demo = ::Demo.new(attributes)
        ::Demo.transaction do
          Demo::Save.call(demo)
          Demo::CreateTags.call(demo: demo, sub_categories: sub_categories(tags))
        demo
      end

      private

      def demo_file(attributes)
        file = attributes.delete(:file)
        file_id = attributes.delete(:file_id)
        return ::DemoFile.find(file_id) if file_id
        data = Service::FileData::Read.call(file_hash: file)
        ::DemoFile.new(wad: attributes[:wad], data: data)
      end

      def sub_categories(tags)
        return [] unless tags.present?
        tags.map do |tag|
          ::SubCategory.find_by(name: tag[:text]) ||
            ::SubCategory.create!(name: tag[:text], show: tag[:show])
        end
      end
    end
  end
end
