# qqid

###### [Boris Steipe](https://orcid.org/0000-0002-1134-6758), Department of Biochemistry and Department of Molecular Genetics, University of Toronto, Canada. &lt;boris.steipe@utoronto.ca&gt;

----

**If any of this information is ambiguous, inaccurate, outdated, or incomplete, please check the [most recent version](https://github.com/hyginn/qqid) of the package on GitHub and [file an issue](https://github.com/hyginn/qqid/issues).**

----

## `bird.carp.7TsBWtwqtKAeCTNk8f`

This is a **QQID**. It is one of 340,282,366,920,938,463,463,374,607,431,768,211,456
unique numbers that can be produced in this format. That's ~3 x 10<sup>38</sup>, or three hundred and forty undecillion. That's approximately the number of atoms in 3 cubic kilometres of water.  There is no process that would reasonably produce `bird.carp.7TsBWtwqtKAeCTNk8f` again. `bird.carp.7TsBWtwqtKAeCTNk8f` was forged in Australia in a machine that measures the inherent randomness of quantum fluctuations of the vacuum, it was interpreted and formatted in Canada, stored in GitHub's data cloud, and visualized by you. Yet, I would immediately recognize that a number in one of my documents might be this one: Hello, _bird carp_! That's what makes QQIDs interesting.

----

# 1 Overview:

QQIDs are a special way to format [128-bit numbers](https://en.wikipedia.org/wiki/128-bit) constructed from two "cues" of short, common, English words, and Base64 encoded characters. Like RFC 4122 UUIDs, with which they can be identically interconverted, QQIDs are suitable as random unique identifiers for use as database keys and in a host of other applications. However they are more compact than UUIDs and it can be established at a  glance whether two keys are different or potentially identical. The `qqid` package contains functions to generate true random and pseudo-random QQIDs, to validate them, and to interconvert them with other 128-bit number representations. 

&nbsp;

## 1.1 Random unique identifiers and UUIDs

Random unique identifiers are great wherever unique identifiers are needed and we have little or no control over who creates them. A typical use case might be to manage observations by a loosely knit group of researchers who contribute data to a common project. The IDs they use locally should be preserved, so they can find them elsewhere in their notes - but we don't know who the contributors are so we can't provide them with dedicated ranges of identifiers, or they might contribute only intermittently, and administering contributor-specific key prefixes would become a significant effort. However, it must be guaranteed that **every key is unique**. Random unique identifiers solve this problem by drawing IDs randomly from a very large space of numbers. This means: in theory, two such IDs could collide by chance. But in practice, since e.g. a random UUID (Universally Unique ID) - a popular type of random unique identifiers - is drawn from 2<sup>122</sup> numbers, the chance of observing the same number again is 1 / 5.3e36 - and that is less than winning the 6 of 49 lottery **five times in a row**.  

UUIDs are defined in an RFC of the governing body of the Internet - [RFC 4122](https://tools.ietf.org/html/rfc4122) - and they are formatted in a characteristic way from strings of 8-4-4-4-12 hyphen-separated hexadecimal characters.

```text
f81d4fae-7dec-11d0-a765-00a0c91e6bf6
```
(A canonical example of a UUID (from [RFC 4122](https://tools.ietf.org/html/rfc4122)).)

Six bits of a UUID are reserved for embedding information about how it was constructed, these six bits are no longer random (some UUID classes have even less randomness). Therefore the number space for RFC-conformant UUIDs is 2^122, not 2^128. Of course, you are not prevented from just using fully-random 128-bit numbers, and all such numbers can be translated into valid QQIDs. But strictly speaking, even though you can encode such a number in hexadecimal characters and add the correct pattern of hyphens, you might not want to call that a UUID anymore. Does it matter? Not until it did and something breaks. Other than that, UUIDs are a perfectly sane approach to representing 128-bit numbers and to share them across a wide variety of media, applications and channels.

There are several possible sources for UUIDs: Simon Urbanek's R-package [**UUID**](https://CRAN.R-project.org/package=uuid) provides pseudo-random UUIDs with the `UUIDgenerate()` function. This is convenient, but can be compromised by a poorly initialized random number generator. UUIDs are generated one at a time. Siegfried Köstlmeier's [**qrandom**](https://CRAN.R-project.org/package=qrandom) package includes the `qUUID()` function that queries the API of the [QRNG](https://qrng.anu.edu.au/API/api-demo.php) server in Canberra, Australia, which provides high-bandwidth true random numbers from measurements of quantum fluctuations of the vacuum, to generate true random UUIDs that conform to [RFC 4122](https://tools.ietf.org/html/rfc4122). UUIDs are returned in batches of up to 1023 numbers and that can incur significant latency. The `qqid` package has tools to retrieve UUIDs from an internal cache, and also to generate any number of UUIDs from the internal RNG.

We do have perfectly sane ways to generate UUIDs as random unique identifiers.

&nbsp;

## 1.2 The need for humane numbers ...

So, what is the problem that QQIDs address?

While UUIDs are an excellent technical solution for the internals of data management systems, they are not exactly easy to distinguish by eye.

```text
    b62f0fae-4445-8a82-9841-ba0715ded850
    fd70c15f-7460-efd2-994f-c0457d20ba42
    69cf2b38-a819-9582-c93f-21e2342d9000
    ff3746d8-9ea6-50f2-1938-e59003b91998
    2a3e1441-c0c0-2352-29bb-3536d9f96fbd
    8951d238-33ba-9572-dbfd-0e58e46bc92e
    ec2db080-5d43-9422-3b4e-04bee45841a6
    0c460ed3-b015-adc2-ab4a-01e093364f1f
    54440d04-dcf2-7932-1913-6e9dd94f3567
    c59db976-e141-3d32-db89-cc071401fe8d
```

Practice shows that when we put them into spreadsheets during data entry, or need to tell them apart during testing and debugging of analysis code, it is surprisingly useful to be able to tell UUIDs apart by actually looking at them. UUIDs are also quite long and this may make them awkward to manage in tables, or reports.

&nbsp;

## 1.3 The QQID concept

QQIDs are a formatted variant of 128-bit numbers. A QQID converts the first 20 bit (five hexadecimal characters) of the number to two integers (0, 1023), and uses the integers to pick two "Q-words" words from a table of English four-letter, monosyllabic words. 

```text

|--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|    5-hexadecimals
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    20-bit
|----------int[1]-----------| |----------int[2]-----------|    2 integers (0, 1023)

```

Taken by themselves, there are only on the order of 10<sup>6</sup> possible combinations of the Q-words. But we are not replacing the 128-bit number, we are just representing its first twenty bits differently, and none of the randomness gets lost. IDs that begin with different words are necessarily different. IDs that begin with the same words could be different - one needs to consider the rest of the ID. However the likelihood of them being different is small enough for any use case in which we ourselves would be looking at QQIDs; reasonably that would limit the number to, say, 1,000 IDs, and a thousand doublets of Q-words have a collision probability of less than 0.4 .

```R
R > stats::pbirthday(n = 1000, classes = 1024^2, coincident = 2)
[1] 0.3790544

```

Even though the words are random, the labels makes QQIDs easily distinguishable.

```text
    rope.scan.-uREWKgphBugcV3thQ
    wrap.sign.FfdGDv0plPwEV9ILpC
    jump.feet.s4qBmVgsk_IeI0LZAA
    your.that.bYnqZQ8hk45ZADuRmY
    dean.wild.RBwMAjUim7NTbZ-W-9
    milk.four.I4M7qVctv9Dljka8ku
    vent.rule.CAXUOUIjtOBL7kWEGm
    bird.carp.7TsBWtwqtKAeCTNk8f
    grip.bore.0E3PJ5MhkTbp3ZTzVn
    skid.lids.l24UE9MtuJzAcUAf6N
```

Quiz: look at these ten numbers. Have you seen any of them before? Exactly! Hello again, _bird carp_.

The remaining 108 bits are simply converted to 18 groups of 6-bit patterns, and these are encoded in a standard [Base64](https://en.wikipedia.org/wiki/Base64) encoding.

The nice thing here is that any UUID can be uniquely represented as a QQID, and uniquely recovered from that representation. QQIDs are fully backwards compatible with UUIDs, and by default the tools of the `qqid` package construct them to be forward compatible as well: unless explicitly instructed to disregard RFC 4122 compliance, a QQID can be converted into a valid UUID. 


<!-- Collision formula estimates 
https://en.wikipedia.org/wiki/Universally_unique_identifier 
(1/2)+sqrt((1/4)+(2 * log(2) * 2^128))  128-bit
(1/2)+sqrt((1/4)+(2 * log(2) * 2^122))  UUID
(1/2)+sqrt((1/4)+(2 * log(2) * 2^64))   64 bit
-->

&nbsp;

## 1.4  Q-words

Q-words are the key to making QQIDs useful. Q-words (from "cue") are all the same length, so they align well in layout and tables, don't need to be padded to represent numbers, and they can be retrieved from a QQID with a simple `substr(x, 1, 4)` and `substr(x, 6, 9)`call. Three letter English words don't quite have the required variety to come up with pleasant, easily recognizable words. Five letter words are way more than we need. But four-letter English words are a good source, even though they are notoriously not all suited for polite conversation. A table of 1,024 four-letter words was hand-picked from a large frequency-sorted dictionary to yield short, unique words that ...

* are monosyllabic (no `lama` or `lazy`),
* are easy to spell and pronounce (no `czar`, no `adze`, no `cwms`),
* are individually not offensive (no `jerk`, no `ditz` etc. etc. etc.),
* are unlikely to be offensive in random combination (either `bait` or `jail` but not both, `ugly`, `cuts`, `pink`, and `vein` are others that got into trouble...),
* are in common use (no `jape`, no `hale`),
* avoid homophones (not `vane` and `vain`), and consonant clusters (no `tact`, `alps`, or `acts`),
* do not contain jargon (`noob`, `geek`, `dude`, `woke`), slang (`whiz`, `geez`, `yuck`), intentional misspellings (`trax`, `fuze`), acronyms (`cran`, `ftfy`, `nsfw`), texting expressions (`myob`, `yolo`, `fomo`), abbreviations (`abbr`, `euro`, `spec`, `zine`), brands (`coke`, `nike`, `ford`), or overly specialized technical (`trie`, `fifo`) or sports terms (`puck`, `fore`, `goon`, `bunt` and `punt`, `sack`, `colt`) ...,
* and finally, there is no `bomb`, `gore` and `kill`, but there is `moon`, `hugs`, and `grin` - that's just the author's prerogative.

The resulting combinations may be evocative but not crass, they should be memorable but somewhat generic, and they should impart a "personality" to an abstract key that helps manage it wherever human interaction is a part of the workflow. 

The full list of Q-words is appended to this document.

&nbsp;

<!--
## 1.X use cases in reproducible research

Obvious: database keys.Crossreferences everywhere! Barcode, watermark.

&nbsp;
-->
## 1.5 Binary to text encoding schemes

In QQIDs, 20 bits of 128-bit numbers are mapped to Q-words, the remaining 108 bits needed to be otherwise encoded. Among [common choices](https://en.wikipedia.org/wiki/Binary-to-text_encoding) we find:

```text
    Encoding:   Alphabet
      128-bit:  01
        octal:  01234567
      base 10:  0123456789
  hexadecimal:  0123456789abcdef
         UUID:  0123456789abcdef-
       Base64:  ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
         QQID:  ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.
      Ascii85:  !"#$%&'()*+,-./0123456789:;<=>?`ABCDEFGHIJKLMNOPQRSTUVWXYZ[~]^@_abcdefghijklmnopqrstu
  ZeroMQ(Z85):  0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#
```

&nbsp;

#### 1.5.1  Efficiency of representation

Since different encodings use different-length alphabets they result in different length encoded strings for the same 128-bit number:

```text
    128-bit:   00001100010001100000111011010011101100000001010110101101110000101010101101001010000000011110000010010011001101100100111100011111
      octal: 0o142140732354012655605255120036022315447437
    base 10:   16314497454888739773185192815022722847
       UUID:   0c460ed3-b015-adc2-ab4a-01e093364f1f
hexadecimal: 0x0c460ed3b015adc2ab4a01e093364f1f
       QQID:   bird.carp.7TsBWtwqtKAeCTNk8f
 Base64 (1):   DEYO07AVrcKrSgHgkzZPHw
    Ascii85:   $q:`UYSF:WX%EENP;Z2Y
ZeroMQ(Z85):   3}p-QUOBpST4AAJLqVhU
```

`(1)`: since 128 is not divisible by 6, the 128 bit string is padded with 4 zeroes before converting to hexadecimal characters.

All the above encodings use ASCII character sets. An ASCII character can be encoded in 7 bits, but in practice characters are stored in 8 bits anyway. So lets assume 8 bits per character. How many bits do we need, to store 128 bits in the various character encoding schemes? Efficiency is the amount of storage needed for an encoding scheme vs. the 128 bits of information it contains ...

```text
       128-bit:   000011000... 128 character  896 bit  14.3 % efficiency
         octal: 0o142140732...  42 character  294 bit  43.5 % efficiency
       base 10:   163144974...  38 character  266 bit  48.1 % efficiency
          UUID:   0c460ed3-...  36 character  252 bit  50.8 % efficiency
   hexadecimal: 0x0c460ed3b...  32 character  224 bit  57.1 % efficiency
       QQID(1):   bird.carp...  28 character  196 bit  65.3 % efficiency
    Base64 (2):   DEYO07AVr...  22 character  154 bit  83.1 % efficiency
       Ascii85:   $q:`UYSF:...  20 character  140 bit  91.4 % efficiency
ZeroMQ(Z85)(3):   3}p-QUOBp...  20 character  140 bit  91.4 % efficiency
   Q-words (4):   bird.carp.vine.vent.call.rump.de...  28.6 % efficiency
```

(1) If we were to restrict ourselves to QQIDS that can be converted to [RFC 4122](https://tools.ietf.org/html/rfc4122) compliant UUIDs, we would get away with one less character. This benefit is minimal vs. the loss of generality.
(2) If character-based encoding were the sole objective, Base64 would be hard to beat. The efficiency gain with Ascii85 is marginal.

&nbsp;

#### 1.5.2  Feature matrix

Considering all aspects, the following feature matrix summarizes pros and cons:

```text
                           |base 10 |  UUID |  QQID |Base64 |ZeroMQ
      ---------------------+--------+-------+-------+-------+---------
           Efficency > 60% |      - |     - |   Yes |   Yes |   Yes 
             IETF standard |    Yes |   Yes |     - |   Yes |     - 
            Human readable |      - |     - |   Yes |     - |     - 
              Safe in JSON |    Yes |   Yes |   Yes |   Yes |     - 
              Safe in URLs |    Yes |   Yes |   Yes |   Yes |     - 
Safe in Excel spreadsheets |    Yes |   Yes |   Yes |     - |     - 
```
Feature matrix of alternate 128-bit encoding schemes.

&nbsp;

## 1.6 verifying randomness of `rngQQID()`

We can trust the underlying randomness of the IDs that `rngQQID()` returns to the same degree that we trust R's RNG in the first place: the  process is simply a mapping from `sample(c(0, 1), 128 * n, replace = TRUE)`. But we need to verify that the transformation is correct and we can check that indeed no collisions have occurred. 

```R
# one million QQIDs
set.seed(qrandom::qrandommaxint())              # initialize RNG with sane seed 
system.time(x1 <- rngQQID(1e6, method = "n"))   
   user  system elapsed 
144.137   2.225 146.672 

# Repeat: another milion for a total of 2e06 QQIDs from two independent runs
set.seed(qrandom::qrandommaxint())  # reinitialize
system.time(x2 <- rngQQID(1e6, method = "n"))   # one more million QQIDs
   user  system elapsed 
157.698   2.476 160.494 
R > system.time(print(any(duplicated(c(x1, x2)))))  # any collisionsn?
[1] FALSE                                           #  :-)
   user  system elapsed 
  0.125   0.003   0.129 
```

Explore the distribution of encoding characters:

```R
substr(x1[1], 11, 28)
 [1] "gIwb9mpJXdmx4-f8Uu"
 
system.time(myTab <- table(unlist(strsplit(substr(c(x1,x2), 11, 28), ""))))
   user  system elapsed 
  9.239   1.119  10.561 

sd(myTab)/mean(myTab)
[1] 0.1681171              # Woah - that's very much more than we would expect:

# Expected:
myInt <- sample(1:64, 36e6, replace = TRUE)
myItab <- table(myInt)
sd(myItab) / mean(myItab)
[1] 0.001075801

barplot(sort(myTab),
        ylim = c(0, 1e6),
        col = c(rep("#DAE9F0", 27),
                rep("#ADC9D9", 27),
                rep("#829CBA",  9),
                rep("#325087",  1)),
        border = NA,
        ylab = "counts",
        cex.axis = 0.8,
        cex.names = 0.67)
```
![](./inst/img/barplotRFC4122conforming.svg?sanitize=true "barplot of UUID conforming BASE64 characters")

The barplot shows that classes of characters have discretely different frequencies. The reason for this is immediately obvious: QQIDs that are created to be convertible to RFC 4122 compliant UUIDs have six non-random bits, and those are not aligned with the encoding character boundaries. Since the distribution of the underlying 128-bit patterns is not uniformly random, neither is the distribution of the encoding characters. However the distribution of numbers that underlie our QQIDs is just as random as 2^122 bits suggests.

But let's repeat the process with fully random 128-bit numbers:

```R
# repeat with fully random QQIDs (RFC4122compliant = FALSE)
set.seed(qrandom::qrandommaxint())
system.time(x3 <- rngQQID(1e6, method = "n", RFC4122compliant = FALSE))
   user  system elapsed 
167.556   2.843 170.983 

set.seed(qrandom::qrandommaxint())
system.time(x4 <- rngQQID(1e6, method = "n", RFC4122compliant = FALSE))
   user  system elapsed 
184.451   4.383 190.462 

system.time(myRTab <- table(unlist(strsplit(substr(c(x3,x4), 11, 28), ""))))
   user  system elapsed 
  8.275   1.240   9.628 

sd(myRTab) / mean(myRTab)
[1] 0.001386461                                             # tiny, as expected 

barplot(sort(myRTab),
        ylim = c(0, 1e6),
        col = "#BCE3DD",
        border = NA,
        ylab = "counts",
        cex.axis = 0.8,
        cex.names = 0.67)
abline(h=min(myRTab), lwd=0.5, col="#CC000055")
abline(h=max(myRTab), lwd=0.5, col="#00DD0055")
```
![](./inst/img/barplot128bitRandom.svg?sanitize=true "barplot of 108-bit random BASE64 characters")

As expected, all encoding characters are equally likely.

Finally, let's look at the distribution of Q-words:

```R
q1Tab <- table(c(substr(x1, 1, 4), substr(x1, 6, 9))) 
q2Tab <- table(c(substr(x2, 1, 4), substr(x2, 6, 9))) 
q3Tab <- table(c(substr(x3, 1, 4), substr(x3, 6, 9))) 
q4Tab <- table(c(substr(x4, 1, 4), substr(x4, 6, 9))) 
sd(q1Tab) / mean(q1Tab)
  [1] 0.02227552
  
plot(1:1024, sort(q1Tab),
     xlab = "Q-word rank",
     ylim = c(1780, 2120),
     yaxt = "n",
     ylab = "counts",
     type = "l",
     lwd = 1.5,
     col = "#715FFF",
     cex.axis = 0.8)
axis(side =  2, at = seq(1800, 2200, by = 100), labels = NULL)
lines(1:1024, sort(q2Tab), type = "l", col = "#8C48E8")
lines(1:1024, sort(q3Tab), type = "l", col = "#D950E4")
lines(1:1024, sort(q4Tab), type = "l", col = "#FF4FB0")

# There are no visibly over- or underrepresented Q-words
             
cor(q1Tab, q2Tab[names(q1Tab)]) # -0.003809322
cor(q1Tab, q3Tab[names(q1Tab)]) #  0.02802701
cor(q1Tab, q4Tab[names(q1Tab)]) # -0.04621827

# The correlations of Q-word frequencies between runs are close to 0.

#         head(sort())                   ...                   tail(sort())
#            1    2    3    4    5    6       1019 1020 1021 1022 1023 1024
#  ------------------------------------  ...  --------------------------------
#         size most verb note guts link       fate paws sled song grew hiss
#  q1Tab: 1820 1830 1830 1833 1837 1837  ...  2065 2072 2074 2077 2079 2082
#  
#         once teal heel perk wife went       seal dark chop lode hint take
#  q2Tab: 1797 1811 1829 1840 1842 1844  ...  2078 2081 2082 2085 2092 2113
#  
#         reap tank keys aunt vent bake       tags cult stem jobs rest twin
#  q3Tab: 1824 1834 1844 1846 1846 1847  ...  2068 2070 2074 2080 2093 2107
#  
#         page skin help kits loud lush       find paid tick pine soar wren
#  q4Tab: 1788 1819 1825 1830 1837 1837  ...  2073 2080 2084 2089 2092 2098

# Most and least frequent Q-words between runs are different
```
![](./inst/img/Q-wordRanks.svg?sanitize=true "Ranks of 4 * 2e+06 Q-words")
Counts for 4 runs of 2e+06 Q-words, ranked by count from 1 to 1024 show no apparent deviation from what is expected from random choices.

In summary: we appear to be rolling a fair die when we construct QQIDs, and we appear to
interpret the underlying large numbers in an unbiased way.

&nbsp;

----

# 2 Functions in `qqid`

&nbsp;

The following functions are included in the `qqid` package:

&nbsp;

## 2.1 `qQQIDfactory()`

`qQQIDfactory` returns a closure (a function with an associated environment) that retrieves, caches, and returns true random QQIDs.

&nbsp;

## 2.2 `rngQQID()`
`rngQQID()` uses R's random number generator to generate a vector of pseudo-random QQIDs.

&nbsp;

## 2.3 `isValidQQID()` and `isValidUUID()`

`isValidQQID()` tests whether the function argument is a vector of valid QQIDs. `isValidUUID()` does the same for UUIDs.

&nbsp;

## 2.4 `uu2qq()` and `qq2uu()`

`uu2qq()` converts a vector of UUIDs to QQIDs. `qq2uu()` performs the opposite operation. 

&nbsp;

## 2.5 `QQIDexample()` and `UUIDexample()`

`QQIDexample()` returns synthetic, valid QQIDs for testing and development, which are easy to distinguish from "real" QQIDs to prevent their accidental use as IDs. `UUIDexample()` does the same for UUIDs.

&nbsp;

## 2.4 `qMap()`

`qMap` maps numbers to Q-words, or Q-words to their index in (0, 1023). `qMap(0:1023)` returns the full list of 1024 Q-words (see appendix).

&nbsp;

## 2.5 `b64Map()`

`b64Map` maps 6-character bit patterns to their corresponding Base64 characters or characters back to bit patterns.

&nbsp;

# 3 The `qqid` GitHub project

The [latest development version of `qqid`](https://github.com/hyginn/qqid) is an RStudio project hosted on GitHub, and available for 
* download and experimentation to your local machine, 
* to be forked for collaboration and possible inclusion of pull-requests, and
* to file issues. 

To learn more about GRPS development (GitHub, R package, RStudio), see the template packages [`rpt`](https://github.com/hyginn/rpt) and [`rptPlus`](https://github.com/hyginn/rptPlus).

&nbsp;


# 5 FAQ

##### Can I edit my QQIDs? Could I create `some.fish.red_some-fish-blue`?
Of course you can, `isValidQQID("some.fish.red_some-fish-blue")` returns `TRUE` since "some" and "fish" are Q-words and the rest are valid characters of Base64. You do realize that this is not a good random unique key - but you can use it anywhere uniqueness is not crucial  - cross-references in your lab notebook for example. The important things is, from **my** perspective, a string that you deliberately craft in any way is still just one of 3e38 numbers, and it won't interfere with my own _random_ QQIDs at all.

#### What if I change `bulk.skip.9zAY8L8jnyLuGYYHEq` to `this.task.9zAY8L8jnyLuGYYHEq`?
It's actually quite harmless to hand-pick specific Q-words for some semantic purpose. You may increase Q-word collisions significantly, but that doesn't matter since a QQID's uniqueness does not come from the Q-words alone, and the remaining 18 Base64 character encode a 108-bit number which is 3.2e+32, i.e. plenty of randomness. However, encoding semantic information in unique keys is almost always a bad idea. The world changes, but our keys should remain.

&nbsp;

# 6 Notes

&nbsp;

## 6.1 Disclaimer and caution

Although `qqid` has been written and tested with care, no suitability for any particular purpose, in particular no suitability for high-value transactions, for applications whose failure could endanger life or property, or for cryptography is claimed. The source code is published in full and it is up to the user to audit and adapt the code for their own purposes and needs.

&nbsp;

# 7 Further reading

* [the Australian National University's Quantum Random Number Server](https://qrng.anu.edu.au/)
* [RFC 4122: A Universally Unique IDentifier (UUID) URN Namespace](https://tools.ietf.org/html/rfc4122)
* [UUIDs on Wikipedia](https://en.wikipedia.org/wiki/Universally_unique_identifier)
* [Binary to text encoding (Wikipedia)](https://en.wikipedia.org/wiki/Binary-to-text_encoding) (with links to Base64 and other encoding schemes)
* The `qrandom` package on [GitHub](https://github.com/skoestlmeier/qrandom) and [CRAN](https://cran.r-project.org/package=qrandom)
* Dirk Edelbuettel's package [`random`](https://cran.r-project.org/package=random) interface to the [`random.org` server](https://www.random.org/) of radio-static based random numbers.

&nbsp;

# 8 Acknowledgements

I enjoyed contributing to Siegfried Köstlmeier's [`qrandom`](https://cran.r-project.org/package=qrandom) package, whose convenient interface to quantum random numbers at [ANU](https://qrng.anu.edu.au/) made `qqid` possible since the prospect of pseudo-random universal IDs is perhaps less sound than it might seem.

&nbsp;

# Appendix: The full list of Q-Words

```R
for(i in seq(0, 1023, by = 16)) {
  cat(sprintf("%04d:  %s\n", i, paste(qMap((i):(i+15)), collapse = " ")))
}
```

&nbsp;

```text
0000:  aims ants arch arms arts aunt back bail bake bald ball balm band bane bank bans
0016:  barb bare bark barn bars base bath bats bays bead beak beam bean bear beat beds
0032:  beef been beer bees beet bell belt bend bent best bets bids bike bile bill bind
0048:  bins bird bite bits blot blue blur boar boat boil bold bolt bond bone book boot
0064:  bore born both bout bowl bows boys brag bred brew brow buds bugs bulb bulk bull
0080:  bump burn burr cage cake calf call calm came camp cane cans cape caps card care
0096:  carp cars cart case cash cast cats cave cell chat chef chew chin chip chop cite
0112:  clad clan claw clay clip clog club clue coal coat code coil coin cold comb cone
0128:  cook cool coop cope cord core cork corn cost coup cove cows crab crew crib crop
0144:  crow cube cubs cues cuff cult cups curb cure curl cute dame damp dams dare dark
0160:  dart dash date dawn days dead deaf deal dean debt deck deed deem deep deer dent
0176:  desk died dies dine dirt dish disk dive dock docs does dogs doll dome done doom
0192:  door dose dots dove down drag draw drip drop drug drum duck dues duke dull dump
0208:  dune dusk dust each earn ears ease east eats edge eels eggs elks else ends face
0224:  fact fade fail fair fake fall fame fang fans fare farm fast fate fawn fear feat
0240:  feel fees feet fell felt fern feud figs file fill film find fine fins firm fish
0256:  fist fits five flag flat flaw flax flea fled flew flex flip flop flow flux foal
0272:  foam foil fold folk fond font food fool foot fork form fort foul four fowl free
0288:  frog from fuel full fume fund fuse fuss gaff gage gain gait gale gall game gang
0304:  gaps gash gate gave gaze gear gems gene germ gift gill girl give glad glow glue
0320:  glum goal goat goes gold golf gone gong good gown grab gram gray grew grid grim
0336:  grin grip grog grow grub gulf gull gust guts guys hack hail hair half hall halt
0352:  hand hang hard hare harm harp hats haul have hawk haze head heal heap hear heat
0368:  heed heel heir held helm help hemp hens herb herd here hide high hike hill hint
0384:  hiss hits hive hoax hold home hone hood hoof hook hoop hope horn hose host howl
0400:  huge hugs hull hums hunt hurt hush husk huts inns isle jade jail jams jars jaws
0416:  jest jets jobs join joke jolt joys jump june junk just keel keen keep kegs kept
0432:  keys kick kids kiln kind king kiss kite kits knee knew knit knot know labs lace
0448:  lack laid lake lamb lame lamp land lane laps lark last late laud lawn laws lead
0464:  leaf leak lean leap leek left legs lend lens lent less lids lied lies life lift
0480:  like limb lime limp line link lint lips lisp list live load loaf loan lock lode
0496:  loft logs lone long look loom loop lord lore lose loss lost lots loud love luck
0512:  lull lump lung lure lurk lush lute lynx made mail main make male mall malt mane
0528:  maps mare mark mash mask mast mate math maze mead meal mean meet melt mens mere
0544:  mesh mess mice mild mile milk mill mime mind mine mink mint miss mist mite moat
0560:  mock mode mold mole monk mood moon more moss most moth move much mugs mule muse
0576:  must mute myth nail name nape near neat neck need nest nets news newt nice nick
0592:  nine node none noon norm nose note noun oaks oath odds oils once ones owls owns
0608:  pace pack page paid pail pair pale palm pane pant park part past path pave pawn
0624:  paws pays peak pear peas peat peck peel peer pens perk pest pets pick pies pike
0640:  pile pill pine pins pint pipe pits plan play plea plot plow ploy plum plus pods
0656:  pole poll pond pool poor pope pork port pose post pots pour prep prey prod prop
0672:  prow puff pull pulp pump pure push quit quiz raft rage rags raid rail rain rake
0688:  ramp rang rank rant rare rash rate rats rave rays read real reap rear reed reef
0704:  reel rent rest ribs rice rich ride rift ring rink ripe rise risk road roar robe
0720:  rock rode rods roll roof rook room root rope rose rugs rule rump rung runs runt
0736:  rush rust safe sage said sail salt same sand sane sang sash save saws says scam
0752:  scan scar seal seam seas seat sect seed seek seem seen sees self sell sent sets
0768:  shed shim shin ship shoe shop shot show shut side sift sigh sign silk sill sing
0784:  sink sins site sits size skew skid skin skip slab slap slat sled slid slim slip
0800:  slot slow slug smug snag snap snip snow soak soap soar sock soft soil sold sole
0816:  some song sons soon soot sore sort soul soup spam span spar spin spot spun spur
0832:  stab stag star stay stem step stew stir stop stow stub such suit sump sums sung
0848:  sunk suns sure surf swam swan swap swat sway swim tabs tack tags tail take talk
0864:  tall tang tank tape taps task teak teal team tear teas teem tell temp tend tent
0880:  term tern test than that thaw thee them then they thin this thus tick tide tier
0896:  ties tile till tilt time tine tint tips toad toes toil told toll tomb tone tong
0912:  took tool tops torn tort toss tour town toys tram trap tray tree trim trip trod
0928:  true tube tubs tuck tune turf turn twig twin type urge vain vase vast veer veil
0944:  vent verb vest view vine vise void vole volt vote vows wade wage wail wait wake
0960:  walk wall wand want ward ware warm warn warp wars wash wasp watt wave weak wear
0976:  webs week weep weld well went were west what when whim whip whom wick wide wife
0992:  wigs wild will wind wine wing wink wins wipe wise wish with wolf wood wool word
1008:  wore work worm worn wove wrap wren yard yarn yawn year yell your zest zinc zone
```

<!-- END -->
