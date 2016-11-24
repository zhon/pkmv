require 'pkmv/thread_pool'


describe ThreadPool do

  it 'will create thread_count number of threads' do
    tp = ThreadPool.new(3)
    tp.process
    tp.instance_variable_get(:@threads).size.must_equal 3
    tp.finish
  end

  it '@queue must contain an item after being pushed' do
    tp = ThreadPool.new(1)
    tp.instance_variable_get(:@queue).size.must_equal 0
    tp.push -> {}
    tp.instance_variable_get(:@queue).size.must_equal 1
    tp.process
    tp.finish
  end

  it '@thread[0] must be dead after finishing' do
    tp = ThreadPool.new(1)
    tp.process
    tp.instance_variable_get(:@threads)[0].alive?.must_equal true
    tp.finish
    tp.instance_variable_get(:@threads)[0].alive?.must_equal false
  end

  it 'does nothing with nothing added' do
    tp = ThreadPool.new(1)
    tp.process
    tp.finish
  end

  it 'executes whatever is pushed' do
    x = 0
    tp = ThreadPool.new(1)
    tp.process
    tp.push -> { x += 1 }
    tp.finish
    x.must_equal 1
  end

  it 'executes 2 items pushed' do
    x,y = 0,''
    tp = ThreadPool.new(2)
    tp.process
    tp.push -> { y << 'hello' }
    tp.push -> { x += 1 }
    tp.finish
    x.must_equal 1
    y.must_equal 'hello'
  end

end
