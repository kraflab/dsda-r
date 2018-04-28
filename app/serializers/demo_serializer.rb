class DemoSerializer
  def initialize(demo)
    @demo = demo
  end

  def call
    {
      save: true,
      demo: {
        id: @demo.id,
        file_id: @demo.demo_file_id
      }
    }
  end
end
