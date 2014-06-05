QueuED
======

An extremely simple Ruby Queue system
-------------------------------------

### What is this?

QueuED (pronounced "Que-E-D,") is a Queue system, written in Ruby. While it does
not have the features of many other que systems (such as Resque), it is very 
easy to use and should suffice for many purposes. It uses Redis to store its
data.

<hr>


To start off, you'll need a model for your data. It must be a subclass of 
QueuED::QueueAble


    class Foo < QueuED::QueueAble


It must also have an initializer that takes no arguments. This is probably
something that will change in later versions of this library.


    def initialize
    end

Provide a way to set up this class with all the variables you need to do
the task you are putting it in a queue for. Be sure that they can all be
converted to members of a json!

    def set_integer(i)
      @i = i
    end

Then, create a method called "do\_task." 


This should do exactly what it says on the tin -- perform whatever task
you wish to do on the queue. Maybe it renders a graph, or updates user records,
or calculates some number. Be sure that you store the result of this task within
the same object, or elsewhere -- the return value will not be saved.


    def do_task
      @result = @i ** 10
    end


Now. Create an instance of this class, and set it up how you wish.


    example = Foo.new
    example.set_integer(20)


Congrats. You're ready to queue it up!


    example.queue_up


Now, this will store it in a Redis server. By default, it stores it in a server
with default settings, but you can easily use one you set up yourself:


    example.queue_up(redis: my_redis)


QueueED supports multiple queues. These are specified with strings (which
represent the "key" part of a Redis list.) By default, it uses a queue with name
"QueuED," but you can use your own:


    example.queue_up(queue: "integer_queue")


Note: Queues don't care what objects are in them. As long as you can queue the
object, you can put it in any queue you wish!


Now, of course, a queue is completely useless if you can't actually do work. 
Thankfullly, QueuED is not useless! Doing work on your queue is super simple.

Simply create a worker:


    worker = QueuED::QueueWorker.new(redis: myredis, queue: "integer_queue")


The same default values that are used when adding something to the queue are 
used when making a worker. Now, let's put that worker to work!

    worker.work_once

This will take one element from the front of the queue, re-initialize it, and 
perform the "do\_work" method. Then, it re-serializes the object, and puts 
it in the "result" list. The "result" list uses the same key as the queue, but 
with "\_result" appended to the end:


    result_queue = queue + "_result"


To make this a bit easier, you can create a queue result object:


    result = QueuED::QueueResult.new(redis: my_redis, queue: "my_queue")
    result.pop # Returns the first solved queue element


Hopefully, somebody finds this useful.
