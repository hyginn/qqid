# qMap.R

#' qMap
#'
#' \code{qMap} maps numbers to Q-words, or Q-words to their index in (0, 1023).
#'
#' @section Description: \code{qMap} accepts strings that are matched to Q-word
#'   indices or NA, or numbers that are matched to Q-words or NA. The returned
#'   vector has the same length as the input. Numbers that are not in (0, 1023)
#'   return NA. Strings that are not a Q-word return NA. \code{qMap(0)} is
#'   "aims", \code{qMap(1023)} is "zone". Note: the first Q-word has index 0,
#'   since it represents the bit-pattern "0000000000".
#'
#' @section Q-Words: A table of 1,024 four-letter words is encoded in this
#'   function. Four-letter English words were chosen and manually refined to
#'   yield short, unique labels that:
#'   \itemize{
#'      \item are monosyllabic,
#'      \item are easy to spell and pronounce,
#'      \item are individually not offensive,
#'      \item are unlikely to be offensive in random combination,
#'      \item are in common use,
#'      \item avoid homophones and consonant clusters,
#'      \item do not contain jargon, intentional misspellings, acronyms
#'            or overly specialized technical or sports terms. }
#'   The table is alphabetically sorted.
#'
#' @param x (character or numeric) A vector.
#' @return (numeric or character) A vector of indices, Q-words, or NA of the
#'   same length as the input.
#'
#' @author (c) 2019 \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe},
#' licensed under MIT (see file \code{LICENSE} in this package).
#'
#' @examples
#' # qMap a number
#' qMap(313)                                    # "gift"
#' # qMap four words, three can be matched.
#' qMap(c("three", "free", "cold", "beer"))     # NA 287  125  34
#' # return the entire QQ table
#' x <- qMap(0:1023)
#'
#' @export

