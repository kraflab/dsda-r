module Service
  module Tics
    module FromString
      extend self

      def call(time)
        time, cs = time.split('.')
        s, m, h = time.split(':').reverse
        [
          cs.to_i + s.to_i * 100 + m.to_i * 6000 + h.to_i * 360000,
          cs.present?
        ]
      end
    end
  end
end
