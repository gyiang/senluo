
def t1
  require 'thread'

  q=Queue.new
  #q = SizedQueue.new(size)

  p=Thread.new do
    10.times do |i|
      q.push(i)
      sleep(1)
    end
    q.push(nil)
  end

  c=Thread.new {
    loop{
      i=q.pop
      break if i==nil
      puts i
    }
  }
  c.join
end



require 'revactor'

def pingpong(name)
  loop do
    Actor.receive do |filter|
      p filter
      filter.when(Case[Actor,Integer]) do |partner,count|
        p count
        if count==0
          puts "#{name}:done"
          exit
        else
          if count % 500 < 2
            puts "#{name}:pingping#{count}"
          end
          partner << [Actor.current,count-1]
        end
      end
    end
  end
end

ping=Actor.spawn {pingpong("ping")}
pong=Actor.spawn {pingpong("pong")}
pong << [ping,1000.to_i]
Actor.reschedule