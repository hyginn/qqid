# qMod.R

# util to create new code for the Q-list in case we need to replace words.
# Possible replacements:
spares <- c("bide",
            "flue",
            "flit",
            "pugs",
#            "prow",
            "rout",
            "tuft",
            "vend",
            "whey",
#            "wove",
            "zoom")

Q <- qMap(1:1024)
Q[grep("xt", Q)]
grep("xt", Q)

# replace 591 "next" and 884 "text" with "prow" and "wove" - reason: consonant cluster

Q <- sort(Q)
head(Q)
tail(Q)

# print

for(i in seq(0, 1023, by = 8)) {
  cat(sprintf('"%s", "%s", "%s", "%s", "%s", "%s", "%s", "%s", # %04d\n',
      Q[i+1], Q[i+2], Q[i+3], Q[i+4], Q[i+5], Q[i+6], Q[i+7], Q[i+8], i+1))
}

# paste and re-source
qMap(590:592)


for(i in seq(0, 1023, by = 16)) {
  cat(sprintf("%04d:  %s\n", i+1, paste(qMap((i+1):(i+16)), collapse = " ")))
}





# [END]
