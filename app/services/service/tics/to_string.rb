module Service
  module Tics
    module ToString
      extend self

      def call(tics, with_cs: true)
        h, m, s, cs = split_tics_time(tics)
        hours_and_minutes(h, m) + seconds(s) + (with_cs ? centiseconds(cs) : '')
      end

      private

      def split_tics_time(cs)
        return [0, 0, 0, 0] if cs.nil?

        s = cs / 100; cs %= 100
        m =  s / 60;   s %= 60
        h =  m / 60;   m %= 60
        [h, m, s, cs]
      end

      def hours_and_minutes(h, m)
        h.positive? ? (h.to_s + ':' + m.to_s.rjust(2, '0')) : m.to_s
      end

      def seconds(s)
        ":#{s.to_s.rjust(2, '0')}"
      end

      def centiseconds(cs)
        '.' + cs.to_s.rjust(2, '0')
      end
    end
  end
end
