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
    tp.push -> { y << 'hello' }
    tp.push -> { x += 1 }
    tp.process
    tp.finish
    x.must_equal 1
    y.must_equal 'hello'
  end

  it 'will execute in parallel' do
    tp = ThreadPool.new(4)
    t = Time.now
    tp.push -> { sleep 1.0/1000 }
    tp.push -> { sleep 1.0/1000 }
    tp.push -> { sleep 1.0/1000 }
    tp.push -> { sleep 1.0/1000 }
    tp.finish
    tp.process
    (Time.now - t  < 2.0/1000).must_equal TRUE
  end

  ############ Property based TDD

  it 'with 0 threads all items complete' do
    skip
    test_q = Queue.new
    tp = ThreadPool.new(0)
    5.times do
      tp.push -> { test_q << 1 }
    end
    tp.process
    test_q.length.must_equal 5
  end

  it 'with mutiple threads all items run in parallel' do
  end

  it 'with mutiple threads all items complete' do
  end

end
