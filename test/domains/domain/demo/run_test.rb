require 'test_helper'

describe Domain::Demo::Run do
  let(:demo) do
    Demo.new(
      category: categories(:uvspeed),
      wad: wads(:btsx),
      level: 'Map 01'
    )
  end
  let(:demo_run) { Domain::Demo::Run.new(demo) }

  it 'assigns attributes' do
    _(demo_run.wad_id).must_equal(demo.wad_id)
    _(demo_run.category_id).must_equal(demo.category_id)
    _(demo_run.category_name).must_equal(demo.category_name)
    _(demo_run.level).must_equal(demo.level)
  end

  describe '.eql?' do
    it 'returns equality' do
      _(Domain::Demo::Run.eql?(demo_run, demo)).must_equal(true)
      demo.wad_id += 1
      _(Domain::Demo::Run.eql?(demo_run, demo)).must_equal(false)
      demo.wad_id = demo_run.wad_id
      demo.category_id += 1
      _(Domain::Demo::Run.eql?(demo_run, demo)).must_equal(false)
      demo.category_id = demo_run.category_id
      demo.level = 'Map 02'
      _(Domain::Demo::Run.eql?(demo_run, demo)).must_equal(false)
    end
  end
end
