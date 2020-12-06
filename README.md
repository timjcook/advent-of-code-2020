## Advent of Code 2020

### Day 1 - ✅
Focus was mainly on defining an object to describe the operations ie) the Parser and then once I saw Challenge 2, creating a solution that would scale to comparing any number of values.
Performance was not a consideration and if the number of values was increased much more it would take ages 😆

### Day 2 - ✅
Defining some objects paid off! Messed around with tagging the password and passing the valid check to a Detector object. Moving on to Challenge 2 was very simple, little bit of refactoring and defining a new type of Detector class with the same interface. Also a sneaky chance to bust out an XOR operator, don't get many situations where I can do that. Unfortunately tired brain originally added one to the range rather than subtracting to compensate for no zero indexing 🤷‍♀️

### Day 3 - ✅
I think my attempt to break down into objects a bit smoother today, based on some Object Oriented related feedback from yesterday's challenge (which I've updated since, just for fun 🙌). Defining very specific objects and then explicitly passing them to other objects who essentially know nothing about them and their variations, only their interface. Example here is the PositionUpdater, pass any variation of that into a RoutePlanner and let it do the work. Once again, the setup from Challenge 1 meant that Challenge 2 was only some basic refactoring so OO is winning the day so far.
Also, there was something quite satisfying about creating the Snow and Tree classes, not sure why ❄️🎄

Sneaky TIL as well, I had to do `self.x = x + 3` even though I defined an `attr_accessor`, thought I could do `x += 3` or something smooth like that. Can't do it within the class though because ruby needs an explicit receiver of the `x=` method I created, it tries to create a local variable `x` but that's `nil` so it throws a `nil + integer` type error, (thanks https://stackoverflow.com/a/20124579/1725126). Could have just updated `@x` as well.

### Day 4 - ✅
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