qMap <- function(x) {

  Q <- c("aims", "ants", "arch", "arms", "arts", "aunt", "back", "bail", # 0000
         "bake", "bald", "ball", "balm", "band", "bane", "bank", "bans", # 0008
         "barb", "bare", "bark", "barn", "bars", "base", "bath", "bats", # 0016
         "bays", "bead", "beak", "beam", "bean", "bear", "beat", "beds", # 0024
         "beef", "been", "beer", "bees", "beet", "bell", "belt", "bend", # 0032
         "bent", "best", "bets", "bids", "bike", "bile", "bill", "bind", # 0040
         "bins", "bird", "bite", "bits", "blot", "blue", "blur", "boar", # 0048
         "boat", "boil", "bold", "bolt", "bond", "bone", "book", "boot", # 0056
         "bore", "born", "both", "bout", "bowl", "bows", "boys", "brag", # 0064
         "bred", "brew", "brow", "buds", "bugs", "bulb", "bulk", "bull", # 0072
         "bump", "burn", "burr", "cage", "cake", "calf", "call", "calm", # 0080
         "came", "camp", "cane", "cans", "cape", "caps", "card", "care", # 0088
         "carp", "cars", "cart", "case", "cash", "cast", "cats", "cave", # 0096
         "cell", "chat", "chef", "chew", "chin", "chip", "chop", "cite", # 0104
         "clad", "clan", "claw", "clay", "clip", "clog", "club", "clue", # 0112
         "coal", "coat", "code", "coil", "coin", "cold", "comb", "cone", # 0120
         "cook", "cool", "coop", "cope", "cord", "core", "cork", "corn", # 0128
         "cost", "coup", "cove", "cows", "crab", "crew", "crib", "crop", # 0136
         "crow", "cube", "cubs", "cues", "cuff", "cult", "cups", "curb", # 0144
         "cure", "curl", "cute", "dame", "damp", "dams", "dare", "dark", # 0152
         "dart", "dash", "date", "dawn", "days", "dead", "deaf", "deal", # 0160
         "dean", "debt", "deck", "deed", "deem", "deep", "deer", "dent", # 0168
         "desk", "died", "dies", "dine", "dirt", "dish", "disk", "dive", # 0176
         "dock", "docs", "does", "dogs", "doll", "dome", "done", "doom", # 0184
         "door", "dose", "dots", "dove", "down", "drag", "draw", "drip", # 0192
         "drop", "drug", "drum", "duck", "dues", "duke", "dull", "dump", # 0200
         "dune", "dusk", "dust", "each", "earn", "ears", "ease", "east", # 0208
         "eats", "edge", "eels", "eggs", "elks", "else", "ends", "face", # 0216
         "fact", "fade", "fail", "fair", "fake", "fall", "fame", "fang", # 0224
         "fans", "fare", "farm", "fast", "fate", "fawn", "fear", "feat", # 0232
         "feel", "fees", "feet", "fell", "felt", "fern", "feud", "figs", # 0240
         "file", "fill", "film", "find", "fine", "fins", "firm", "fish", # 0248
         "fist", "fits", "five", "flag", "flat", "flaw", "flax", "flea", # 0256
         "fled", "flew", "flex", "flip", "flop", "flow", "flux", "foal", # 0264
         "foam", "foil", "fold", "folk", "fond", "font", "food", "fool", # 0272
         "foot", "fork", "form", "fort", "foul", "four", "fowl", "free", # 0280
         "frog", "from", "fuel", "full", "fume", "fund", "fuse", "fuss", # 0288
         "gaff", "gage", "gain", "gait", "gale", "gall", "game", "gang", # 0296
         "gaps", "gash", "gate", "gave", "gaze", "gear", "gems", "gene", # 0304
         "germ", "gift", "gill", "girl", "give", "glad", "glow", "glue", # 0312
         "glum", "goal", "goat", "goes", "gold", "golf", "gone", "gong", # 0320
         "good", "gown", "grab", "gram", "gray", "grew", "grid", "grim", # 0328
         "grin", "grip", "grog", "grow", "grub", "gulf", "gull", "gust", # 0336
         "guts", "guys", "hack", "hail", "hair", "half", "hall", "halt", # 0344
         "hand", "hang", "hard", "hare", "harm", "harp", "hats", "haul", # 0352
         "have", "hawk", "haze", "head", "heal", "heap", "hear", "heat", # 0360
         "heed", "heel", "heir", "held", "helm", "help", "hemp", "hens", # 0368
         "herb", "herd", "here", "hide", "high", "hike", "hill", "hint", # 0376
         "hiss", "hits", "hive", "hoax", "hold", "home", "hone", "hood", # 0384
         "hoof", "hook", "hoop", "hope", "horn", "hose", "host", "howl", # 0392
         "huge", "hugs", "hull", "hums", "hunt", "hurt", "hush", "husk", # 0400
         "huts", "inns", "isle", "jade", "jail", "jams", "jars", "jaws", # 0408
         "jest", "jets", "jobs", "join", "joke", "jolt", "joys", "jump", # 0416
         "june", "junk", "just", "keel", "keen", "keep", "kegs", "kept", # 0424
         "keys", "kick", "kids", "kiln", "kind", "king", "kiss", "kite", # 0432
         "kits", "knee", "knew", "knit", "knot", "know", "labs", "lace", # 0440
         "lack", "laid", "lake", "lamb", "lame", "lamp", "land", "lane", # 0448
         "laps", "lark", "last", "late", "laud", "lawn", "laws", "lead", # 0456
         "leaf", "leak", "lean", "leap", "leek", "left", "legs", "lend", # 0464
         "lens", "lent", "less", "lids", "lied", "lies", "life", "lift", # 0472
         "like", "limb", "lime", "limp", "line", "link", "lint", "lips", # 0480
         "lisp", "list", "live", "load", "loaf", "loan", "lock", "lode", # 0488
         "loft", "logs", "lone", "long", "look", "loom", "loop", "lord", # 0496
         "lore", "lose", "loss", "lost", "lots", "loud", "love", "luck", # 0504
         "lull", "lump", "lung", "lure", "lurk", "lush", "lute", "lynx", # 0512
         "made", "mail", "main", "make", "male", "mall", "malt", "mane", # 0520
         "maps", "mare", "mark", "mash", "mask", "mast", "mate", "math", # 0528
         "maze", "mead", "meal", "mean", "meet", "melt", "mens", "mere", # 0536
         "mesh", "mess", "mice", "mild", "mile", "milk", "mill", "mime", # 0544
         "mind", "mine", "mink", "mint", "miss", "mist", "mite", "moat", # 0552
         "mock", "mode", "mold", "mole", "monk", "mood", "moon", "more", # 0560
         "moss", "most", "moth", "move", "much", "mugs", "mule", "muse", # 0568
         "must", "mute", "myth", "nail", "name", "nape", "near", "neat", # 0576
         "neck", "need", "nest", "nets", "news", "newt", "nice", "nick", # 0584
         "nine", "node", "none", "noon", "norm", "nose", "note", "noun", # 0592
         "oaks", "oath", "odds", "oils", "once", "ones", "owls", "owns", # 0600
         "pace", "pack", "page", "paid", "pail", "pair", "pale", "palm", # 0608
         "pane", "pant", "park", "part", "past", "path", "pave", "pawn", # 0616
         "paws", "pays", "peak", "pear", "peas", "peat", "peck", "peel", # 0624
         "peer", "pens", "perk", "pest", "pets", "pick", "pies", "pike", # 0632
         "pile", "pill", "pine", "pins", "pint", "pipe", "pits", "plan", # 0640
         "play", "plea", "plot", "plow", "ploy", "plum", "plus", "pods", # 0648
         "pole", "poll", "pond", "pool", "poor", "pope", "pork", "port", # 0656
         "pose", "post", "pots", "pour", "prep", "prey", "prod", "prop", # 0664
         "prow", "puff", "pull", "pulp", "pump", "pure", "push", "quit", # 0672
         "quiz", "raft", "rage", "rags", "raid", "rail", "rain", "rake", # 0680
         "ramp", "rang", "rank", "rant", "rare", "rash", "rate", "rats", # 0688
         "rave", "rays", "read", "real", "reap", "rear", "reed", "reef", # 0696
         "reel", "rent", "rest", "ribs", "rice", "rich", "ride", "rift", # 0704
         "ring", "rink", "ripe", "rise", "risk", "road", "roar", "robe", # 0712
         "rock", "rode", "rods", "roll", "roof", "rook", "room", "root", # 0720
         "rope", "rose", "rugs", "rule", "rump", "rung", "runs", "runt", # 0728
         "rush", "rust", "safe", "sage", "said", "sail", "salt", "same", # 0736
         "sand", "sane", "sang", "sash", "save", "saws", "says", "scam", # 0744
         "scan", "scar", "seal", "seam", "seas", "seat", "sect", "seed", # 0752
         "seek", "seem", "seen", "sees", "self", "sell", "sent", "sets", # 0760
         "shed", "shim", "shin", "ship", "shoe", "shop", "shot", "show", # 0768
         "shut", "side", "sift", "sigh", "sign", "silk", "sill", "sing", # 0776
         "sink", "sins", "site", "sits", "size", "skew", "skid", "skin", # 0784
         "skip", "slab", "slap", "slat", "sled", "slid", "slim", "slip", # 0792
         "slot", "slow", "slug", "smug", "snag", "snap", "snip", "snow", # 0800
         "soak", "soap", "soar", "sock", "soft", "soil", "sold", "sole", # 0808
         "some", "song", "sons", "soon", "soot", "sore", "sort", "soul", # 0816
         "soup", "spam", "span", "spar", "spin", "spot", "spun", "spur", # 0824
         "stab", "stag", "star", "stay", "stem", "step", "stew", "stir", # 0832
         "stop", "stow", "stub", "such", "suit", "sump", "sums", "sung", # 0840
         "sunk", "suns", "sure", "surf", "swam", "swan", "swap", "swat", # 0848
         "sway", "swim", "tabs", "tack", "tags", "tail", "take", "talk", # 0856
         "tall", "tang", "tank", "tape", "taps", "task", "teak", "teal", # 0864
         "team", "tear", "teas", "teem", "tell", "temp", "tend", "tent", # 0872
         "term", "tern", "test", "than", "that", "thaw", "thee", "them", # 0880
         "then", "they", "thin", "this", "thus", "tick", "tide", "tier", # 0888
         "ties", "tile", "till", "tilt", "time", "tine", "tint", "tips", # 0896
         "toad", "toes", "toil", "told", "toll", "tomb", "tone", "tong", # 0904
         "took", "tool", "tops", "torn", "tort", "toss", "tour", "town", # 0912
         "toys", "tram", "trap", "tray", "tree", "trim", "trip", "trod", # 0920
         "true", "tube", "tubs", "tuck", "tune", "turf", "turn", "twig", # 0928
         "twin", "type", "urge", "vain", "vase", "vast", "veer", "veil", # 0936
         "vent", "verb", "vest", "view", "vine", "vise", "void", "vole", # 0944
         "volt", "vote", "vows", "wade", "wage", "wail", "wait", "wake", # 0952
         "walk", "wall", "wand", "want", "ward", "ware", "warm", "warn", # 0960
         "warp", "wars", "wash", "wasp", "watt", "wave", "weak", "wear", # 0968
         "webs", "week", "weep", "weld", "well", "went", "were", "west", # 0976
         "what", "when", "whim", "whip", "whom", "wick", "wide", "wife", # 0984
         "wigs", "wild", "will", "wind", "wine", "wing", "wink", "wins", # 0992
         "wipe", "wise", "wish", "with", "wolf", "wood", "wool", "word", # 1000
         "wore", "work", "worm", "worn", "wove", "wrap", "wren", "yard", # 1008
         "yarn", "yawn", "year", "yell", "your", "zest", "zinc", "zone") # 1016

  if (is.numeric(x) && is.vector(x)) {
    v <- Q[match((x + 1), 1:1024)]
  } else if (is.character(x) && is.vector(x)) {
    v <- match(x, Q) - 1
  } else {
    stop("input must be a numeric or character vector.")
  }

  return(v)
}

# [END]
