## Advent of Code 2020 - https://adventofcode.com/

### Day 1 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/expense-report-parser.rb)
Focus was mainly on defining an object to describe the operations ie) the Parser and then once I saw Challenge 2, creating a solution that would scale to comparing any number of values.
Performance was not a consideration and if the number of values was increased much more it would take ages 😆

### Day 2 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/password-list-analyzer.rb)
Defining some objects paid off! Messed around with tagging the password and passing the valid check to a Detector object. Moving on to Challenge 2 was very simple, little bit of refactoring and defining a new type of Detector class with the same interface. Also a sneaky chance to bust out an XOR operator, don't get many situations where I can do that. Unfortunately tired brain originally added one to the range rather than subtracting to compensate for no zero indexing 🤷‍♀️

### Day 3 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/slope-route-planner.rb)
I think my attempt to break down into objects a bit smoother today, based on some Object Oriented related feedback from yesterday's challenge (which I've updated since, just for fun 🙌). Defining very specific objects and then explicitly passing them to other objects who essentially know nothing about them and their variations, only their interface. Example here is the PositionUpdater, pass any variation of that into a RoutePlanner and let it do the work. Once again, the setup from Challenge 1 meant that Challenge 2 was only some basic refactoring so OO is winning the day so far.
Also, there was something quite satisfying about creating the Snow and Tree classes, not sure why ❄️🎄

