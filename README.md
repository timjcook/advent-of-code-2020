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