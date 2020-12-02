## Advent of Code 2020

### Day 1 - ✅
Focus was mainly on defining an object to describe the operations ie) the Parser and then once I saw Challenge 2, creating a solution that would scale to comparing any number of values.
Performance was not a consideration and if the number of values was increased much more it would take ages 😆

### Day 2 - ✅
Defining some objects paid off! Messed around with tagging the password and passing the valid check to a Detector object. Moving on to Challenge 2 was very simple, little bit of refactoring and defining a new type of Detector class with the same interface. Also a sneaky chance to bust out an XOR operator, don't get many situations where I can do that. Unfortunately tired brain originally added one to the range rather than subtracting to compensate for no zero indexing 🤷‍♀️