Sneaky TIL as well, I had to do `self.x = x + 3` even though I defined an `attr_accessor`, thought I could do `x += 3` or something smooth like that. Can't do it within the class though because ruby needs an explicit receiver of the `x=` method I created, it tries to create a local variable `x` but that's `nil` so it throws a `nil + integer` type error, (thanks https://stackoverflow.com/a/20124579/1725126). Could have just updated `@x` as well.

### Day 4 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/passport-processor.rb)
The goal for this one was to simulate what it might have looked like to tweak the passport scanning script. I liked the idea of defining a new "altered" class that implemented the same interface as the standard passport scanner object but removed the requirements as per the instructions. Implementing this was straightforward, passing an instance of the altered scanner into the batch processor object. Moving on to Challenge 2 should have been an easy step considering the way I'd designed for Challenge 1. I split the validity scanner up into a requirement scanner (which had an altered counterpart) and the valid checker which was the same for both cases.

I thought I'd split up the value of each field into an object with a "type" and potentially a "unit" attribute as well as a "value", the idea being that if you do that work early then the validity scanning becomes trivial. Ran the script and entered my answer only to be wrong, and my suspicion was that I'd messed up something where I wasn't checking `nil` and so I spent time tracking that down, wish I had tests tbh 😩 I may have found a few tweaks to make but really just added extra overhead searching for the issue. Turns out the main issue (there may have been more) was this:

```rb
  def fields_valid?
    byr_valid? && iyr_valid? && eyr_valid? && hgt_valid? && hcl_valid?
      ecl_valid? && pid_valid? && cid_valid?
  end
```

I was missing a `&&` so it was only returning the second line 🤦‍♂ saw that about 2 mins into debugging the next day. I've switched it to use `reduce(:&)` purely because it means less chance of error.

Also, need to chat to my ruby friends to see what the main alternative to an abstract class is. Would have loved a `BaseValidityScanner` class or something but it doesn't seem to be a recommended approach from the brief searching I've done.

### Day 5 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/seat-identifier.rb)
Due to being quite busy the last few days, I completed Challenge 1 but had to wait a few days to get to Challenge 2. The most interesting thing about this Challenge was getting the abstraction right for reusing the algorithm to process the seat rows and seat columns. Defining the different symbols for each case as constructor arguments for my `SeatCodeParser` meant that I could use that object to figure out both row and column.

This was the first Challenge that I wrote any tests for as well. The way the Challenge was written presented some test cases so nicely I couldn't resist. Made doing the range splitting a breeze and I could work away at the algorithm using a bit of trial and error because that stuff always breaks my brain 🧠

### Day 6 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/customs-declaration-reader.rb)
These Challenges was pretty easy if I'm being honest. I think the key here was knowing what array methods are available in ruby and letting them do all the work. `uniq`, `flatten` and `keep_if` came in handy for me although I'm sure there are some other methods that could be subbed in. I liked my method of finding the common answer for each Traveller, pretty simple, count the number of travellers, `x`, flatten the answers into one array and check for each answer if it appears `x` times.

Proved to be another win for writing tests for the more complex aspects of the Challenge, the `Calculator` in this case.

I've also noticed my heavy usage of `reduce`, there is not much you can't do with it. I am officially going to award it "method of the week", well done `reduce` 🥇

### Day 7 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/coloured-bag-planner.rb)
This one required getting the recursion right. I defined two classes, a `Bag` and a `Rule` class as the core data structures. Because a `Rule` was associated with another `Bag` I thought I might be able to generate all the `Bag`s and then store an instance of a `Bag` for each `Rule`, but it took forever when I tried to run it. Ended up just storing the `colour` string associated with the `Bag` and did a look up each time.

Perhaps didn't quite dish out the responsibilities perfectly regarding what is in charge of looking up bags based on a colour but 🤷‍♀️ it didn't seem like a big deal.

Setting up well for Challenge 1 meant that a quick spec and a new method on the `BagChecker` resulted in a solution 🙌

### Day 8 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/boot-code-operator.rb)
Was trying to smash this one out and was reasonably successful. I like the structure of having an operator that would run any set of boot codes and then a fixer that would flip one code out of the set and create a new operator and see if it worked. Nothing fancy but worked a treat!

Nearly brought myself undone by an indexing issue on the while loop running in the operator. It was never actually getting to the end because of a misplaced `- 1`, oops! Luckily indexes counting is on my list of "things to check before I start questioning core methods" 😅

### Day 9 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/port-decoder.rb)
Using ruby made Challenge 1 straightforward. I could generate a set of combinations for the preamble using the `combination` method available on ruby `Array`s (I learnt about that one back in Day 1 or 2).

I think the trick for Challenge 2 was if you tried to use a similar approach and generate a set of combinations and iterate through them all to find the one that summed to the goal number, it would take forever. I decided to just work each number, summing it's neighbour and then the next neighbour, until it either summed to the goal or exceeded it. If it exceeded, then on to the next number in the stream 🏞

### Day 10 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/joltage-adapter-combiner.rb)
Challenge 1 of Day 10 was straightforward, I was able to annotate the adapters in the chain with the "joltage increase" for each step by sorting and iterating through the list.

Challenge 2 however presented a much more difficult problem. My initial, knee-jerk reaction was to write a script that just computed all of the different combinations and then counted them. I probably should have taken heed of the note in the challenge descriptions that there would be more than a trillion options because although I was pretty sure I had a solution that would eventually generate all the combinations, when I started running it, it took was taking forever. I never tried to run it to completion because that wasn't very satisfactory for me.

I changed tact from there figured that it didn't matter what the different combinations were, I was just after the total count. It was convenient that the adapters only ever jumped in one or three joltage increments. I figured that if I divided the sorted set of adapters into groups, where each group contained consecutive or one joltage increment adapters and a three joltage jump started a new group, then I could figure out how many new combinations each group would add to the total number of combinations.

In each group the first and last adapters needed to be used, otherwise you couldn't make it to the next group. How many consecutive adapters was what contributed, a group of 3 only had 2 combinations, 4 would add 4 new combinations and 5 would add 7 new combinations. I wrote a little `CombinationScorer` class that used binary representations of numbers to represent each adapter in a group and would filter out invalid configurations within that group (ie in a group of 5, `10001` would be invalid because that skips too many adapters in the middle to work).

Once each group had a score, I multiplied them all together to find the total number of combinations 🎉 It was running in a fraction of a section as well instead of taking forever like my original solution. It didn't quite get me the right answer first go but that was because I didn't factor in combinations at the very start of the sequence, where the `1` adapter was skipped and went straight to `2`. Easy fix and another completed challenge.

I'm not sure how well this would scale to handle more variations, like a joltage increment of 2 where my rules above would change. I assume through with some tweaking it would be fit for those cases as well though. No idea how others solved it but I'm pretty proud of this 🙌

### Day 11 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/ferry-seat-planner.rb)
I had a pretty good plan for how I was going to do this one from the get-go. The challenge was in the state management. I had a bit of fun defining the `Tile` and `TileState` classes and defining dedicated `==` methods on them to compare two tiles or two states. I seemed to be getting `!=` for free after I defined `==`, I'm not sure if that was true or not, but when I hit a few issues I defined them, just to be safe.

For Challenge 2, when iterating in a field of view from any given point, I created a method that took a block so I could reuse it with a different coordinate transform function, depending on which way someone was looking. I was pretty happy with that 😎

I did run into a few issues with getting an answer that turned out to be wrong but they were all case of off by one errors or one time I used `x` instead of `y` and vice-versa. Just annoying things. This challenge was fun!

### Day 12 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/safe-passage-plotter.rb)
Nothing too crazy jumped out for this one. I found that the solution for Challenge 1 flowed really nicely into Challenge 2. Main little challenge was calculating the new `x` and `y` when the ferry turned according to the waypoint.
I had a bit of fun after solving Challenge 2 in refactoring into a specific `InstructionActioner` that could be passed in to a `Ferry` based on if the ferry executed actions based on movement (Challenge 1) or the waypoint (Challenge 2).

### Day 13 - ✅ - [check it out!](https://github.com/timjcook/advent-of-code-2020/blob/master/shuttle-optimiser.rb)
After hearing from friends that this day took some figuring out I was prepped to get some thinking on. My guess is that Challenge 1 wasn't the issue, it just gives us a helpful function to check a specific timestamp for arriving shuttles.

I started with a naïve approach of checking each timestamp to see if the pattern of sequential shuttles appeared. I made a few modifications to this to optimise and short circuit if a sequence is never going to work but it was pretty clear that the point of this problem required me to think a little differently.
Spending a bit of time thinking about it, I realised that because there is no upper limit we can define, it's infinite, it was going to take a more effective way to improve performance.

I realised from some simpler examples that even the start of the pattern (first two active shuttles) only appeared according to a certain pattern that repeated each interval so I figured that if I could find that interval for `x` shuttles, that would help me to find it for `x + 1` as I would only have to increase the timestamp by the interval I found before.
Turns out that the relationship for that interval is just the product of the individual intervals of each shuttle (stumbled upon this from simpler examples but it makes sense as the product will be a guaranteed number that each interval is a factor of).

A little bit of recursion, applying the previous result to the next set of shuttles and we get our answer! All aboard!! 🚌