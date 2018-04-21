[![Build Status](https://travis-ci.org/ropenscilabs/stellar.svg)](https://travis-ci.org/ropenscilabs/stellar) [![Project Status: Concept.](http://www.repostatus.org/badges/latest/concept.svg)](http://www.repostatus.org/#concept)

# stellar

(Doesn't yet work like this, but will really, really soon ...) Search your
github stars in R
```
library (stellar)
> stars ("what was that repo I starred again?")
    name            desc
1.  my/stuff        Repo for doing good stuff
2.  their/thing     Anohter repo for 
3.  mpadge/stellar  Search your github stars in R
...
```
Type the number to open the repo on github. Other people's stars can also be
searched:
```
> stars (user = "m")
... (list of of given user's stars)
> stars (text = "great repo about great R stuff", user = "m")
... (list stars by user "m" that best match given text)
```
