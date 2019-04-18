# qqid

###### [Boris Steipe](https://orcid.org/0000-0002-1134-6758), Department of Biochemistry and Department of Molecular Genetics, University of Toronto, Canada. &lt;boris.steipe@utoronto.ca&gt;

----

**If any of this information is ambiguous, inaccurate, outdated, or incomplete, please check the [most recent version](https://github.com/hyginn/qqid) of the package on GitHub and [file an issue](https://github.com/hyginn/qqid/issues).**

----

```text
bird.carp.7TsBWtwqtKAeCTNk8f
```
This is a **QQID**. It is one of 5,316,911,983,139,663,491,615,228,241,121,378,304
unique numbers that can be produced in this format. That's ~5 x 10<sup>36</sup> or five undecillion. There is no process that would reasonably produce the exact same number you see here again. My number was forged in Australia in a machine that measures the inherent randomness of quantum fluctuations of the vacuum, it was interpreted and formatted in Canada, stored in GitHub's data cloud, and visualized by you. Yet, I would immediately recognize that a number in one of my documents might be this one: Hello, _bird carp_! That's what makes QQIDs interesting.

----

# 1 Overview:

QQIDs are a special way to format [128-bit numbers](https://en.wikipedia.org/wiki/128-bit). Such numbers are so large that they can be used as random unique identifiers. Let's discuss this concept, together with so caled UUIDs - the standard way to represent such numbers, before we discuss QQIDs.

## 1.1 Random unique identifiers and UUIDs

This package is about "QQIDs", not "UUIDs" in particular, but the former are based on the latter so we need to look at UUIDs first:

UUIDs (**U**niversally **U**nique **IDs**) are great wherever unique identifiers are needed and we have litttle or no control over who creates them. A typical use case might be to manage observations by a loosely knit group of researchers who contribute data to a common project. The IDs they use locally should be preserved, so they can find them elsewhere in their notes - but we don't know who the contributers are so we can't provide them with dedicated ranges of identifiers, or they might contribute only intermittently and administering contributor-specific key prefixes would become a significant effort. However, it must be guaranteed that every key is unique. UUIDs solve this problem by drawing IDs randomly from a very large space of numbers. This means: in theory, two UUIDs could collide by chance. But in practice, a random UUID is drawn from 2<sup>122</sup> numbers, i.e. the chance of observing the same number twice is 1 / 5.3e36 - and that is less than winning the 6 of 49 lottery **five times in a row**.  UUIDs are formatted in a characteristic way from strings of 8-4-4-4-12 hyphen separated hexadecimal characters.

```text
f81d4fae-7dec-11d0-a765-00a0c91e6bf6
```
(A canonical example of a UUID (from [RFC 4122](https://tools.ietf.org/html/rfc4122)).)

There are sevral possible sources for UUIDs: Simon Urbanek's R-package [**UUID**](https://CRAN.R-project.org/package=uuid) provides pseudo-random UUIDs with the `UUIDgenerate()` function. This is convenient, but can be compromised by a poorly initialized random number generator. UUIDs are generated one at a time. Siegfried Köstlmeier's [**qrandom**](https://CRAN.R-project.org/package=qrandom) package includes the `qUUID()` function that uses the [QRNG](https://qrng.anu.edu.au/API/api-demo.php) server in Canberra, Australia, which provides high-bandwidth true random numbers from measurements of quantum fluctuations of the vacuum, to generate true random UUIDs that conform to [RFC 4122](https://tools.ietf.org/html/rfc4122) - the authoritative UUID specification. UUIDs are returned in batches of up to 1023 numbers and that can incur significant latency. The `qqid` package has tools to retrieve UUIDs from an internal cache, and to generate any number of UUIDs from the internal RNG.

&nbsp;

## 1.2 The need for humane numbers ...

So, what is the problem that QQIDs address?

While UUIDs are an excellent technical solution for the internals of data management systems, they are not exactly easy to distinguish by eye.

```text
  [1] "b62f0fae-4445-8a82-9841-ba0715ded850"
  [2] "fd70c15f-7460-efd2-994f-c0457d20ba42"
  [3] "69cf2b38-a819-9582-c93f-21e2342d9000"
  [4] "ff3746d8-9ea6-50f2-1938-e59003b91998"
  [5] "2a3e1441-c0c0-2352-29bb-3536d9f96fbd"
  [6] "8951d238-33ba-9572-dbfd-0e58e46bc92e"
  [7] "ec2db080-5d43-9422-3b4e-04bee45841a6"
  [8] "0c460ed3-b015-adc2-ab4a-01e093364f1f"
  [9] "54440d04-dcf2-7932-1913-6e9dd94f3567"
 [10] "c59db976-e141-3d32-db89-cc071401fe8d"
```

Practice shows that when we put them into spreadsheets during data entry, or need to tell them apart during testing and debugging of analysis code, it is surprisingly useful to be able to tell UUIDs apart by actually looking at them. UUIDs are also quite long and this may make them awkward to manage in tables, or reports.

&nbsp;

## 1.3 The QQID concept ...

QQIDs are a formatted variant of UUIDs. A UUID can be uniquely reformatted to be represented as a QQID, and uniquely recovered from it. The QQID converts the first five hexadecimal numbers of the UUID to two words from a table of English four-letter, monosyllabic words. Taken by themselves, there are only on the order of 10<sup>6</sup> possible combinations of these words. But we are not replacing the UUID, we are just representing its first five letters differently, and none of the randomness gets lost. IDs that begin with different words are necessarily different. IDs that begin with the same words could be different - one needs to consider the rest of the ID. However the likelihood of them being different is small enough for an use case in which we would reasonably not be looking at more than, say, 1,000 IDs, i.e. giving a collision probability of less than 0.4 .

```text
x: a 5 digit hex number
return: a 2 integer vector from 2 * 10 bits - in the range [0, 1023]

|--0x[1]--| |--0x[2]--| |--0x[3]--| |--0x[4]--| |--0x[5]--|
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
|----------int[1]-----------| |----------int[2]-----------|

```

Using word labels - even though the words are random makes QQIDs distinguishable.

```text
  [1] rope.scan.-uREWKgphBugcV3thQ
  [2] wrap.sign.FfdGDv0plPwEV9ILpC
  [3] jump.feet.s4qBmVgsk_IeI0LZAA
  [4] your.that.bYnqZQ8hk45ZADuRmY
  [5] dean.wild.RBwMAjUim7NTbZ-W-9
  [6] milk.four.I4M7qVctv9Dljka8ku
  [7] vent.rule.CAXUOUIjtOBL7kWEGm
  [8] bird.carp.7TsBWtwqtKAeCTNk8f
  [9] grip.bore.0E3PJ5MhkTbp3ZTzVn
 [10] skid.lids.l24UE9MtuJzAcUAf6N
```

Quiz: look at these ten numbers. Have you seen any of them before?

<!-- Collision formula estimates 
https://en.wikipedia.org/wiki/Universally_unique_identifier 
(1/2)+sqrt((1/4)+(2 * log(2) * 2^128))  128-bit
(1/2)+sqrt((1/4)+(2 * log(2) * 2^122))  UUID
(1/2)+sqrt((1/4)+(2 * log(2) * 2^64))   64 bit
-->


## 1.4  Q-words

...

&nbsp;

## 1.X QQIDs in reproducible research

Obvious: database keys.Crossreferences everywhere! Barcode, watermark.

&nbsp;

## 1.X Alternative encoding schemes

```text
    Encoding:   Alphabet
      128-bit:  01
        octal:  01234567
      base 10:  0123456789
         UUID:  0123456789abcdef-
  hexadecimal:  0123456789abcdef-
         QQID:  ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.
  Base 64 (1):  ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
      Ascii85:  !"#$%&'()*+,-./0123456789:;<=>?`ABCDEFGHIJKLMNOPQRSTUVWXYZ[~]^@_abcdefghijklmnopqrstu
  ZeroMQ(Z85):  0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#
  Q-words (2):  abcdefghijklmnopqrstuvwxyz.
```

&nbsp;

## 1.X  Efficiency of representation

```text
    128-bit:   00001100010001100000111011010011101100000001010110101101110000101010101101001010000000011110000010010011001101100100111100011111
      octal: 0o142140732354012655605255120036022315447437
    base 10:   16314497454888739773185192815022722847
       UUID:   0c460ed3-b015-adc2-ab4a-01e093364f1f
hexadecimal: 0x0c460ed3b015adc2ab4a01e093364f1f
       QQID:   bird.carp.7TsBWtwqtKAeCTNk8f
Base 64 (1):   DEYO07AVrcKrSgHgkzZPHw
    Ascii85:   $q:`UYSF:WX%EENP;Z2Y
ZeroMQ(Z85):   3}p-QUOBpST4AAJLqVhU
Q-words (2):   bird.carp.vine.vent.call.rump.deck.stub.bail.mail.duke.nick.coin
```

`(1)`: since 128 is not divisible by 6, the 128 bit string is padded with 4 zeroes before converting to hexadecimal characters.
`(2)`: since 128 is not divisible by 10, the 128 bit string is padded with 2 zeroes before converting to Q-words.

All the above encodings use ASCII character sets. An ASCII character can be encoded in 7 bits, but in practice characters are stored in 8 bits anyway. So lets assume 8 bits per character. How many bits do we need to store 128 bits in the various character encoding schemes? Efficiency is the amount of storage needed for an encoding scheme vs. the 128 bits of information it contains ...

```text
       128-bit:   000011000... 128 character  896 bit  14.3 % efficiency
         octal: 0o142140732...  42 character  294 bit  43.5 % efficiency
       base 10:   163144974...  38 character  266 bit  48.1 % efficiency
          UUID:   0c460ed3-...  36 character  252 bit  50.8 % efficiency
   hexadecimal: 0x0c460ed3b...  32 character  224 bit  57.1 % efficiency
       QQID(1):   bird.carp...  28 character  196 bit  65.3 % efficiency
   Base 64 (2):   DEYO07AVr...  22 character  154 bit  83.1 % efficiency
       Ascii85:   $q:`UYSF:...  20 character  140 bit  91.4 % efficiency
ZeroMQ(Z85)(3):   3}p-QUOBp...  20 character  140 bit  91.4 % efficiency
   Q-words (4):   bird.carp.vine.vent.call.rump.de...  28.6 % efficiency
```

(1) If we were to restrict ourselves to QQIDS that can be converted to [RFC 4122](https://tools.ietf.org/html/rfc4122) compliant UUIDs, we would get away with one less character. This benefit is minimal vs. the loss of generality.
(2) If character-based encoding were the sole objective, Base 64


...

&nbsp;

Feature matrix

Feature matrix of alternate 128-bit encoding schemes.

Efficency > 67%
IETF standard
Human readable
Safe in JSON
Safe in computer code
Safe in URLs
Safe in Excel spreadsheets





----

# 2 Functions ...

&nbsp;

The following functions are included in the package:

&nbsp;

## 2.1...


&nbsp;


#3  The `qqid` GitHub project

&nbsp;

# 5 FAQ

##### Questions?
Answer ...

&nbsp;

# 6 Notes

TBD

&nbsp;

# 7 Further reading

TBD

&nbsp;

# 8 Acknowledgements

TBD

&nbsp;

<!-- END -->
