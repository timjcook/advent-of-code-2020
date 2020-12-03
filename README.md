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