# qqid

###### [Boris Steipe](https://orcid.org/0000-0002-1134-6758), Department of Biochemistry and Department of Molecular Genetics, University of Toronto, Canada. &lt;boris.steipe@utoronto.ca&gt;

----

**If any of this information is ambiguous, inaccurate, outdated, or incomplete, please check the [most recent version](https://github.com/hyginn/qqid) of the package on GitHub and [file an issue](https://github.com/hyginn/qqid/issues).**

----

```text
bird.carp.7TsBWtwqtKAeCTNk8f
```
This is a **QQID**. It is one of 5,316,911,983,139,663,491,615,000,000,000,000,000 unique numbers that can be produced in this format. There is really nothing I could reasonably do to get this exact same number again: it was forged in Australia by the inherent randomness of quantum fluctuations of the vacuum, interpreted in Canada, stored in GitHub's cloud, and visualized by you. Yet, I would immediately recognize that a number in one of my documents might be exactly this one: hey, _bird carp_! That's what makes QQIDs interesting.

----

# 1 Overview:

## 1.1 UUIDs

This package is about "QQIDs", not "UUIDs" in particular, but the former are based on the latter so we need to look at UUIDs first:

UUIDs (**U**niversally **U**nique **IDs**) are great wherever unique identifiers need to be created, but there is litttle or no control over their creation. A typical use case might be to manage observations by a loosely knit group of researchers who contribute data to a common project. The IDs they use locally should be preserved, so they can find them elsewhere in their notes - but we don't know who the contributers are so we can't provide them with dedicated ranges of identifiers, or they might contribute only intermittently and administering contributor-specific key prefixes would become a significant effort. However, it must be guaranteed that every key is unique. UUIDs solve this problem by drawing IDs randomly from a very large space of numbers. This means: in theory, two UUIDs could collide by chance. But in practice, a random UUID is drawn from 2<sup>122</sup> numbers, i.e. the chance of observing the same number twice is 1 / 5.3e36 - and that is less than winning the 6 of 49 lottery **five times in a row**.  UUIDs are formatted in a characteristic way from strings of 8-4-4-4-12 hyphen separated hexadecimal characters.

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
  [1] "4fe94d51-8d8d-3812-cb7c-a367c33bb431" "12e6f1d2-f0d4-4c82-5875-7ef2edc9a0dd"
  [3] "1f0ccf5d-08c5-d6a2-6b81-15f1846d9b91" "38b63615-af98-1732-4a25-88d37de03447"
  [5] "62c76edc-c07f-a282-ab25-6dd7c3d12137" "cb0f9916-fa81-3152-8970-3dbc16b154c4"
  [7] "e43cea77-6c5c-ac72-1b78-bc4557737e11" "7813f8fc-8804-75f2-1a22-c6bb64a79bd1"
  [9] "ab635041-f84e-55e2-4b7a-62a1326cccf2" "b135d71c-9176-d5f2-59a2-cad91abcfe6e"
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
  [1] "rope.scan.-uREWKgphBugcV3thQ" "hunt.foam.VPHJWIcqlm_yCkAXG6"
  [3] "jump.feet.s4qBmVgsk_IeI0LZAA" "your.that.bYnqZQ8hk45ZADuRmY"
  [5] "dean.wild.RBwMAjUim7NTbZ-W-9" "milk.four.I4M7qVctv9Dljka8ku"
  [7] "deaf.live.E1TU1KQqifA29TX7yE" "sell.bond.4bANxPwgnRLYKIMJwZ"
  [9] "grip.bore.0E3PJ5MhkTbp3ZTzVn" "skid.lids.l24UE9MtuJzAcUAf6N"
```

<!-- Collision formula estimates 
https://en.wikipedia.org/wiki/Universally_unique_identifier 
(1/2)+sqrt((1/4)+(2 * log(2) * 2^122))  UUID
(1/2)+sqrt((1/4)+(2 * log(2) * 2^64))   64 bit
-->

## 1.4  Q-words

...

&nbsp;

## 1.X QQIDs in reproducible research

Crossreferences everywhere! Barcode, watermark.

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
