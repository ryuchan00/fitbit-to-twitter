class Test < Thor
  desc 'hoge [a] [b]', 'parameter test'
  def hoge a, b
    p a
    p b
  end
end