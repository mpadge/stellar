# stellar

Search your github stars in R
```
> ghstar ("what was that repo I starred again?")
    name            desc
1.  my/stuff        Repo for doing good stuff
2.  their/thing     Anohter repo for 
3.  mpadge/stellar  Search your github stars in R
...
```
Type the number to open the repo on github. Other people's stars can also be
searched:
```
> ghstar (user = "m")
... (list of of given user's stars)
> ghstar (text = "great repo about great R stuff", user = "m")
... (list stars by user "m" that best match given text)
```
